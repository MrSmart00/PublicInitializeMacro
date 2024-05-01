//
//  PublicInitialization.swift
//  
//
//  Created by 日野森寛也 on 2024/04/30.
//

import SwiftSyntax
import SwiftSyntaxMacros
import SwiftSyntaxBuilder
import SwiftDiagnostics
import SwiftCompilerPlugin

public struct PublicInitialization: MemberMacro {
    public static func expansion(
        of attribute: AttributeSyntax,
        providingMembersOf declaration: some DeclGroupSyntax,
        in context: some MacroExpansionContext
    ) throws -> [DeclSyntax] {
        guard declaration.modifiers.first(where: { $0.name.text.contains("public") }) != nil else {
            context.diagnose(
                .init(
                    node: declaration,
                    message: MacroDiagnostic.notPublic
                )
            )
            return []
        }
        guard declaration.is(StructDeclSyntax.self) || declaration.is(ClassDeclSyntax.self) else {
            context.diagnose(
                .init(
                    node: declaration,
                    message: MacroDiagnostic.notStructOrClass
                )
            )
            return []
        }

        let values = declaration
            .memberBlock
            .members
            .compactMap(parse(_:))
        let parameters = values.map { $0.parameter }.joined(separator: ",\n")
        let initBody = values.enumerated().map { index, value in
            if index == 0 {
                return CodeBlockItemListSyntax.Element("\(raw: value.body)")
            } else {
                return CodeBlockItemListSyntax.Element("\n\(raw: value.body)")
            }
        }

        let initDeclSyntax = try InitializerDeclSyntax(
            SyntaxNodeString(
                stringLiteral: "public init(\n\(parameters)\n)"
            ),
            bodyBuilder: { .init(initBody) }
        )

        return ["\(raw: initDeclSyntax)"]
    }
}

extension PublicInitialization {
    struct SyntaxInfo {
        let parameter: String
        let body: String
    }

    static func parse(_ item: MemberBlockItemSyntax) -> SyntaxInfo? {
        if let syntax = item.decl.as(VariableDeclSyntax.self),
           let pattern = syntax.bindings.first,
           let identifier = pattern.pattern.as(IdentifierPatternSyntax.self)?.identifier,
           let type = pattern.typeAnnotation,
           !checkAccessors(pattern)
        {
            let parameter: String = {
                if checkSendable(type) {
                    return "\(identifier): @escaping \(type.type)"
                } else {
                    return "\(identifier): \(type.type)"
                }
            }()
            return .init(
                parameter: parameter,
                body: "self.\(identifier) = \(identifier)"
            )
        }
        return nil
    }

    static func checkSendable(_ type: TypeAnnotationSyntax) -> Bool {
        if let attributedType = type.type.as(AttributedTypeSyntax.self),
           let attributedSyntax = attributedType.attributes.first?.as(AttributeSyntax.self),
           let identifier = attributedSyntax.attributeName.as(IdentifierTypeSyntax.self),
           identifier.name.text == "Sendable"
        {
            return true
        }
        return false
    }

    static func checkAccessors(_ pattern: PatternBindingSyntax) -> Bool {
        let computedPropertyBlock = CodeBlockItemListSyntax(pattern.accessorBlock?.accessors)
        let accessorBlock = AccessorBlockSyntax(pattern.accessorBlock)
        return computedPropertyBlock != nil && accessorBlock != nil
    }
}

extension PublicInitialization {
    enum MacroDiagnostic: DiagnosticMessage {
        case notPublic
        case notStructOrClass

        var message: String {
            switch self {
            case .notPublic:
                "This macro is for public accessors only"
            case .notStructOrClass:
                "This macro is for struct or class usage only"
            }
        }
        
        var diagnosticID: SwiftDiagnostics.MessageID {
            .init(domain: "PublicInitialization", id: "\(self)")
        }
        
        var severity: SwiftDiagnostics.DiagnosticSeverity {
            .error
        }
    }
}

@main
struct PublicInitializationPlugin: CompilerPlugin {
    var providingMacros: [Macro.Type] = [PublicInitialization.self]
}

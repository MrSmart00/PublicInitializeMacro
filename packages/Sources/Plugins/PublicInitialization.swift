//
//  PublicInitialization.swift
//  
//
//  Created by 日野森寛也 on 2024/04/30.
//

import SwiftSyntax
import SwiftSyntaxMacros
import SwiftSyntaxBuilder
import SwiftCompilerPlugin

public struct PublicInitialization: MemberMacro {
    public static func expansion(
        of attribute: AttributeSyntax,
        providingMembersOf declaration: some DeclGroupSyntax,
        in context: some MacroExpansionContext
    ) throws -> [DeclSyntax] {
        guard declaration.modifiers.first(where: { $0.name.text.contains("public") }) != nil else {
            fatalError()
        }
        guard declaration.is(StructDeclSyntax.self) || declaration.is(ClassDeclSyntax.self) else {
            fatalError()
        }

        let values = declaration
            .memberBlock
            .members
            .compactMap(parse(_:))
        let parameters = values.map { $0.parameter }.joined(separator: ",\n")
        let initBody = values.map { CodeBlockItemListSyntax.Element("\(raw: $0.body) ") }

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
           let type = pattern.typeAnnotation?.type {
            let isComputedProperty = (pattern.accessorBlock != nil) == true
            let isUsingAccessors = (pattern.accessorBlock != nil) == true
            if !isComputedProperty, !isUsingAccessors {
                return .init(
                    parameter: "\(identifier): \(type)",
                    body: "self.\(identifier) = \(identifier)"
                )
            }
        }
        return nil
    }
}

@main
struct PublicInitializationPlugin: CompilerPlugin {
    var providingMacros: [Macro.Type] = [PublicInitialization.self]
}

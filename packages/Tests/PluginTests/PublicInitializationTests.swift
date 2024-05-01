//
//  PublicInitializationTests.swift
//  
//
//  Created by 日野森寛也 on 2024/04/30.
//

import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import XCTest

#if canImport(Plugins)
@testable import Plugins
#endif

final class PublicInitializationTests: XCTestCase {

    func test_Macro_With_Struct() throws {
        #if canImport(Plugins)
        let macros = [
            "PublicInit": PublicInitialization.self,
        ]
        assertMacroExpansion(
            """
            @PublicInit
            public struct Hoge {
                public let index: Int
                let text: String?
            }
            """,
            expandedSource:
            """
            public struct Hoge {
                public let index: Int
                let text: String?

                public init(
                    index: Int,
                    text: String?
                ) {
                    self.index = index
                    self.text = text
                }
            }
            """,
            macros: macros
        )
        #endif
    }
    
    func test_Macro_With_Struct_ComputedProperty() throws {
        #if canImport(Plugins)
        let macros = [
            "PublicInit": PublicInitialization.self,
        ]
        assertMacroExpansion(
            """
            @PublicInit
            public struct Hoge {
                public let index: Int
                let text: String?
                let computedProperty: Bool {
                    true
                }
            }
            """,
            expandedSource:
            """
            public struct Hoge {
                public let index: Int
                let text: String?
                let computedProperty: Bool {
                    true
                }

                public init(
                    index: Int,
                    text: String?
                ) {
                    self.index = index
                    self.text = text
                }
            }
            """,
            macros: macros
        )
        #endif
    }

    func test_Macro_With_Class() throws {
        #if canImport(Plugins)
        let macros = [
            "PublicInit": PublicInitialization.self,
        ]
        assertMacroExpansion(
            """
            @PublicInit
            public class Hoge {
                public let index: Int
                let text: String?
            }
            """,
            expandedSource:
            """
            public class Hoge {
                public let index: Int
                let text: String?

                public init(
                    index: Int,
                    text: String?
                ) {
                    self.index = index
                    self.text = text
                }
            }
            """,
            macros: macros
        )
        #endif
    }

    func test_Macro_With_No_Public() throws {
        #if canImport(Plugins)
        let macros = [
            "PublicInit": PublicInitialization.self,
        ]
        assertMacroExpansion(
            """
            @PublicInit
            class Hoge {
                public let index: Int
                let text: String?
            }
            """,
            expandedSource:
            """
            class Hoge {
                public let index: Int
                let text: String?
            }
            """,
            diagnostics: [
                DiagnosticSpec(
                    message: PublicInitialization.MacroDiagnostic.notPublic.message,
                    line: 1,
                    column: 1
                )
            ],
            macros: macros
        )
        #endif
    }

    func test_Macro_With_Enum() throws {
        #if canImport(Plugins)
        let macros = [
            "PublicInit": PublicInitialization.self,
        ]
        assertMacroExpansion(
            """
            @PublicInit
            public enum Hoge {
                case hoge
                case hogehoge
            }
            """,
            expandedSource:
            """
            public enum Hoge {
                case hoge
                case hogehoge
            }
            """,
            diagnostics: [
                DiagnosticSpec(
                    message: PublicInitialization.MacroDiagnostic.notStructOrClass.message,
                    line: 1,
                    column: 1
                )
            ],
            macros: macros
        )
        #endif
    }

}

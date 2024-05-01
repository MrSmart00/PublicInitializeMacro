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
import Plugins
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
}

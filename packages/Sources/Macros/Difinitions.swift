//
//  File.swift
//  
//
//  Created by 日野森寛也 on 2024/04/30.
//

@attached(member, names: named(init))
public macro Public() = #externalMacro(
    module: "Plugins",
    type: "PublicInitialization"
)

# PublicInitializeMacro
![Static Badge](https://img.shields.io/badge/xcode-15.3-000000.svg?logo=Xcode&style=for-the-badge)
![Static Badge](https://img.shields.io/badge/swift-5.10-000000.svg?logo=Swift&style=for-the-badge)

Super Simple Swift Macro Part 2

| Normal | Expand |
|:--:|:--:|
| <img width=300 src='https://github.com/MrSmart00/PublicInitializeMacro/assets/8654605/44bf6550-5847-42f4-a0ed-e1179ac0a832' /> | <img width=300 src='https://github.com/MrSmart00/PublicInitializeMacro/assets/8654605/66ed05f1-e97f-4d7a-bec9-5beead9590c0' /> |

## SUMMARY

This is a sample project that adds a macro for generating constructors for public structs or classes to an existing app project.

## STRUCTURE

```
.
├── Sandbox
│   ├── Sandbox
│   │   ├── Sandbox.xctestplan
│   │   └── SandboxApp.swift
│   └── Sandbox.xcodeproj
├── packages
│   ├── Package.swift
│   ├── Sources
│   │   ├── App
│   │   │   └── ContentView.swift
│   │   ├── Entity
│   │   │   └── Entity.swift
│   │   ├── Macros
│   │   │   └── Difinitions.swift
│   │   └── Plugins
│   │       └── PublicInitialization.swift
│   └── Tests
│       └── PluginTests
│           └── PublicInitializationTests.swift
└── public-initialize-macro.xcworkspace
```

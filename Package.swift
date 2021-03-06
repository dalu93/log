// swift-tools-version:4.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Log",
    products: [
        .library(
            name: "Log",
            targets: ["Log"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/orta/Komondor", from: "1.0.0"), // dev

        .package(url: "https://github.com/nicklockwood/SwiftFormat", from: "0.35.8"), // dev

        .package(url: "https://github.com/Realm/SwiftLint", from: "0.28.1"), // dev

        .package(url: "https://github.com/f-meloni/Rocket", from: "0.4.0"), // dev
    ],
    targets: [
        .target(
            name: "Log",
            dependencies: []
        ),
        .testTarget(
            name: "LogTests",
            dependencies: ["Log"]
        ),
    ]
)

#if canImport(PackageConfig)
    import PackageConfig

    let config = PackageConfig([
        "komondor": [
            "pre-push": "swift test",
            "pre-commit": [
                "swift run swiftformat Sources/",
                "swift run swiftformat Package.swift",
                "swift run swiftlint autocorrect --path Sources/",
                "git add .",
            ],
        ],
        "rocket": ["steps":
            [
                ["script": ["content": "echo \"Releasing $VERSION\""]],
                "hide_dev_dependencies",
                ["git_add": ["paths": ["Package.swift"]]],
                ["commit": [
                    "message": "Release of version $VERSION",
                    "no_verify": true,
                ]],
                "tag",
                "unhide_dev_dependencies",
                ["git_add": ["paths": ["Package.swift"]]],
                ["commit": [
                    "message": "Unhide dev dependencies",
                    "no_verify": true,
                ]],
                "push",
                ["script": ["content": "echo \"Version $VERSION release 🎉\""]],
        ]],
    ])
#endif

//
//  Project+Extension.swift
//  TuistExtensions
//
//  Created by Importants on 3/21/25.
//

import ProjectDescription

extension Project {
    public static func project(
        config: Config
    ) -> Project {
        var targets: [Target]
        switch config.product {
        case .app, .framework:
            targets = [
                config.product == .app ?
                // App
                    .target(
                        name: config.name,
                        destinations: [.iPhone],
                        product: config.product,
                        bundleId: "$(APP_IDENTIFIER)",
                        deploymentTargets: config.deploymentTargets,
                        infoPlist: .file(path: Path.plistPath(
                            appName: config.name,
                            plistName: "Info")),
                        sources: config.sources,
                        resources: config.resources,
                        entitlements: .file(path: .entitlementPath(
                            appName: config.name,
                            entitleName: "Notification")),
                        scripts: config.scripts,
                        dependencies: config.dependencies,
                        settings: .settings(
                            configurations: Configuration.createAppConfiguration(
                                appName: config.name,
                                configurations: Configuration.ConfigScheme.allCases
                            )
                        )
                    ) :
                    // Framework
                    .target(
                        name: config.name,
                        destinations: .iOS,
                        product: config.product,
                        bundleId: "com.cudo.\(config.name)",
                        deploymentTargets: config.deploymentTargets,
                        sources: ["Sources/**"],
                        resources: config.resources,
                        scripts: config.scripts,
                        dependencies: config.dependencies,
                        settings: .settings(
                            configurations: Configuration.makeModuleConfiguration()
                        )
                    ),
                // Test
                .target(
                    name: "\(config.name)Tests",
                    destinations: .iOS,
                    product: .unitTests,
                    bundleId: self.teamId + ".\(config.name)Tests",
                    deploymentTargets: config.deploymentTargets,
                    sources: config.testSources,
                    dependencies: [.target(name: config.name)],
                    settings: .settings(
                        configurations: Configuration.makeModuleConfiguration()
                    )
                )
            ]
        case .bundle:
            targets = [
                .target(
                    name: config.name,
                    destinations: .iOS,
                    product: config.product,
                    bundleId: "com.bundle.\(config.name)",
                    deploymentTargets: config.deploymentTargets,
                    resources: config.resources,
                    settings: .settings(
                        base: [
                            "GENERATE_ASSET_SYMBOLS": "YES"
                        ],
                        configurations: Configuration.makeModuleConfiguration()
                    )
                )
            ]
        default: fatalError()
        }
        return .init(
            name: config.name,
            packages: config.packages,
            targets: targets + config.customTargets,
            resourceSynthesizers: [
                .custom(name: "Assets", parser: .assets, extensions: ["xcassets"]),
                .custom(name: "Fonts", parser: .fonts, extensions: ["otf"]),
            ]
        )
    }
    
    public static func app(
        name: String,
        customTargets: [Target] = [],
        extensionSources: SourceFilesList = [],
        packages: [Package] = [],
        dependencies: [TargetDependency] = [],
        resources: ProjectDescription.ResourceFileElements? = nil,
        sources: SourceFilesList? = [],
        testSources: SourceFilesList? = []
    ) -> Project {
        self.project(
            config: ProjectConfig.init(
                name: name,
                customTargets: customTargets,
                extensionSources: extensionSources,
                packages: packages,
                dependencies: dependencies,
                resources: resources,
                sources: sources,
                testSources: testSources
            )
        )
    }
    
    public static func framework(
        name: String,
        customTargets: [Target] = [],
        packages: [Package] = [],
        dependencies: [TargetDependency] = [],
        resources: ProjectDescription.ResourceFileElements? = nil,
        sources: SourceFilesList? = []
    ) -> Project {
        self.project(
            config: FrameworkConfig.init(
                name: name,
                customTargets: customTargets,
                packages: packages,
                dependencies: dependencies,
                resources: resources,
                sources: sources
            )
        )
    }
    
    public static func bundle(
        name: String,
        resources: ProjectDescription.ResourceFileElements? = nil
    ) -> Project {
        self.project(
            config: BundleConfig.init(
                name: name,
                resources: resources
            )
        )
    }
}

//
//  Project+Type.swift
//  TuistExtensions
//
//  Created by Importants on 3/21/25.
//

import ProjectDescription
import Foundation

public struct ProjectType {
    public struct Config {
        public let name: String
        public let dependencies: [TargetDependency]
        public let sources: SourceFilesList?
        public let resources: ResourceFileElements?
        public let testSources: SourceFilesList?
        public let customTargets: [Target]
        public let extensionSources: SourceFilesList?
        public let extensionResources: ResourceFileElements?
        
        init(
            name: String,
            dependencies: [TargetDependency],
            sources: SourceFilesList? = [],
            resources: ResourceFileElements? = nil,
            testSources: SourceFilesList? = [],
            customTargets: [Target] = [],
            extensionSources: SourceFilesList? = [],
            extensionResources: ResourceFileElements? = nil
        ) {
            self.name = name
            self.dependencies = dependencies
            self.sources = sources
            self.resources = resources
            self.testSources = testSources
            self.customTargets = customTargets
            self.extensionSources = extensionSources
            self.extensionResources = extensionResources
        }
    }

    public static func getConfig() -> Config {
        let configName = "Notification"
        return Config(
            name: configName,
            dependencies: [
                Module.Utils.project,
                .target(name: "NotificationService")
            ],
            sources: [
                "Main/Sources/**",
            ],
            resources: [.glob(pattern: .relativeToRoot("SupportFiles/AppResources/**"))],
            testSources: [
                "Main/Tests/**",
            ],
            customTargets: [
                .target(
                    name: "NotificationService",
                    destinations: [.iPhone],
                    product: .appExtension,
                    bundleId: "com.importants.notification.notificationservice",
                    infoPlist: .extendingDefault(with: [
                        "CFBundleDisplayName": "$(PRODUCT_NAME)",
                        "NSExtension": [
                            "NSExtensionPointIdentifier": "com.apple.usernotifications.service",
                            "NSExtensionPrincipalClass": "$(PRODUCT_MODULE_NAME).NotificationService",
                        ],
                    ]),
                    sources: ["NotificationService/Sources/**"]
                )
            ]
        )
    }
}

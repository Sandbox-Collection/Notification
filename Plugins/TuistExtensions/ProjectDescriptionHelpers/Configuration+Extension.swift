//
//  Configuration+Extension.swift
//  TuistExtensions
//
//  Created by Importants on 3/21/25.
//

import ProjectDescription

public extension Configuration {
    enum ConfigScheme: ConfigurationName, CaseIterable {
        case debug = "Debug"
        case stage = "Stage"
        case release = "Release"
    }
    
    static func createAppConfiguration(
        appName: String = "",
        configurations: [ConfigScheme]
    ) -> [Configuration] {
        configurations.map { configScheme -> Configuration in
            let configName = configScheme.rawValue
            return configName == .release ?
                .release(
                    name: configName,
                    xcconfig: .xcconfigPath(
                        appName: appName,
                        xcconfigName: configName.rawValue)
                ) :
                .debug(
                    name: configName,
                    xcconfig: .xcconfigPath(
                        appName: appName,
                        xcconfigName: configName.rawValue)
                )
        }
    }
    
    static func makeModuleConfiguration(
    ) -> [Configuration] {
        [
            .debug(
                name: "Debug",
                xcconfig: .xcconfigPath(
                    xcconfigName: "Module")
            ),
            release(
                name: "Release",
                xcconfig: .xcconfigPath(
                    xcconfigName: "Module")
            )
        ]
    }
}

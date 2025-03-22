//
//  Path+Extension.swift
//  TuistExtensions
//
//  Created by Importants on 3/21/25.
//

import ProjectDescription

extension Path {
    public static func plistPath(
        appName: String = "",
        plistName: String) -> Path {
        let path = appName.isEmpty ? "" : "\(appName)/"
        return .relativeToRoot("SupportFiles/InfoPlist/\(plistName).plist")
    }
    
    public static func xcconfigPath(
        appName: String = "",
        xcconfigName: String
    ) -> Path {
        let path = appName.isEmpty ? "" : "\(appName)/"
        return .relativeToRoot("SupportFiles/XCConfigs/\(xcconfigName).xcconfig")
    }
    
    public static func entitlementPath(
        appName: String = "",
        entitleName: String
    ) -> Path {
        let path = appName.isEmpty ? "" : "\(appName)/"
        return .relativeToRoot("SupportFiles/Entitlements/\(entitleName).entitlements")
    }
    
    public static func scriptPath(_ scriptName: String) -> Path {
        return .relativeToRoot("SupportFiles/Tools/\(scriptName)")
    }
}

//
//  Module+Type.swift
//  TuistExtensions
//
//  Created by Importants on 3/21/25.
//

import ProjectDescription

public enum Module: String {
    case Utils
    
    public var path: ProjectDescription.Path {
        .relativeToRoot("Projects/" + self.rawValue)
    }
    
    public var project: TargetDependency {
        .project(target: self.rawValue, path: self.path)
    }
}

extension Module: CaseIterable {}

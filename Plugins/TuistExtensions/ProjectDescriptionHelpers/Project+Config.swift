//
//  Project+Config.swift
//  TuistExtensions
//
//  Created by Importants on 3/21/25.
//

import ProjectDescription

public protocol Config {
    var name: String { get }
    var product: Product { get }
    var deploymentTargets: DeploymentTargets { get }
    var schemes: [Scheme] { get }
    var customTargets: [Target] { get }
    var extensionSources: SourceFilesList { get }
    var packages: [Package] { get }
    var scripts: [TargetScript] { get }
    var dependencies: [TargetDependency] { get }
    var resources: ResourceFileElements? { get }
    var sources: SourceFilesList? { get }
    var testSources: SourceFilesList? { get }
}

public struct ProjectConfig: Config {
    public let name: String
    public let product: Product
    public let deploymentTargets: DeploymentTargets
    public let schemes: [Scheme]
    public let customTargets: [Target]
    public let extensionSources: SourceFilesList
    public let packages: [Package]
    public let scripts: [TargetScript]
    public let dependencies: [TargetDependency]
    public let resources: ResourceFileElements?
    public let sources: SourceFilesList?
    public let testSources: SourceFilesList?
    
    public init(
        name: String,
        deploymentTargets: DeploymentTargets = Project.deployTarget,
        schemes: [Scheme] = [],
        customTargets: [Target] = [],
        extensionSources: SourceFilesList = [],
        packages: [Package] = [],
        scripts: [TargetScript] = [],
        dependencies: [TargetDependency] = [],
        resources: ResourceFileElements? = nil,
        sources: SourceFilesList? = ["Sources/**"],
        testSources: SourceFilesList? = ["Tests/**"]
    ) {
        self.name = name
        self.product = .app
        self.deploymentTargets = deploymentTargets
        self.schemes = schemes
        self.customTargets = customTargets
        self.extensionSources = extensionSources
        self.packages = packages
        self.scripts = scripts
        self.dependencies = dependencies
        self.resources = resources
        self.sources = sources
        self.testSources = testSources
    }
}

public struct FrameworkConfig: Config {
    public let name: String
    public let product: Product
    public let deploymentTargets: DeploymentTargets
    public let schemes: [Scheme]
    public let customTargets: [Target]
    public let extensionSources: SourceFilesList
    public let packages: [Package]
    public let scripts: [TargetScript]
    public let dependencies: [TargetDependency]
    public let resources: ResourceFileElements?
    public let sources: SourceFilesList?
    public let testSources: SourceFilesList?
    
    public init(
        name: String,
        deploymentTargets: DeploymentTargets = Project.deployTarget,
        schemes: [Scheme] = [],
        customTargets: [Target] = [],
        extensionSources: SourceFilesList = [],
        packages: [Package] = [],
        scripts: [TargetScript] = [],
        dependencies: [TargetDependency] = [],
        resources: ResourceFileElements? = nil,
        sources: SourceFilesList? = ["Sources/**"],
        testSources: SourceFilesList? = ["Tests/**"]
    ) {
        self.name = name
        self.product = .framework
        self.deploymentTargets = deploymentTargets
        self.schemes = schemes
        self.customTargets = customTargets
        self.extensionSources = extensionSources
        self.packages = packages
        self.scripts = scripts
        self.dependencies = dependencies
        self.resources = resources
        self.sources = sources
        self.testSources = testSources
    }
}

public struct BundleConfig: Config {
    public let name: String
    public let product: Product
    public let deploymentTargets: DeploymentTargets
    public let schemes: [Scheme]
    public let customTargets: [Target]
    public let extensionSources: SourceFilesList
    public let packages: [Package]
    public let scripts: [TargetScript]
    public let dependencies: [TargetDependency]
    public let resources: ResourceFileElements?
    public let sources: SourceFilesList?
    public let testSources: SourceFilesList?
    
    public init(
        name: String,
        deploymentTargets: DeploymentTargets = Project.deployTarget,
        schemes: [Scheme] = [],
        customTargets: [Target] = [],
        extensionSources: SourceFilesList = [],
        packages: [Package] = [],
        scripts: [TargetScript] = [],
        dependencies: [TargetDependency] = [],
        resources: ResourceFileElements? = nil,
        sources: SourceFilesList? = ["Sources/**"],
        testSources: SourceFilesList? = ["Tests/**"]
    ) {
        self.name = name
        self.product = .bundle
        self.deploymentTargets = deploymentTargets
        self.schemes = schemes
        self.customTargets = customTargets
        self.extensionSources = extensionSources
        self.packages = packages
        self.scripts = scripts
        self.dependencies = dependencies
        self.resources = resources
        self.sources = sources
        self.testSources = testSources
    }
}

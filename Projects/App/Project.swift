import TuistExtensions
import ProjectDescription

nonisolated(unsafe) let projectConfig = ProjectType.getConfig()

let rootProject = Project.app(
    name: projectConfig.name,
    customTargets: projectConfig.customTargets,
    dependencies: projectConfig.dependencies,
    resources: projectConfig.resources,
    sources: projectConfig.sources,
    testSources: projectConfig.testSources
)

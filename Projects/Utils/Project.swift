import TuistExtensions
import ProjectDescription

let utilsProject = Project.framework(
    name: Module.Utils.rawValue,
    packages: [
        .remote(url: "https://github.com/firebase/firebase-ios-sdk", requirement: .upToNextMajor(from: "11.10.0")),
    ],
    dependencies: [
        .package(product: "FirebaseMessaging", type: .runtime)
    ]
)

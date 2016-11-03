import PackageDescription

let package = Package(
  name: "Noonian",
  targets: [
    Target(name: "noonian"),
  ],
  dependencies: [
    .Package(url: "https://github.com/Carthage/Commandant.git", majorVersion: 0),
    .Package(url: "https://github.com/behrang/YamlSwift.git", majorVersion: 3)
  ]
)

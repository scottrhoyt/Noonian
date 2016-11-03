import PackageDescription

let package = Package(
  name: "noonian",
  targets: [
    Target(name: "noonian"),
  ],
  dependencies: [
    .Package(url: "https://github.com/Carthage/Commandant.git", majorVersion: 0),
    .Package(url: "https://github.com/scottrhoyt/YamlSwift.git", majorVersion: 3)
  ]
)

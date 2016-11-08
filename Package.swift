import PackageDescription

let package = Package(
  name: "Noonian",
  targets: [
    Target(name: "NoonianKit"),
    Target(
      name: "noonian",
      dependencies: ["NoonianKit"]
    ),
  ],
  dependencies: [
    .Package(url: "https://github.com/scottrhoyt/Commandant.git", majorVersion: 0),
    .Package(url: "https://github.com/behrang/YamlSwift.git", majorVersion: 3),
    .Package(url: "https://github.com/thoughtbot/Curry.git", majorVersion: 3),
    .Package(url: "https://github.com/onevcat/Rainbow", majorVersion: 2),
  ]
)

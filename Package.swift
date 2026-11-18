// swift-tools-version:5.9
import PackageDescription

// SILENT and RARDLL change unrar structures, so both targets must be compiled with them, as unrar-lib subspec does
let unrarSettings: [CXXSetting] = [
    .define("SILENT"),
    .define("RARDLL")
]

let package = Package(
    name: "UnrarKit",
    defaultLocalization: "en",
    platforms: [.iOS(.v12), .macOS(.v10_13)],
    products: [
        .library(name: "UnrarKit", targets: ["UnrarKit"])
    ],
    targets: [
        .target(
            name: "UnrarKit",
            dependencies: ["UnrarLib"],
            path: ".",
            // SwiftPM picks xibs and lproj folders under the target path as resources even outside of sources
            exclude: [
                "Example",
                "Libraries",
                "Scripts",
                "Tests",
                "UnrarKit.xcodeproj",
                "UnrarKit.xcworkspace",
                "Resources/UnrarKit-Info.plist",
                "Resources/UnrarKitResources-Info.plist"
            ],
            sources: ["Classes"],
            resources: [.process("Resources")],
            // Symlinks to public headers, so <UnrarKit/...> imports resolve as with the framework
            publicHeadersPath: "Classes/include",
            cSettings: [
                .headerSearchPath("Classes"),
                .headerSearchPath("Classes/Categories"),
                .headerSearchPath("Libraries/unrar")
            ],
            cxxSettings: unrarSettings + [
                .headerSearchPath("Classes"),
                .headerSearchPath("Classes/Categories"),
                .headerSearchPath("Libraries/unrar")
            ],
            linkerSettings: [.linkedLibrary("z")]
        ),
        .target(
            name: "UnrarLib",
            path: "Libraries/unrar",
            // Same list as unrar-lib subspec, other .cpp files are included by these ones
            sources: [
                "rar.cpp",
                "strlist.cpp",
                "strfn.cpp",
                "pathfn.cpp",
                "smallfn.cpp",
                "global.cpp",
                "file.cpp",
                "filefn.cpp",
                "filcreat.cpp",
                "archive.cpp",
                "arcread.cpp",
                "unicode.cpp",
                "system.cpp",
                "crypt.cpp",
                "crc.cpp",
                "rawread.cpp",
                "encname.cpp",
                "resource.cpp",
                "match.cpp",
                "timefn.cpp",
                "rdwrfn.cpp",
                "consio.cpp",
                "options.cpp",
                "errhnd.cpp",
                "rarvm.cpp",
                "secpassword.cpp",
                "rijndael.cpp",
                "getbits.cpp",
                "sha1.cpp",
                "sha256.cpp",
                "blake2s.cpp",
                "hash.cpp",
                "extinfo.cpp",
                "extract.cpp",
                "volume.cpp",
                "list.cpp",
                "find.cpp",
                "unpack.cpp",
                "headers.cpp",
                "threadpool.cpp",
                "rs16.cpp",
                "cmddata.cpp",
                "ui.cpp",
                "filestr.cpp",
                "recvol.cpp",
                "rs.cpp",
                "scantree.cpp",
                "qopen.cpp",
                "dll.cpp"
            ],
            // No public headers: UnrarKit includes unrar headers by search path, so they aren't built as a module
            publicHeadersPath: "include",
            cxxSettings: unrarSettings,
            linkerSettings: [.linkedLibrary("c++")]
        )
    ]
)

//
//  McBrew.swift
//  MCxSystemExecOsax
//
//  Created by marc-medley on 2023.05.09.
//  Copyright © 2023 marc-medley. All rights reserved.

import Foundation

public enum McBrewError: Error {
    case brewNotInstalled
    case formulaNotInstalled
    /// not listed. needs to be added.
    case formulaNotRegistered
    case unknown
}

struct BrewFormula {
    let name: String
    /// list binary tools installed
    /// `ls $(brew --repo)/bin`
    let bin: [String]
    /// list installed formula dependencies of FORMULA
    /// `brew deps --installed FORMULA` 
    let deps: [String]?
    let info: String?
}

extension BrewFormula: Hashable {}

struct McBrew {
    public static let cmd = McBrew()
    
    private let _fm = FileManager.default
    /// /opt/homebrew // Apple M1
    /// /usr/local    // Intel
    private var _brewBasePath: String?
    private var _brewCmdUrl: URL?

    /// binary tools install by formulae. follows `_formulae`
    private var _bin = Set<String>()
    /// main formula dictionary. leads `_bin`
    private var _formulae = [String:BrewFormula]()
    
    init() {
        if _fm.fileExists(atPath: "/opt/homebrew/bin/brew") {
            // Apple M1 processor
            _brewBasePath = "/opt/homebrew"
            _brewCmdUrl = URL(fileURLWithPath: "/opt/homebrew/bin/brew", isDirectory: false)
        } else if _fm.fileExists(atPath: "/usr/local/bin/brew") {
            // Intel processor
            _brewBasePath = "/usr/local"
            _brewCmdUrl = URL(fileURLWithPath: "/usr/local/bin/brew", isDirectory: false)
        } else {
            _brewBasePath = nil
            _brewCmdUrl = nil
        }
        
        add("brew", info: "Homebrew")
        
        add("cmake", bin: ["ccmake", "cmake", "cpack", "ctest"], info: "CMake")
        add("cmake-docs", bin: [], info: "CMake Documentation")
        add("cocoapods", bin: ["pod"], info: "CocoaPods")
        add("ffmpeg", bin: ["ffmpeg", "ffprobe"],deps: ["cmake", "pkg-config"], info: "FFMpeg")
        
        
        add("clamav", bin: ["clamscan", "freshclam"], deps: ["cmake", "pkg-config"], info: "ClamAV")
        add("pandoc", info: "Pandoc universal document converter")
        add("pkg-config", info: "Manage compile and link flags for libraries")
        add("tesseract", bin: ["tesseract"],deps: ["pkg-config"], info: "OCR (Optical Character Recognition) engine.") // more tools in …/bin
        add("sl", info: "Prints a steam locomotive.")
        
        // ------
        // "autoconf", "autoheader", "autom4te", "autoreconf", "autoscan", "autoupdate"    "ifnames"
        add("autoconf", bin: ["autoconf"], info: "Automatic configure script builder")

    }
    
    mutating func add(_ formula: String, deps: [String]? = nil, info: String? = nil) {
        add(formula, bin: [formula], deps: deps, info: info)
    }
    
    mutating func add(_ name: String, bin: [String], deps: [String]? = nil, info: String? = nil) {
        let formula = BrewFormula(name: name, bin: bin, deps: deps, info: info)
        _formulae[formula.name] = formula
        for binaryName in formula.bin {
            _bin.insert(binaryName)
        }
    }
    
    func install(formula name: String) throws {
        guard let brewCmdUrl = _brewCmdUrl else {
            throw McBrewError.brewNotInstalled
        }
        guard let f = _formulae[name] else {
            throw McBrewError.formulaNotRegistered
        }
        do {
            if try isInstalled(formula: f.name) {
                print(":McBrew.install(): formula '\(f.name)' is already installed")
                return // already installed. no work to do.
            }
        } catch {
            throw error
        }
        
        if let dependencies = f.deps {
            for dependency in dependencies {
                do {
                    try install(formula: dependency)
                } catch {
                    throw error
                }
            }
        }
        
        var args: [String] = []
        args += ["install"]
        args += [f.name]
        
        _ = McProcess.run(
            executableUrl: brewCmdUrl, 
            withArguments: args
        )
        
        print(":McBrew.install(): \(name) installation completed")
    }
    
//    func installAll() {
//        for f in _formulae {
//            // install(formula: f.key)
//        }
//    }
    
    func isInstalled(formula: String) throws -> Bool {
        guard let brewBasePath = _brewBasePath, let brewCmdUrl = _brewCmdUrl else {
            throw McBrewError.brewNotInstalled
        }
        if let f = _formulae[formula] {
            if let binaryName = f.bin.first {
                return isInstalled(binaryName: binaryName)
            } else {
                var args: [String] = []
                args += ["info"]
                args += [f.name]
 
                //let cmdUrl = try McProcessPath.cmd.url(name: "gm")
                let r = McProcess.run(
                    executableUrl: brewCmdUrl, 
                    withArguments: args
                )
                
                //return !r.stdout.uppercased().contains("NOT INSTALLED")
                return r.stdout.contains(brewBasePath)
            }
        }
        return false
    }

    func isInstalled(binaryName: String) -> Bool {
        guard let brewBasePath = _brewBasePath else { return false }        
        let path = "\(brewBasePath)/bin/\(binaryName)"
        
        if _fm.fileExists(atPath: path) {
            return true
        } else {
            return false
        }
    }
    
    func isHomebrew(binaryName: String) -> Bool {
        if _bin.contains(binaryName) {
            return true
        }
        return false
    }
    
    func listUninstalledFormula() throws -> [String] {
        var result = [String]()
        for formula in _formulae {
            do {
                if try isInstalled(formula: formula.key) == false {
                    result.append(formula.key)
                }
            } catch {
                throw error
            }
        }
        return result
    }
    
    func path(binaryName: String) -> String? {
        guard let brewBasePath = _brewBasePath else { return nil }        
        if _bin.contains(binaryName) {
            return "\(brewBasePath)/bin/\(binaryName)"
        }
        return nil
    }
    
    func url(binaryName: String) -> URL? {
        fatalError("NYI")
    }
    
}

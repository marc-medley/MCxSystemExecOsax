//
//  McBrew.swift
//  MCxSystemExecOsax
//
//  Created by marc-medley on 2023.05.09.
//  Copyright © 2023 marc-medley. All rights reserved.

import Foundation

public enum McBrewError: Error {
    case brewNotInstalled
    case formulaNotInstalled(name: String)
    /// not listed. needs to be added.
    case formulaNotRegistered(name: String)
    case unknown
}

struct BrewFormula {
    let name: String
    /// list binary tools installed
    /// `ls $(brew --repo)/bin`
    let bin: [String]
    /// list installed formula dependencies of FORMULA
    /// `brew deps --installed FORMULA` 
    /// Note: selected subset of dependencies to be expressly installed.
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
        add("ffmpeg", bin: ["ffmpeg", "ffprobe"], deps: ["cmake", "pkg-config"], info: "FFMpeg")
        
        
        add("clamav", bin: ["clamscan", "freshclam"], deps: ["cmake", "pkg-config"], info: "ClamAV")
        add("pandoc", info: "Pandoc universal document converter")
        add("pkg-config", info: "Manage compile and link flags for libraries")
        add("tesseract", bin: ["tesseract"], deps: ["pkg-config"], info: "OCR (Optical Character Recognition) engine.") // more tools in …/bin
        add("sl", info: "Prints a steam locomotive.")
        
        // ------
        // "autoconf", "autoheader", "autom4te", "autoreconf", "autoscan", "autoupdate", "ifnames"
        add("autoconf", bin: ["autoconf"], info: "Automatic configure script builder")
        
        // --- ADD IN --- check binaryNames
        add("freerdp", bin: ["xfreerdp"], info: "FreeRDP `xfreerdp /help`")
        
        add("graphicsmagick", bin: ["gm"], deps: ["pkg-config"], info: "man GraphicsMagick")
        
        add("gnuplot", bin: ["gnuplot"], deps: ["pkg-config"], info: "")
        
        add("graphviz", bin: ["graphviz"], deps: ["autoconf", "pkg-config"], info: "")
        
        add("ghostscript", bin: ["gs"], info: "Ghostscript: more tools /…/Cellar/ghostscript/*/bin")
        
        //// --- icoutils ---
        // "extresso" "genresscript" are optional perl scripts
        add("icoutils", bin: ["icotool", "wrestool"], info: "`icotool` converts between `.ico`|`.cur` and `.png`. `wrestool` extracts icons|cursors from MS executable|library")
        
        add("imagemagick", bin: ["identify", "magick", "mogrify"], info: "man ImageMagick")
        
        /// --- Markdown (various) ---
        /// Note, not installed due to binary conflicts:
        /// * cmark conflicts with cmark-gfm
        /// * discount `markdown`, original `markdown` (Perl), and `mtools` conflict with multimarkdown `markdown`
        add("cmark-gfm", bin: ["cmark-gfm"], deps: ["cmake"], info: "GitHub Flavored Markdown fork of `cmark` commonmark")
        //add("hoedown", bin: ["hoedown"], info: "C-based Markdown processing")
        add("multimarkdown", bin: ["markdown", "multimarkdown", "mmd", "mmd2all", "mmd2epub", "mmd2fodt", "mmd2odt", "mmd2opml", "mmd2pdf", "mmd2tex"], info: "Turn marked-up plain text into well-formatted documents.")
        
        // Octave: mkoctfile, octave-config
        add("octave", bin: ["octave", "octave-cli"], deps: ["ghostscript", "gnuplot", "graphicsmagick", "vtk", "pkg-config"], info: "Octave")
        
        //// :NYI: opencv
        add("opencv", bin: ["ffmpeg", "vtk"], info: "")
        
        add("poppler", bin: ["pdfattach", "pdfdetach", "pdffonts", "pdfimages", "pdfinfo", "pdfseparate", "pdfsig", "pdftocairo", "pdftohtml", "pdftoppm", "pdftops", "pdftotext", "pdfunite"], deps: ["cmake", "pkg-config"], info: "Poppler PDF rendering library (based on the xpdf-3.0 code base)")
        
        //"swiftlint",
        add("swiftlint", bin: ["swiftlint"], info: "SwiftLint tool to enforce Swift style and conventions")
        
        //add("tcl-tk", bin: [""], info: "Tool Command Language")
        
        add("tidy-html5", bin: ["tidy"], deps: ["cmake"], info: "Granddaddy of HTML tools, with support for modern standards")
        
        add("tree", bin: ["tree"], info: "")
        
        add("uchardet", bin: ["uchardet"], deps: ["cmake"], info: "encoding detector library")
        
        add("vapor", bin: ["vapor"], info: "Command-line tool for Vapor (Server-side Swift web framework)")
        
        // :???: check for install binary
        add("vtk", bin: [""], deps: ["cmake"], info: "Toolkit for 3D computer graphics, image processing, and visualization")
        
        //"wget",
        add("wget", bin: ["wget"], deps: ["pkg-config"], info: "wget internet file retriever")
        
        //"yt-dlp",      // youtube-dl fork with additional features and fixes
        add("yt-dlp", bin: ["yt-dlp"], info: "yt-dlp fork of youtube-dl with additional features and fixes")
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
        print(":McBrew.install(): \(name) installation started")
        guard let brewCmdUrl = _brewCmdUrl else {
            throw McBrewError.brewNotInstalled
        }
        guard let f = _formulae[name] else {
            throw McBrewError.formulaNotRegistered(name: name)
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
    
    func installAll() throws {
        for f in _formulae {
            do {
                try install(formula: f.key)
            } catch{
                throw error
            }
        }
    }
    
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

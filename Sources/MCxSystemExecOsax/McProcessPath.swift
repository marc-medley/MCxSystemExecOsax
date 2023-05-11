//
//  McProcessPath.swift
//  MCxSystemExecOsax
//
//  Created by marc-medley on 2017.04.03.
//  Copyright © 2017 marc-medley. All rights reserved.
//

import Foundation

public enum McProcessPathError: Error {
    case notInstalled
    case unknown
}

public class McProcessPath {
    
    public static let cmd = McProcessPath()
    //
    private let _fm = FileManager.default
    
    private let __formulae = [
        "xfreerdp",                      // FreeRDP `xfreerdp /help`
        "gm",                            // man GraphicsMagick
        "gnuplot",
        // :NYI: graphviz collection
        "gs",        // Ghostscript: more tools /…/Cellar/ghostscript/*/bin
        // --- icoutils ---
        // "wrestool", // extract icons|cursors from MS executable|library
        // "extresso" "genresscript" are optional perl scripts
        "icotool",    // convert between `.ico`|`.cur` and `.png`
        // --- ImageMagic ---
        "identify", "magick", "mogrify", // man ImageMagick
        // --- Markdown (various) ---
        "cmark-gfm",     // .XOR. cmark 
        "hoedown",
        "markdown",      // multimarkdown .XOR. discount .XOR. original markdown (Perl)
        "multimarkdown", // .XOR. discount .XOR. markdown .XOR. mtools
        "mmd", "mmd2all", "mmd2epub", "mmd2fodt",    // multimarkdown
        "mmd2odt", "mmd2opml", "mmd2pdf", "mmd2tex", // multimarkdown 
        // ---
        "octave", "octave-cli",              // Octave "mkoctfile", "octave-config"
        // :NYI: opencv
        // Poppler pdf*
        "pdfattach", "pdfdetach", "pdffonts", "pdfimages", "pdfinfo",
        "pdfseparate", "pdfsig", "pdftocairo", "pdftohtml", "pdftoppm",
        "pdftops", "pdftotext", "pdfunite",
        "swiftlint",
        // :NYI: "tcl-tk"
        "tidy",        // tidy-html5
        "tree",
        "uchardet",
        "vapor",
        "wget",
        "yt-dlp",      // youtube-dl fork with additional features and fixes
    ]
    
    public func url(binaryName: String) throws -> URL {
        var path: String?
        
        if McBrew.cmd.isHomebrew(binaryName: binaryName) &&
            McBrew.cmd.isInstalled(binaryName: binaryName) == false {
            throw McBrewError.formulaNotInstalled
        }
        
        if let p = McBrew.cmd.path(binaryName: binaryName) {
            path = p
        } else {
            switch binaryName {
            case "cot": // CotEditor
                path = "/usr/local/bin/cot"
            case "curl": 
                path = "/usr/bin/curl"
            case "file": 
                path = "/usr/bin/file"
            case "find": 
                path = "/usr/bin/find"
            case "iconutil": // - convert between `.iconset` folder and `.icns` 
                path = "/usr/bin/iconutil"
            case "inkscape": // Inkscape 
                // NOTE: simple `inkscape` link will not find Inkscape's Resources
                path = "/Applications/Inkscape.app/Contents/MacOS/inkscape"
            case "join.py": // Automator Python script combines PDF files
                path = "/System/Library/Automator/Combine PDF Pages.action/Contents/Resources/join.py"
            case "~/opt/bin/meld": // Meld
                let meld = FileManager.default
                    .homeDirectoryForCurrentUser
                    .appendingPathComponent("opt", isDirectory: true)
                    .appendingPathComponent("bin", isDirectory: true)
                    .appendingPathComponent("meld")
                path = meld.path
            case "mkdir":
                path = "/bin/mkdir"
            case "open":
                path = "/usr/bin/open"
            case "osascript": // Open Scripting Architecture (OSA) 
                path = "/usr/bin/osascript"
            case "sips":
                path = "/usr/bin/sips"
            case "ssh-add":
                path = "/usr/bin/ssh-add"
            case "textutil":
                path = "/usr/bin/textutil"
                let user_opt_dir = FileManager.default
                    .homeDirectoryForCurrentUser
                    .appendingPathComponent("opt", isDirectory: true)
                path = user_opt_dir.path
            default:
                break
            }            
        }
        
        if let path = path {
            if _fm.fileExists(atPath: path) {
                return URL(fileURLWithPath: path, isDirectory: false)
            } else {
                print(":NYI: McProcessPath `\(binaryName)` not install at `\(path)`")
                throw McProcessPathError.notInstalled
            }
        }
        
        print(":NYI: McProcessPath has not yet implemented name: `\(binaryName)`")
        throw McProcessPathError.unknown
    }
    
}

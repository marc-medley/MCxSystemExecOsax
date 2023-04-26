//
//  McProcessPath.swift
//  MCxSystemExecOsax
//
//  Created by marc-medley on 2017.04.03.
//  Copyright © 2017 marc-medley. All rights reserved.
//

import Foundation

public enum McProcessPathError: Error {
    case brewNotFound
    case notInstalled
    case unknown
}

public class McProcessPath {
    
    public static let cmd = McProcessPath()
    //
    private let _fm = FileManager.default
    
    // /opt/homebrew // Apple M1
    // /usr/local    // Intel
    private var _brewBasePath: String?
    
    public init() {
        if _fm.fileExists(atPath: "/opt/homebrew/bin/brew") {
            // Apple M1 processor
            _brewBasePath = "/opt/homebrew"
        } else if _fm.fileExists(atPath: "/usr/local/bin/brew") {
            // Intel processor
            _brewBasePath = "/usr/local"
        } else {
            _brewBasePath = nil           
        }
    }
    
    public func url(name: String) throws -> URL {
        var path: String?
        
        guard let brewBasePath = _brewBasePath else {
            throw McProcessPathError.brewNotFound
        }
        
        if _isHomebrew(name: name) {
            path = "\(brewBasePath)/bin/\(name)"
        } else {
            switch name {
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
                print(":NYI: McProcessPath `\(name)` not install at `\(path)`")
                throw McProcessPathError.notInstalled
            }
        }
        
        print(":NYI: McProcessPath has not yet implemented name: `\(name)`")
        throw McProcessPathError.unknown
    }
    
    private func _isHomebrew(name: String) -> Bool {
        switch name {
        case 
            "cmark-gfm",
            "ffmpeg",      // FFmpeg
            "ffprobe",     // FFmpeg
            "gm",          // GraphicsMagick
            "gs",          // Ghostscript: more tools /…/Cellar/ghostscript/*/bin
            "hoedown",
            "identify",    // also man ImageMagick
            "magick",      // also man ImageMagick
            "markdown",    // Discount
            "mogrify",     // also man ImageMagick
            "multimarkdown",
            "pandoc",
            "pdfattach",   // Poppler
            "pdfdetach",   // Poppler
            "pdffonts",    // Poppler
            "pdfimages",   // Poppler
            "pdfinfo",     // Poppler
            "pdfseparate", // Poppler
            "pdfsig",      // Poppler
            "pdftocairo",  // Poppler
            "pdftohtml",   // Poppler
            "pdftoppm",    // Poppler
            "pdftops",     // Poppler
            "pdftotext",   // Poppler
            "pdfunite",    // Poppler
            "tesseract",   // OCR
            "wget":
            return true
        default:
            return false
        }
    }
}

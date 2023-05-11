//
//  McProcessPath.swift
//  MCxSystemExecOsax
//
//  Created by marc-medley on 2017.04.03.
//  Copyright © 2017 marc-medley. All rights reserved.
//

import Foundation

public enum McProcessPathError: Error {
    case notInstalled(detail: String)
    case unknown
}

public class McProcessPath {
    
    public static let cmd = McProcessPath()
    //
    private let _fm = FileManager.default
    
    public func url(binaryName: String) throws -> URL {
        var path: String?
        
        if McBrew.cmd.isHomebrew(binaryName: binaryName) &&
            McBrew.cmd.isInstalled(binaryName: binaryName) == false {
            throw McBrewError.formulaNotInstalled(name: binaryName)
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
                throw McProcessPathError.notInstalled(detail: ":NYI: McProcessPath `\(binaryName)` not install at `\(path)`")
            }
        }
        
        print(":NYI: McProcessPath has not yet implemented name: `\(binaryName)`")
        throw McProcessPathError.unknown
    }
    
}

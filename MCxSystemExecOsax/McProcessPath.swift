//
//  McProcessPath.swift
//  MCxSystemExecOsax
//
//  Created by marc-medley on 2017.04.03.
//  Copyright © 2017 marc-medley. All rights reserved.
//

import Foundation

public class McProcessPath {
    
    /// CotEditor `~/opt/bin/cot`
    public static let cot = FileManager.default
        .homeDirectoryForCurrentUser
        .appendingPathComponent("opt", isDirectory: true)
        .appendingPathComponent("bin", isDirectory: true)
        .appendingPathComponent("cot")
        .path
    
    /// curl 
    public static let curl = "/usr/bin/curl"
    
    /// GraphicsMagick `gm`
    public static let gm = "/usr/local/bin/gm"
    
    /// `hoedown`
    public static let hoedown = "/opt/hoedown/current/bin/hoedown"
    
    /// `iconutil` - convert between `.iconset` folder and `.icns` file
    public static let iconutil = "/usr/bin/iconutil"

    /// Inkscape `inkscape`
    // NOTE: simple `inkscape` link will not find Inkscape's Resources
    // NOTE: brew cask (binary) install is a possible alternative.
    public static let inkscape = "/Applications/Inkscape.app/Contents/Resources/bin/inkscape"
    
    /// `markdown` Discount
    public static let markdown = "/opt/discount/current/bin/markdown"
    
    /// Meld `~/opt/bin/meld`
    public static let meld = FileManager.default
        .homeDirectoryForCurrentUser
        .appendingPathComponent("opt", isDirectory: true)
        .appendingPathComponent("bin", isDirectory: true)
        .appendingPathComponent("meld")
        .path
    
    /// `mkdir` 
    public static let mkdir = "/bin/mkdir"

    /// `open` 
    public static let open = "/usr/bin/open"

    /// Open Scripting Architecture (OSA) `osascript`
    public static let osascript = "/usr/bin/osascript"
    
    /// pandoc
    public static let pandoc = "/usr/local/bin/pandoc"
    
    // sips
    public static let sips = "/usr/bin/sips"
    
    /// `ssh-add` 
    public static let ssh_add = "/usr/bin/ssh-add"
    
    /// `textutil` 
    public static let textutil = "/usr/bin/textutil"

    /// `wget`
    public static let wget = "/usr/local/bin/wget"
    
    public static let user_opt_dir = FileManager.default
        .homeDirectoryForCurrentUser
        .appendingPathComponent("opt", isDirectory: true)
    
}

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
    
    /// `cmark-gfm`
    public static let cmark_gfm = URL(fileURLWithPath: "/usr/local/bin/cmark-gfm", isDirectory: false)

    /// `curl`
    public static let curl = URL(fileURLWithPath: "/usr/bin/curl", isDirectory: false)

    /// `ffmpeg`
    public static let ffmpeg = URL(fileURLWithPath: "/usr/local/bin/ffmpeg", isDirectory: false)

    /// `ffprobe`
    public static let ffprobe = URL(fileURLWithPath: "/usr/local/bin/ffprobe", isDirectory: false)
    
    /// GraphicsMagick `gm`
    public static let gm = URL(fileURLWithPath: "/usr/local/bin/gm", isDirectory: false)
    
    /// `hoedown`
    public static let hoedown = URL(fileURLWithPath: "/opt/hoedown/current/bin/hoedown", isDirectory: false)
    
    /// `iconutil` - convert between `.iconset` folder and `.icns` 
    public static let iconutil = URL(fileURLWithPath: "/usr/bin/iconutil", isDirectory: false)

    /// Inkscape `inkscape`
    // NOTE: simple `inkscape` link will not find Inkscape's Resources
    // NOTE: brew cask (binary) install is a possible alternative.
    public static let inkscape = URL(
        fileURLWithPath: "/Applications/Inkscape.app/Contents/Resources/bin/inkscape", 
        isDirectory: false)
    
    /// `markdown` Discount
    public static let markdown = URL(fileURLWithPath: "/opt/discount/current/bin/markdown", isDirectory: false)
    
    /// `multimarkdown`
    public static let multimarkdown = URL(fileURLWithPath: "/opt/discount/current/bin/multimarkdown", isDirectory: false)
    
    /// Meld `~/opt/bin/meld`
    public static let meld = FileManager.default
        .homeDirectoryForCurrentUser
        .appendingPathComponent("opt", isDirectory: true)
        .appendingPathComponent("bin", isDirectory: true)
        .appendingPathComponent("meld")
    
    /// `mkdir` 
    public static let mkdir = URL(fileURLWithPath: "/bin/mkdir", isDirectory: false)

    /// `open` 
    public static let open = URL(fileURLWithPath: "/usr/bin/open", isDirectory: false)

    /// Open Scripting Architecture (OSA) `osascript`
    public static let osascript = URL(fileURLWithPath: "/usr/bin/osascript", isDirectory: false)
    
    /// `pandoc`
    public static let pandoc = URL(fileURLWithPath: "/usr/local/bin/pandoc", isDirectory: false)
    
    // `sips`
    public static let sips = URL(fileURLWithPath: "/usr/bin/sips", isDirectory: false)
    
    /// `ssh-add` 
    public static let ssh_add = URL(fileURLWithPath: "/usr/bin/ssh-add", isDirectory: false)
    
    /// `tesseract` OCR
    public static let tesseract = URL(fileURLWithPath: "/usr/local/bin/tesseract", isDirectory: false)
    
    /// `textutil` 
    public static let textutil = URL(fileURLWithPath: "/usr/bin/textutil", isDirectory: false)

    /// `wget`
    public static let wget = URL(fileURLWithPath: "/usr/local/bin/wget", isDirectory: false)
    
    public static let user_opt_dir = FileManager.default
        .homeDirectoryForCurrentUser
        .appendingPathComponent("opt", isDirectory: true)
    
}

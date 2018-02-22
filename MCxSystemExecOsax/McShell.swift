//
//  McShell.swift
//  MCxSystemExecOsax
//
//  Created by marc-medley on 2017.03.27.
//  Copyright © 2017 marc-medley. All rights reserved.
//

import Foundation

public class McShell {
    
    
    /** shell: Graphics Magic convert resize
     
     ```
     gm convert $ICON_SOURCE_IMAGE -resize 16x16     $ICON_NAME.iconset/icon_16x16.png
     ```
     
     */
    public static func gmConvertResize(fromPath: String, toPath: String, wxh: String, workPath: String) {
        var args: [String] = []
        args.append("convert")
        args.append(fromPath)
        args.append("-resize")
        args.append(wxh)
        args.append(toPath)
        
        _ = McProcess.run(
            commandPath: McProcessPath.gm, 
            withArguments: args, 
            workDirectory: workPath
        )
    }
    
    /**
     
     ```
     iconutil --convert icns input_folder.iconset
     # :NYI:  --convert iconset ... from icon to folder of images
     ```
     
     */
    public static func iconutilIcns(iconsetFolder: String, workPath: String) {
        print("iconsetFolder = \(iconsetFolder)")
        var args: [String] = []
        args.append("--convert")
        args.append("icns")
        args.append(iconsetFolder)
        
        _ = McProcess.run(
            commandPath: McProcessPath.iconutil, 
            withArguments: args, 
            workDirectory: workPath
        )
    }
    
    ///
    /// 
    /// inkscape 
    /// 
    /// - Note: If h x w ratio does not match the original ratio, then the resulting file will have stretch distortion.  
    ///
    /// _Will launch XQuartz._
    ///
    /// - parameters:
    ///     - fromPath: fully specified file path
    ///     - toPath: full specified file path
    ///     - h: pixel height
    ///     - w: pixel width
    ///     - backgroundOpacity: range 0.0 to 1.0. Default is 0.005 to preserve canvas size. 0.0 contracts to image size.
    ///     - workPath: current working directory
    ///
    public static func inkscapeSvgPng(fromPath: String, toPath: String, h: Int, w: Int, backgroundOpacity: Float = 0.005, workPath: String) {
        //print("--export-height=\(h)")
        //print("--export-width=\(w)")
        //print("--export-png='\(toPath)'")
        //print("--export-background-opacity=\(backgroundOpacity)")
        //print("fromPath = \(fromPath)")
        //print("workPath = \(workPath)")
        var args: [String] = []
        args.append("--without-gui")
        args.append("--export-height=\(h)")
        args.append("--export-width=\(w)")
        args.append("--export-background-opacity=\(backgroundOpacity)")
        args.append(contentsOf: ["--export-png=\(toPath)"])
        args.append(fromPath)
        
        _ = McProcess.run(
            commandPath: McProcessPath.inkscape, 
            withArguments: args, 
            workDirectory: workPath
        )
    }
    
    /** shell: mkdir
     
     ```
     mkdir [-p] [-m mode] directory_name ...
     ```
     
     */
    public static func mkdir(dir: String, workPath: String) {
        // -p Create intermediate directories as required.
        // -m mode
        var args: [String] = []
        args.append(dir)
        
        _ = McProcess.run(
            commandPath: McProcessPath.mkdir, 
            withArguments: args, 
            workDirectory: workPath
        )
    }
    
    /** shell: open
     
     ```
     open [-a application] [-b bundle_indentifier] [_MORE_] file ...
     ```
     
     */
    public static func open(filePath: String, workPath: String? = nil) {
        
        var args: [String] = []
        args.append(filePath)
        
        _ = McProcess.run(
            commandPath: McProcessPath.open, 
            withArguments: args, 
            workDirectory: workPath
        )
    }
    
    
}

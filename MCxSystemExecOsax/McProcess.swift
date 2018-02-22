//
//  McProcess.swift
//  MCxSystemExecOsax
//
//  Created by marc-medley on 2017.01.26.
//  Copyright © 2017 marc-medley. All rights reserved.
//

import Foundation

/**
 
 ## Important:
 
 `$HOME` and `~` must be fully expanded.
 
 ## NYI:
 Add auto detection and expansion for `$HOME` and `~`.
 
 */

public class McProcess {
    
    public static func run(commandPath: String, 
                           withArguments: [String]? = nil, 
                           workDirectory: String? = nil) -> (stdout: String, stderr: String) {
        let process = Process()
        process.launchPath = commandPath
        if let args = withArguments {
            process.arguments = args
        }
        if let wd = workDirectory {
            process.currentDirectoryPath = wd
        }
        
        let pipeOutput = Pipe()
        process.standardOutput = pipeOutput
        let pipeError = Pipe()
        process.standardError = pipeError
        process.launch()
        
        var stdoutStr = "" // do not mask foundation stdout
        var stderrStr = "" // do not mask foundation stderr
        
        let data = pipeOutput.fileHandleForReading.readDataToEndOfFile()
        if let output = String(data: data, encoding: String.Encoding.utf8) {
            print("STANDARD OUTPUT\n" + output)
            stdoutStr.append(output)
        }
        
        let dataError = pipeError.fileHandleForReading.readDataToEndOfFile()
        if let outputError = String(data: dataError, encoding: String.Encoding.utf8) {
            print("STANDARD ERROR \n" + outputError)
            stderrStr.append(outputError)
        }
        
        process.waitUntilExit()
        let status = process.terminationStatus
        print("STATUS: \(status)")
        
        return (stdoutStr, stderrStr)
    }
    
    public static func runOsaScript(script: String, removeTrailingNewline: Bool = false, useJXA: Bool = false) -> (stdout: String, stderr: String) {
        var args = [String]()
        if useJXA {
            args.append(contentsOf: ["-l","JavaScript"])
        }
        // flags: -s 
        //    h (default: human readable) | s (recompilable source) 
        //    e (default: errors to STDERR) | o (errors to STDOUT) 
        args.append(contentsOf: ["-e",script])
        // args after the script will be passed to the script
        
        //Process.launchedProcess(launchPath: "/usr/bin/osascript", arguments: args)
        let process = Process()
        process.launchPath = "/usr/bin/osascript"
        process.arguments = args
        
        let pipeOutput = Pipe()
        process.standardOutput = pipeOutput
        let pipeError = Pipe()
        process.standardError = pipeError
        process.launch()
        
        var stdoutStr = "" // do not mask foundation stdout
        var stderrStr = "" // do not mask foundation stderr
        
        let data = pipeOutput.fileHandleForReading.readDataToEndOfFile()
        if let output = String(data: data, encoding: String.Encoding.utf8) {
            //print("STANDARD OUTPUT\n" + output)
            stdoutStr.append(output)
        }
        
        let dataError = pipeError.fileHandleForReading.readDataToEndOfFile()
        if let outputError = String(data: dataError, encoding: String.Encoding.utf8) {
            //print("STANDARD ERROR \n" + outputError)
            stderrStr.append(outputError)
        }
        
        process.waitUntilExit()
        //let status = process.terminationStatus
        //print("STATUS: \(status)")
        
        // osascript adds extra \n
        if removeTrailingNewline {
            stdoutStr = stdoutStr.replacingOccurrences(of: "\\n$", with: "", options: .regularExpression)
        }
        
        return (stdoutStr, stderrStr)
    }
    
}




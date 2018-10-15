//
//  McOsax.swift
//  MCxSystemExecOsax
//
//  Created by marc-medley on 2017.03.13.
//  Copyright © 2017 marc-medley. All rights reserved.
//

import Foundation

public enum McOsaxIcon {
    case caution
    case note
    case stop
}

/// Uniform Type Identifiers (UTI)
/// 
/// **Notes:**
/// 
/// Apple text string intended to eliminate the ambiguities and problems associated with inferring a file's content from its MIME type, filename extension, or type or creator code. 
/// 
/// [Apple: Uniform Type Identifiers Overview](https://developer.apple.com/library/content/documentation/FileManagement/Conceptual/understanding_utis)
/// 
/// [Apple: System-Declared Uniform Type Identifiers](https://developer.apple.com/library/content/documentation/Miscellaneous/Reference/UTIRef/Articles/System-DeclaredUniformTypeIdentifiers.html)
public enum McOsaxUTI: String {
    case html = "public.rtf"
    case rtf = "public.html"
    case text = "public.text"
    case xml = "public.xml"
}

///
public class McOsaxURL {
    
    public static let desktop: URL = FileManager.default
        .homeDirectoryForCurrentUser
        .appendingPathComponent("Desktop", isDirectory: true)
    
    public static let documents: URL = FileManager.default
        .homeDirectoryForCurrentUser
        .appendingPathComponent("Documents", isDirectory: true)
    
    public static let home: URL = FileManager.default.homeDirectoryForCurrentUser
    
    public static let optUser: URL = FileManager.default
        .homeDirectoryForCurrentUser
        .appendingPathComponent("opt", isDirectory: true)
    
}


public class McOsax {
    
    // MARK: - Choose From List, Application, File, File Name, Folder, Url
    
    // :TODO: Dialog Sampler.swift
    // Reference: applescriptlanguageguide-2013.pdf
    // GitHub: quick examples
    
    // :TODO: try page 262 to handle user canceled
    
    // path to (application) 180 
    // path to (folder) 182
    // path to resource 186
    // info for 167
    // set folderName to quoted form of POSIX path of (choose folder)
    // iWork '08 becomes "'/Applications/iWork '\\''08/'"
    
    // :TODO: add results examples
    // result: alias, alias list
    // try page 262 to handle user canceled
    
    /// - Note: `cancel` returns "false". If "FALSE" is needed as a choice, then uppercase "FALSE" in the choice list to avoid user selection ambiguity.  Lowercase "false" will always return `nil`.
    /// 
    /// - Note: Each choice must be fully unique. Do not have one choice be nested within another choice. For example, instead of "Jim" & "Jim Bean", use "A: Jim", "B:  Jim Bean"
    ///
    /// - parameter choices: `[String]`
    /// - parameter defaults: [String]
    /// - parameter title: String?
    /// - parameter prompt: String?
    /// - parameter okButtonName: String?
    /// - parameter cancelButtonName: String?
    /// - parameter allowMultipleSelections: Bool default: `false`
    /// - parameter emptySelectionAllowed: Bool default: `false`
    ///
    public static func chooseFromList(
        choices: [String],
        defaults: [String],
        title: String? = nil,
        prompt: String? = nil, 
        okButtonName: String? = nil,
        cancelButtonName: String? = nil,
        allowMultipleSelections: Bool = false,
        emptySelectionAllowed: Bool = false
        ) -> [String]? {
        
        // required: `choose from list {\"A\", \"B\"}` or {1, 2.0}
        // optional: `default items {\"A\"}` or {1}
        let choiceList = toListFromStrings(choices)
        let defaultList = toListFromStrings(defaults)
        var s = "choose from list \(choiceList) default items \(defaultList) "
        
        // optional: `with title \"text\"`          
        if let text = title {
            s.append("with title \"\(text)\" ")
        }
        // optional: `with prompt \"text\"`  default: "Please make your selection:"
        if let text = prompt {
            s.append("with prompt \"\(text)\" ")
        }
        // optional: `OK button name \"text\"`                default: "OK"
        if let text = okButtonName {
            s.append("OK button name \"\(text)\" ")
        }
        // optional: `cancel button name \"text\"`            default: "Cancel"
        if let text = cancelButtonName {
            s.append("cancel button name \"\(text)\" ")
        }
        // optional: `multiple selections allowed false|true` default: false
        if allowMultipleSelections {
            s.append("multiple selections allowed true ")
        }
        // optional: `empty selection allowed false|true`     default: false
        if emptySelectionAllowed {
            s.append("empty selection allowed true ")
        }
        
        // :RESULT:SINGLE: \n
        // :RESULT:MULTIPLE: `, ` separator. can be ambiguous with list item.
        // :RESULT:NONE: empty list
        // :RESULT:CANCEL: false. can be ambiguous with list item.
        // :RESULT:CLOSE_WINDOW: not available
        
        print("script:\n\(s)")
        let result = McProcess.runOsaScript(script: s)
        if result.stdout.compare("false\n") == ComparisonResult.orderedSame {
            return nil
        }
        var selected: [String] = []
        for s in choices {
            if result.stdout.contains(s) {
                selected.append(s)
            }
        }
        return selected
    }
    
    /// - parameter title: `String?` default: "Choose Application"
    /// - parameter prompt: String? default: "Select an application:"
    /// - parameter allowMultipleSelections: Bool default: `false`
    public static func chooseApplication(
        title: String? = nil,
        prompt: String? = nil, 
        allowMultipleSelections: Bool = false
        ) -> [URL]? {
        // required: `choose application`
        var s = "set aliasList to (choose application "
        
        // optional: `with title \"text\"`   default: "Choose Application"
        if let text = title {
            s.append("with title \"\(text)\" ")
        }
        // optional: `with prompt \"text\"`  default: "Select an application:"
        if let text = prompt {
            s.append("with prompt \"\(text)\" ")
        }
        // optional: `multiple selections allowed true|false`  default: false
        if allowMultipleSelections {
            s.append("multiple selections allowed true ")
        }
        
        s.append("as alias ")
        s.append(") as list\n")
        s.append("set posixList to {}\n")
        s.append("repeat with currentFile in aliasList\n")
        s.append("  set end of posixList to (POSIX path of currentFile)\n")
        s.append("end repeat\n")
        s.append("return posixList\n")
        
        // :RESULT:SINGLE:
        // /Applications/App Store.app/
        // :RESULT:MULTIPLE:
        // posixList=/Applications/Meld.app/Contents/Frameworks/Python.framework/Versions/2.7/Resources/Python.app/, /Applications/Safari Technology Preview.app/
        // :RESULT:NONE: not allowed. same as cancel.
        // :RESULT:CANCEL:
        // STANDARD ERROR=0:27: execution error: User canceled. (-128)
        // STANDARD ERROR=0:104: execution error: User canceled. (-128)
        
        print("script:\n\(s)")
        let result = McProcess.runOsaScript(script: s)
        if result.stderr.contains("User canceled") {
            return nil
        }
        
        let urls = toUrlList(posixList: result.stdout)
        print("urls=\(urls)")
        return urls
    }
    
    /// - parameter prompt: `String` optional default: none
    /// - parameter ofType: `[McOsaxUTI.raw]` optional default: none
    /// - parameter defaultFolderUrl: `URL` optional default: none
    /// - parameter allowMultipleSelections: Bool default: `false`
    /// - parameter showInvisibles: `Bool` default: false
    /// - parameter showPackageContents: `Bool` default: false
    public static func chooseFile(
        prompt: String? = nil,
        ofType: [String]? = nil,
        defaultFolderUrl: URL? = nil,
        allowMultipleSelections: Bool = false,
        showInvisibles: Bool = false, // reverses AppleScript default of true
        showPackageContents: Bool = false
        ) -> [URL]? {
        // required: `choose file `
        var s = "set aliasList to (choose file "
        
        // optional: `with prompt \"\(text)\" "           default: none
        if let text = prompt {
            s.append("with prompt \"\(text)\" ")
        }
        
        // optional: ofType
        // optional: `of type {\"public.html\", \"public.rtf\"} `   Uniform Type Identifier (UTI). default: none
        if let typeList = ofType {
            let list = toListFromStrings(typeList, quoted: true)
            s.append("of type \(list) ")
        }
        
        // optional: `default location (POSIX file "/path/to/folder"`
        if let url = defaultFolderUrl {
            s.append("default location (POSIX file \"\(url.path)\") ")
        }
        
        // optional: `multiple selections allowed false|true` default: false
        if allowMultipleSelections {
            s.append("multiple selections allowed true ")
        }
        // optional: invisibles true|false NOTE: AppleScript default is true
        //if showInvisibles == false {
        s.append("invisibles \(showInvisibles) ")
        //}
        
        // optional: `showing package contents true|false` default: false
        if showPackageContents {
            s.append("showing package contents true ")
        }  
        s.append(") as list\n")
        s.append("set posixList to {}\n")
        s.append("repeat with currentFile in aliasList\n")
        s.append("  set end of posixList to (POSIX path of currentFile)\n")
        s.append("end repeat\n")
        s.append("return posixList\n")
        
        // :RESULT:SINGLE:
        // :RESULT:MULTIPLE:
        // :RESULT:NONE:
        // :RESULT:CANCEL:
        
        print("script:\n\(s)")
        let result = McProcess.runOsaScript(script: s)
        if result.stderr.contains("User canceled") {
            return nil
        }
        
        print(result.stdout)
        
        let urls = toUrlList(posixList: result.stdout)
        print("urls=\(urls)")
        return urls
    }
    
    /// - parameter prompt: `String` e.g. "Save report as:" default: "Specify new file name and location"
    /// - parameter defaultName: `String`  default: untitled
    /// - parameter defaultFolderUrl: `URL?` 
    public static func chooseFileName(
        prompt: String? = nil,
        defaultName: String? = nil,
        defaultFolderUrl: URL? = nil 
        ) -> URL? {
        // required: choose file name
        var s = "set aliasList to (choose file name "
        
        // optional: with prompt
        if let text = prompt {
            s.append("with prompt \"\(text)\" ")
        }
        // optional: `default name \"\(text)\" `  default: "untitled"
        if let str = defaultName {
            s.append("default name \"\(str)\" ")
        }
        
        // optional: `default location (POSIX file "/path/to/folder"`
        if let url = defaultFolderUrl {
            s.append("default location (POSIX file \"\(url.path)\") ")
        }
        s.append(") as list\n")
        s.append("set posixList to {}\n")
        s.append("repeat with currentFile in aliasList\n")
        s.append("  set end of posixList to (POSIX path of currentFile)\n")
        s.append("end repeat\n")
        s.append("return posixList\n")
        
        // :RESULT:SINGLE:
        // :RESULT:MULTIPLE: does not apply
        // :RESULT:NONE: does not apply
        // :RESULT:CANCEL:
        
        print("script:\n\(s)")
        let result = McProcess.runOsaScript(script: s)
        if result.stderr.contains("User canceled") {
            return nil
        }
        
        print(result.stdout)
        
        let url = toUrl(posix: result.stdout)
        print("url=\(String(describing: url))")
        return url
    }
    
    /// - parameter prompt: `String`
    /// - parameter defaultUrl: `URL`
    /// - parameter allowMultipleSelections: `Bool` default: false
    /// - parameter showInvisibles: `Bool` default: false
    /// - parameter showPackageContents: `Bool` default: false
    public static func chooseFolder(
        prompt: String? = nil,
        defaultFolderUrl: URL? = nil, 
        allowMultipleSelections: Bool = false,
        showInvisibles: Bool = false,
        showPackageContents: Bool = false
        ) -> [URL]? {
        // required: choose folder
        var s = "set aliasList to (choose folder "
        
        // optional: with prompt
        if let text = prompt {
            s.append("with prompt \"\(text)\" ")
        }
        // optional: `default location (POSIX file "/path/to/folder"`
        if let url = defaultFolderUrl {
            s.append("default location (POSIX file \"\(url.path)\") ")
        }
        // optional: multiple selections allowed
        if allowMultipleSelections {
            s.append("multiple selections allowed true ")
        }
        // optional: invisibles
        if showInvisibles {
            s.append("invisibles true ")
        }
        // optional: showing package contents.
        if showPackageContents {
            s.append("showing package contents true ")
        }
        s.append(") as list\n")
        s.append("set posixList to {}\n")
        s.append("repeat with currentFile in aliasList\n")
        s.append("  set end of posixList to (POSIX path of currentFile)\n")
        s.append("end repeat\n")
        s.append("return posixList\n")
        
        // :RESULT:SINGLE:
        // :RESULT:MULTIPLE:
        // :RESULT:NONE:
        // :RESULT:CANCEL:
        
        print("script:\n\(s)")
        let result = McProcess.runOsaScript(script: s)
        if result.stderr.contains("User canceled") {
            return nil
        }
        
        print(result.stdout)
        
        let urls = toUrlList(posixList: result.stdout, isDirectory: true)
        print("urls=\(urls)")
        return urls
    }
    
    /// - parameter showing: `[String]` where "`Web servers`" shows `http` and `https` services. "`FTP Servers`" shows `ftp` services. "`Telnet hosts`" shows `telnet` services. "`File servers`" shows `afp`, `nfs`, and `smb` services. "`News servers`" shows `nntp` services. "`Directory services`" shows `ldap` services. "`Media servers`" shows `rtsp` services. "`Remote applications`" shows `eppc` services.
    /// 
    /// - parameter editable: default: `true`. `false` restricts choices to bonjour listed services 
    public static func chooseUrl(
        showing: [String]? = nil,
        editable: Bool = true
        ) -> String? {
        
        // required: `choose URL
        var s = "choose URL "
        
        // optional: `showing   listOfServiceTypesOrTextStrings` default "File servers"
        if let serviceTypes = showing {
            let list = toListFromStrings(serviceTypes, quoted: false)
            s.append("showing \(list) ")
        } 
        else {
            let types = ["File servers", "Remote applications", "Web servers", "FTP Servers", "Telnet hosts", "News servers", "Directory services", "Media servers"]
            let list = toListFromStrings(types, quoted: false)
            s.append("showing \(list) ")
        }
        
        // optional: `editable URL true|false` 
        // default: true. false restricts choices to bonjour listed services 
        if editable == false {
            s.append("editable URL false ")
        }
        
        print("script:\n\(s)")
        let result = McProcess.runOsaScript(script: s)
        if result.stderr.contains("User canceled") {
            return nil
        }
        
        return result
            .stdout
            .replacingOccurrences(of: "\n", with: "", options: [.backwards, .anchored])
    }
    
    // MARK: - 
    
    public static func clipboardInfo(
        /// optional: for class
        /// example: clipboard info for Unicode text
        // :NYI: anything could also return any (Cocoa?) object?
        forClass: String? = nil
        // return: {{class,size}, …}
        ) -> String {
        var s = "clipboard info "
        
        if let c = forClass {
            s.append("for \(c)")
        }
        
        print("script:\n\(s)")
        let result = McProcess.runOsaScript(script: s)
        return result.stdout
    }
    
    public static func clipboardGet(
        /// optional: as class
        /// example: clipboard info for Unicode text
        asClass: String? = nil
        ) -> String {
        var s = "the clipboard "
        
        if let c = asClass {
            s.append("as \(c)")
        }
        
        print("script:\n\(s)")
        let result = McProcess.runOsaScript(script: s)
        return result.stdout
    }
    
    public static func clipboardSet(
        // :NYI: anything could also be any (Cocoa?) object?
        _ anything: String
        ) {
        let s = "set the clipboard to \"\(anything)\""
        
        print("script:\n\(s)")
        _ = McProcess.runOsaScript(script: s)
    }
    
    /// - parameter seconds: time. e.g. 3.5 seconds
    public static func delay(seconds: Float) {
        // `delay \(seconds)`   example: delay 3.5
        let s = "delay \(String(format: "%.2f", seconds)) "
        
        print("script:\n\(s)")
        _ = McProcess.runOsaScript(script: s)
    }
    
    // MARK: - Display Alert, Dialog, Notification
    
    /// Display Alert
    /// - parameter message: `String`
    /// - parameter title: `String?`
    /// - parameter buttons: default "OK", "Cancel"
    /// - parameter buttonDefault: default "OK"
    /// - parameter buttonCancel: default "Cancel"
    /// - parameter icon: `McOsaxIcon` caution, note or stop
    /// - returns: button `String` or `nil` is user canceled
    public static func displayAlert(
        message: String,
        submessage: String? = nil,
        buttons: [String]? = nil,
        buttonDefault: String? = nil,
        buttonCancel: String? = nil,
        icon: McOsaxIcon? = nil
        // :!!!: NYI
        // required: `display alert text 
        // optional: `message text
        // optional: `buttons list       default: {"OK"}
        // optional: `default button buttonSpecifier `  name or number
        // optional: `cancel button
        
        // result: {button returned: "OK"}, {button returned:"", gave up:true}
        ) -> String? {
        // required: `display alert text
        var s = "display alert  \"\(message)\" "
        // optional: with title text
        if let text = submessage {
            s.append("message \"\(text)\" ")
        }
        // optional: buttons list
        if let buttonList = buttons {
            s.append("buttons \(toListFromStrings(buttonList)) ")
        }
        // optional: default button labelSpecifier 
        if let defaultButton = buttonDefault {
            s.append("default button \"\(defaultButton)\" ")
        }
        // optional: cancel button labelSpecifier
        if let cancelButton = buttonCancel {
            s.append("cancel button \"\(cancelButton)\" ")
        }
        // optional: `with icon resourceSpecifier stop note caution
        if let withIcon = icon {
            switch withIcon {
            case .caution:
                // warning is showing the standard information icon
                // s.append("as warning ")
                s.append("as critical ")
            case .note:
                // informational: the standard alert dialog
                s.append("as informational ")
            case .stop:
                // AppleScript: critical: "currently the same as the standard alert dialog"
                // note found "critical" to show a caution icon
                s.append("as critical ")
            }
        }
        // :NYI: giving up after integer
        
        print("script:\n\(s)")
        let result = McProcess.runOsaScript(script: s)  
        print("result=\(result)")
        if result.stderr.contains("User canceled") {
            return nil
        }
        
        // button returned:____, text returned:____
        var a = result.stdout
        a = a.replacingOccurrences(of: "button returned:", with: "", options: [.anchored])
        a = a.replacingOccurrences(of: "\n", with: "", options: [.backwards, .anchored])

        return a
    }
    
    
    /// Display Dialog
    /// - parameter message: `String`  
    /// - parameter title: `String?`  
    /// - parameter answerDefault: `String` DEFAULT: "".  
    public static func displayDialogGetText(
        message: String,
        title: String? = nil,
        answerDefault: String = ""
        ) -> String? {
        
        guard let result = displayDialog(message: message, title: title, answerDefault: answerDefault) else {
            return nil
        }
        
        switch result.button.lowercased() {
        case "ok":
            return result.text
        default:
            return nil
        }
    }
    
    /// Display Dialog
    /// - parameter message: `String`  
    /// - parameter title: `String?`  
    /// - parameter answerDefault: `String?` NOTE: Answer box is hidden if no string provided. Can be an empty string "".  
    /// - parameter answerIsHidden: `Bool` default false  
    /// - parameter buttons: default "OK", "Cancel"  
    /// - parameter buttonDefault: default "OK"  
    /// - parameter buttonCancel: default "Cancel"  
    /// - parameter icon: `McOsaxIcon` caution, note or stop  
    /// - returns: (text: String, button: String) or `nil` is user canceled  
    public static func displayDialog(
        message: String,
        title: String? = nil,
        answerDefault: String? = nil,
        answerIsHidden: Bool = false,
        buttons: [String]? = nil,
        buttonDefault: String? = nil,
        buttonCancel: String? = nil,
        icon: McOsaxIcon? = nil
        ) -> (text: String, button: String)? {
        // required: `display dialog text
        var s = "display dialog \"\(message)\" "
        
        // optional: `default answer text
        if let str = answerDefault {
            s.append("default answer \"\(str)\" ")
        }
        // optional: `hidden answer boolean 
        if answerIsHidden {
            s.append("hidden answer true ")
        }
        // optional: buttons list
        if let buttonList = buttons {
            s.append("buttons \(toListFromStrings(buttonList)) ")
        }
        // optional: default button labelSpecifier 
        if let defaultButton = buttonDefault {
            s.append("default button \"\(defaultButton)\" ")
        }
        // optional: cancel button labelSpecifier
        if let cancelButton = buttonCancel {
            s.append("cancel button \"\(cancelButton)\" ")
        }
        // optional: with title text
        if let text = title {
            s.append("with title \"\(text)\" ")
        }
        
        // optional: `with icon resourceSpecifier stop note caution
        if let withIcon = icon {
            switch withIcon {
            case .caution:
                s.append("with icon caution ")
            case .note:
                s.append("with icon note ")
            case .stop:
                s.append("with icon stop ")
            }
        }
        
        print("script:\n\(s)")
        let result = McProcess.runOsaScript(script: s)  
        print("result=\(result)")
        if result.stderr.contains("User canceled") {
            return nil
        }
        
        // button returned:____, text returned:____
        var a = result.stdout
        a = a.replacingOccurrences(of: "button returned:", with: "", options: [.anchored])
        a = a.replacingOccurrences(of: "\n", with: "", options: [.backwards, .anchored])
        let b = a.components(separatedBy: ", text returned:")
        var returnButton = ""
        var returnText = ""
        if b.count == 2 {
            returnButton = b[0]
            returnText = b[1]
        }
        return (returnText, returnButton)
    }
    
    /// - parameter message: `String`
    /// - parameter title: `String`
    /// - parameter subtitle: `String` optional
    /// - parameter sound: `String` base name from Library/Sounds. e.g. Basso, Blow, Bottle, Frog, Funk, Glass, Hero, Morse, Ping, Pop, Purr, Sosumi, Submarine, Tink
    public static func displayNotification(
        message: String, 
        title: String,
        subtitle: String? = nil,
        sound: String? = nil) {
        
        // display notification text
        var s = "display notification \"\(message)\" "
        
        // with title text 
        s.append("with title \"\(title)\" ")
        
        // subtitle text
        if let text = subtitle {
            s.append("subtitle \"\(text)\" ")
        }
        
        // `sound name text `  base name from Library/Sounds
        if let text = sound {
            s.append("sound name \"\(text)\" ")
        }
        
        _ = McProcess.runOsaScript(script: s)
    }
    
    /// - parameter spokenText: String 
    /// - parameter usingVoice: system voice. For example: Alex, Fred, Samantha, Victoria. Additional voices can be downloaded via System Preferences > Accessibility > Speech.  Such as Swedish: Alva, Klara, Oskar, English Novelty: Pipe Organ, Spanish/Mexico: Juan, Monica, Spanish/Spain: Jorge, Monica 
    /// - parameter waitUntilCompletion: `Bool` default: true
    public static func say(
        spokenText: String,
        usingVoice: String? = nil,
        waitUntilCompletion: Bool = true
        ) {
        // say text
        var s = "say \"\(spokenText)\" "
        
        // using text
        if let str = usingVoice {
            s.append("using \"\(str)\" ")
        }
        
        // waiting until completion true or false. default: true
        if waitUntilCompletion == false {
            s.append("waiting until completion false ")
        }
        
        _ = McProcess.runOsaScript(script: s)
    }
    
    // MARK: - Utilities
    
    private static func toListFromStrings(_ source: [String], quoted: Bool = true) -> String {
        var s = "{"
        for i in 0 ..< source.count {
            if quoted {
                s.append("\"\(source[i])\"")
            }
            else {
                s.append("\(source[i])")
            }
            if i < source.count - 1 {
                s.append(", ")
            }
        }
        s.append("}")
        return s
    }
    
    /// - returns: URL?
    private static func toUrl(posix: String, isDirectory: Bool = false) -> URL? {
        print("posix=\(posix)")
        let s = posix.replacingOccurrences(of: "\n", with: "", options: [.backwards, .anchored])
        
        if s.isEmpty == false {
            return URL(fileURLWithPath: s, isDirectory: isDirectory)
        }
        return nil
    }
    
    private static func toUrlList(posixList: String, isDirectory: Bool = false) -> [URL] {
        print("posixList=\(posixList)")
        var s = posixList
        s = s.replacingOccurrences(of: "\n", with: "", options: [.backwards, .anchored])
        s = s.replacingOccurrences(of: ", /", with: "-_-SEPARATOR-_-/")
        
        print("s=\(s)")
        
        let sParts = s.components(separatedBy: "-_-SEPARATOR-_-")
        print("sParts = \(sParts)")
        
        var urls = [URL]()
        for a in sParts {
            if a.isEmpty == false {
                urls.append(URL(fileURLWithPath: a, isDirectory: isDirectory))
            }
        }
        return urls
    }
    
}

////////////////////////////////////////////////////
//////////////////// FOOTNOTES /////////////////////
////////////////////////////////////////////////////
///
/// 1. `choose color` did not display a color chooser window. 
/// 
/// 2. `with timeout` AppleScript statement wrapper did NOT timeout for `choose application`
/// 
/// -- AppleScript default: 120 seconds (2 minutes)
/// s.append("with timeout of 20 seconds\n")
/// -- AppleScript statement here
/// s.append("\nend timeout\n")
///
/////////////////////////////////////////////////////
 

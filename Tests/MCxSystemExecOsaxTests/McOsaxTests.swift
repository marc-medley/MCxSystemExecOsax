//
//  McOsaxTests.swift
//  MCxSystemExecOsax
//
//  Created by marc-medley on 2017.03.18.
//  Copyright © 2017 marc-medley. All rights reserved.
//

import XCTest
@testable import MCxSystemExecOsax

class McOsaxTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        let choiceList = ["A", "B", "C"]
        let defaultList =  ["C"]
        _ = McOsax.chooseFromList(choices: choiceList, defaults: defaultList)
    }
    
    // MARK: - Choose From List, Application, File, File Name, Folder, Url
    
    func testChooseFromList() {
        let choiceList = ["A⭐️", "B🌐", "C, ", "FALSE"]
        let defaultList =  [""]
        var r = McOsax.chooseFromList(choices: choiceList, defaults: defaultList, prompt: "Choose ONE:")
        print("r=\(String(describing: r))")
        r = McOsax.chooseFromList(choices: choiceList, defaults: defaultList, prompt: "Choose MULTIPLE:", allowMultipleSelections: true)
        print("r=\(String(describing: r))")
        r = McOsax.chooseFromList(choices: choiceList, defaults: defaultList, prompt: "Choose NONE:", emptySelectionAllowed: true)
        print("r=\(String(describing: r))")
        r = McOsax.chooseFromList(choices: choiceList, defaults: defaultList, prompt: "Choose CANCEL")
        print("r=\(String(describing: r))")
        r = McOsax.chooseFromList(choices: choiceList, defaults: defaultList, prompt: "Choose BYE", cancelButtonName: "BYE")
        print("r=\(String(describing: r))")
        r = McOsax.chooseFromList(choices: choiceList, defaults: defaultList, prompt: "Choose FALSE")
        print("r=\(String(describing: r))")
        r = McOsax.chooseFromList(choices: choiceList, defaults: defaultList, prompt: "Choose false")
        print("r=\(String(describing: r))")
        r = McOsax.chooseFromList(choices: choiceList, defaults: defaultList, prompt: "Choose CLOSE WINDOW")
        print("r=\(String(describing: r))")
    }
    
    func testChooseApplication() {
        var r = McOsax.chooseApplication()
        print("r=\(String(describing: r))")
        // :RESULT:SINGLE:
        r = McOsax.chooseApplication(prompt: "Select SINGLE application:", allowMultipleSelections: false)
        print("r=\(String(describing: r))")
        // :RESULT:MULTIPLE:
        r = McOsax.chooseApplication(prompt: "Select MULTIPLE applications:", allowMultipleSelections: true)
        if let urls = r {
            for u in urls {
                print("path=\(u.path)")
            }
        }
        print("r=\(String(describing: r))")
        // :RESULT:NONE: not possible
        r = McOsax.chooseApplication(prompt: "Select NONE:")
        print("r=\(String(describing: r))")
        // :RESULT:CANCEL:
        r = McOsax.chooseApplication(prompt: "Select CANCEL:")
        print("r=\(String(describing: r))")
    }
    
    func testChooseFile() {
        var r = McOsax.chooseFile()
        print("r=\(String(describing: r))")
        // :RESULT:SINGLE:
        r = McOsax.chooseFile(prompt: "Select SINGLE file:", allowMultipleSelections: false)
        print("r=\(String(describing: r))")
        r = McOsax.chooseFile(prompt: "Select SINGLE INVISIBLE or PACKAGE file:", allowMultipleSelections: false, showInvisibles: true, showPackageContents: true)
        print("r=\(String(describing: r))")
        // :RESULT:MULTIPLE:
        r = McOsax.chooseFile(prompt: "Select MULTIPLE files:", allowMultipleSelections: true)
        if let urls = r {
            for u in urls {
                print("path=\(u.path)")
            }
        }
        print("r=\(String(describing: r))")
        // :RESULT:NONE: not possible
        r = McOsax.chooseFile(prompt: "Select NONE:")
        print("r=\(String(describing: r))")
        // :RESULT:CANCEL:
        r = McOsax.chooseFile(prompt: "Select CANCEL:")
        print("r=\(String(describing: r))")
        // :DEFAULT:URL"
        r = McOsax.chooseFile(prompt: "Select file from DEFAULT Documents location:", defaultFolderUrl: McOsaxURL.documents)
        print("r=\(String(describing: r))")        
    }
    
    func testChooseFileDefautlLocation() {
        // :DEFAULT:URL"
        let r = McOsax.chooseFile(prompt: "Select file from DEFAULT Documents location:", defaultFolderUrl: McOsaxURL.documents, allowMultipleSelections: true)
        print("r=\(String(describing: r))")
        if let urlList = r {
            for u in urlList {
                print("path=\(u.path)")
            }
        }
    }
    
    /// added to see what URL strings look like
    func testDesktopUrls() {
        // NOTE: used to view cases where filename contains "/"
        let fm = FileManager.default
        let desktopUrl = fm.homeDirectoryForCurrentUser.appendingPathComponent("Desktop", isDirectory: true) 
        
        print("desktop=\(desktopUrl)")
        print("desktop.path=\(desktopUrl.path)")
        
        //        FileManager.DirectoryEnumerationOptions.skipsHiddenFiles
        //        FileManager.DirectoryEnumerationOptions.skipsPackageDescendants
        //        FileManager.DirectoryEnumerationOptions.skipsSubdirectoryDescendants
        
        do {
            let urls = try fm.contentsOfDirectory(
                at: desktopUrl, 
                includingPropertiesForKeys: [URLResourceKey.isRegularFileKey], 
                options: [FileManager.DirectoryEnumerationOptions.skipsHiddenFiles])
            
            print("urls=\(urls)")
            for u in urls {
                print("u=\(u)")
                print("u.absoluteString=\(u.absoluteString)")
                print("u.absoluteURL=\(u.absoluteURL)")
                print("u.baseURL=\(String(describing: u.baseURL))")
                print("u.host=\(String(describing: u.host))")
                print("u.scheme=\(String(describing: u.scheme))")
                print("u.scheme=\(u.standardized)")
                print("u.standardizedFileURL=\(u.standardizedFileURL)")
                print("u.path=\(u.path)")
                print("")
            }
        } catch {
            print("testDesktopUrls did not work")
        }
        
        do {
            let a = try fm.attributesOfItem(atPath: desktopUrl.path)
            print("AAA = \(a)" )
        } catch  {
        }
        
        do {
            let b = try fm.attributesOfFileSystem(forPath: desktopUrl.path)
            print("BBB = \(b)" )
        } catch  {
        }
        
        // URLResourceKey.volumeIsRootFileSystemKey
        //let keys: [URLResourceKey] = [.volumeNameKey, .volumeIsRemovableKey, .volumeIsEjectableKey]
        let keys: [URLResourceKey] = [.volumeNameKey]
        let paths = FileManager().mountedVolumeURLs(includingResourceValuesForKeys: keys, options: [])
        if let urls = paths {
            for url in urls {
                print(url)
            }
        }
        
        //        file:///
        //        file:///home/
        //        file:///net/
        //        file:///Volumes/RemovableHD/
    }
    
    func testChooseFileName() {
        var r = McOsax.chooseFileName()
        print("r=\(String(describing: r))")
        r = McOsax.chooseFileName(prompt: "Has defaultName.txt?", defaultName: "defaultName.txt")
        print("r=\(String(describing: r))")
        r = McOsax.chooseFileName(prompt: "In documents folder?", defaultName: "home.txt", defaultFolderUrl: McOsaxURL.documents)
        print("r=\(String(describing: r))")
        // :RESULT:CANCEL:
        r = McOsax.chooseFileName(prompt: "Select CANCEL:")
        print("r=\(String(describing: r))")
    }
    
    func testChooseFolder() {
        _ = McOsax.chooseFolder()
        
        _ = McOsax.chooseFolder(prompt: "Browser should show INVISIBLES:", showInvisibles: true)
        
        _ = McOsax.chooseFolder(prompt: "Browse should show inside PACKAGES:",  showPackageContents: true)
        // :RESULT:SINGLE:
        var r = McOsax.chooseFolder(prompt: "Select SINGLE FOLDER:", allowMultipleSelections: false)
        print("r=\(String(describing: r))")
        // :RESULT:MULTIPLE:
        r = McOsax.chooseFolder(prompt: "Select MULTIPLE FOLDERS:", allowMultipleSelections: true)
        if let urls = r {
            for u in urls {
                print("path=\(u.path)")
            }
        }
        print("r=\(String(describing: r))")
        // :RESULT:CANCEL:
        r = McOsax.chooseFolder(prompt: "Select CANCEL:")
        print("r=\(String(describing: r))")
    }
    
    // select: EPSON-WF-7520 returns: smb://w.x.y.z:port
    func testChooseUrl() {
        var r = McOsax.chooseUrl(editable: false)
        print("r=\(String(describing: r))")
        r = McOsax.chooseUrl(showing: ["File servers"])
        print("r=\(String(describing: r))")
    }
    
    ///
    /// Unicode text, 42, 
    /// string, 21, 
    /// styled Clipboard text, 22, 
    /// «class utf8», 21, 
    /// «class ut16», 44, 
    /// styled Clipboard text, 22
    /// 
    /// «class HTML», 389, TIFF picture, 5790166, «class 8BPS», 2975502, GIF picture, 322389, «class jp2 », 292180, JPEG picture, 263633, «class PNGf», 1161372, «class BMP », 5787654, «class TPIC», 1777773
    func testClipboard() {
        var info = McOsax.clipboardInfo()
        print("clipboard info = \(info)")
        
        McOsax.clipboardSet("Clipboard test string")
        
        info = McOsax.clipboardInfo()
        print("clipboard info = \(info)")
        
        info = McOsax.clipboardGet()
        print("clipboard info = \(info)")
        
    }
    
    func testDelay() {
        McOsax.delay(seconds: 3.5794)
    }
    
    // MARK: - Display Alert, Dialog, Notification
    
    // :!!!:NEXT:
    func testDisplayAlert() {
        var r = McOsax.displayAlert(
            message: "This is the minimal alert.")
        print("r=\(String(describing: r))") 
        r = McOsax.displayAlert(
            message: "Stop. Critical decision?", 
            icon: .stop)
        print("r=\(String(describing: r))") 
        r = McOsax.displayAlert(
            message: "Warning. Are you be cautious?", 
            icon: .caution)
        print("r=\(String(describing: r))") 
        r = McOsax.displayAlert(
            message: "Note. Have you been informed?", 
            icon: .note)
        print("r=\(String(describing: r))") 
        r = McOsax.displayAlert(
            message: "Did you get the main message?", 
            buttons: ["yes", "no", "maybe"],
            buttonDefault: "maybe",
            buttonCancel: "no",
            icon: .stop)
        print("r=\(String(describing: r))")   
    }
    
    func testDisplayAlertAllFields() {
        let r = McOsax.displayAlert(
            message: "State the month of the tourmaline birthstone:", 
            submessage: "Whom shall pass?", 
            buttons: ["maybe", "now", "later"],
            buttonDefault: "now",
            buttonCancel: "later",
            icon: .stop)
        print("r=\(String(describing: r))")        
    }
    
    func testDisplayDialog() {
        _ = McOsax.displayDialog(message: "Hello.")
        _ = McOsax.displayDialog(message: "Be cautious…", icon: McOsaxIcon.caution)
        _ = McOsax.displayDialog(message: "Take notes. Write that down.", icon: .note)
        _ = McOsax.displayDialog(message: "Whoa!!!", icon: .stop)
        
        _ = McOsax.displayDialog(message: "What is 1 + 1?", title: "Simple Math", answerDefault: "one plus one")
        _ = McOsax.displayDialog(message: "State the month of the tourmaline birthstone:", title: "Whom shall pass?", answerDefault: "October", answerIsHidden: true, icon: .stop)
        
    }
    
    func testDisplayDialogAllFields() {
        let r = McOsax.displayDialog(
            message: "State the month of the tourmaline birthstone:", 
            title: "Whom shall pass?", 
            answerDefault: "October", 
            answerIsHidden: true, 
            buttons: ["maybe", "now", "later"],
            buttonDefault: "now",
            buttonCancel: "later",
            icon: .stop)
        print("r=\(String(describing: r))")
    }
    
    
    func testDisplayNotification() {
        McOsax.displayNotification(message: "Some message here.", title: "Test Notification")
        McOsax.delay(seconds: 3.5)
        McOsax.displayNotification(message: "Some message here", title: "Title Here", subtitle: "sub title", sound: "Submarine")
    }
    
    
    func testSay() {
        McOsax.say(spokenText: "Hello. How are you?")
        McOsax.say(spokenText: "Går bra. Tack för att du frågar.", usingVoice: "Klara", waitUntilCompletion: true)
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    static var allTests = [
        // :!!!:NYI: add remain tests
        ("testSay", testSay),
        ("testPerformanceExample", testPerformanceExample),
    ]
    
}

//
//  MCxSystemExecOsaxTests.swift
//  MCxSystemExecOsaxTests
//
//  Created by marc-medley on 2018.01.25.
//  Copyright © 2018 marc-medley. All rights reserved.
//

import XCTest
@testable import MCxSystemExecOsax

class MCxSystemExecOsaxTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testFindMachineInfo() {
        var args: [String] = []
        
        // :NOPE: returns empty string
        //let cmd = "/usr/bin/which"
        //args.append("pandoc")
        
        // :NOPE: returns empty string
        //let cmd = "/usr/bin/whereis"
        //args.append("-b") // search for binaries
        //args.append("-q") // "quiet" suppresses extra labels
        //args.append("pandoc")
        
        // :NOPE: slow. way to much text returned
        //let cmd = "/usr/sbin/system_profiler"
        
        // /usr/sbin/sysctl -n machdep.cpu.brand_string
        // RESULT: (stdout: "Apple M1 Pro\n", stderr: "")
        let cmd = "/usr/sbin/sysctl"
        args.append(contentsOf: ["-n", "machdep.cpu.brand_string"])
        
        let result = McProcess.run(
            executableUrl: URL(fileURLWithPath: cmd, isDirectory: false), 
            withArguments: args,
            currentDirectory: nil,
            printStdio: true
        )
        print(result)
        print("completed 'testWhich'")
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}

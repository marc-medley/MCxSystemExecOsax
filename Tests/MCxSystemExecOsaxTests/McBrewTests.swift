//
//  McBrewTests.swift
//  
//
//  Created by mc on 5/9/23.
//

import XCTest
@testable import MCxSystemExecOsax

final class McBrewTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }
    
    /// developmental use. not run during general testing.
    func installAllBrewPackages() {
        do {
            try McBrew.cmd.installAll()
        } catch {
            print(error)
        }
    }
    
    //func testInstallAllBrewPackages() {
    //    print("""
    //    --------------------------------
    //    --- installAllBrewPackages() ---
    //    """)
    //    //installAllBrewPackages()
    //}
    
    /// developmental use. not run during general testing.
    func installSomeBrewPackages() {
        print("-----------------")
        try! McBrew.cmd.install(formula: "sl")
        
        do {
            print(".................")
            try McBrew.cmd.install(formula: "clamav")
            print(".................")
            try McBrew.cmd.install(formula: "pandoc")
            print(".................")
            try McBrew.cmd.install(formula: "tesseract")
        } catch {
            print(error)
        }
    }
        
    func testInstallProcess() {
        print("-----------------")
        var installed = try! McBrew.cmd.isInstalled(formula: "brew")
        print("brew formula intalled: \(installed)")

        print("-----------------")
        installed = McBrew.cmd.isInstalled(binaryName: "brew")
        print("brew binary intalled: \(installed)")

        print("-----------------")
        try! McBrew.cmd.install(formula: "brew")

        print("-----------------")
        installed = try! McBrew.cmd.isInstalled(formula: "sl")
        print("ls formula intalled: \(installed)")

        print("-----------------")
        installed = McBrew.cmd.isInstalled(binaryName: "sl")
        print("ls binary intalled: \(installed)")
    }
    
    func testListUninstalled() {
        let list = try! McBrew.cmd.listUninstalledFormula()
        print(list)
    }
    
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}

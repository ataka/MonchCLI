import XCTest

import MonchCLITests

var tests = [XCTestCaseEntry]()
tests += MonchCLITests.allTests()
XCTMain(tests)

//
//  PerlWrapper.swift
//  R-Name S
//
//  Created by Pedro Plowman on 25/8/18.
//  Copyright © 2018 p2made. All rights reserved.
//

import Foundation

class PerlWrapper {
	init() {
		super.init()

		myStrOrigin = ""
		myStrFound = ""
		myStrReplacedWith = ""
		myMstrOptions = ""
		myBOptionG = false
		myBOptionI = false

		myMstrScriptPath = ""
		myMstrScriptPath += Bundle.main.bundlePath
		myMstrScriptPath += RELATIVE_SCRIPT_PATH

		//mySmManager = [[StringsManager alloc] init];
	}

	deinit {
		//[mySmManager release];
	}

	func setOriginalString(_ strOrigin: String?) {
		myStrOrigin = strOrigin
	}

	func setStringToBeFound(_ strFound: String?) {
		myStrFound = strFound
	}

	func setStringToBeReplacedWith(_ strReplacedWith: String?) {
		myStrReplacedWith = strReplacedWith
	}

	func setOptionG(_ bOptionG: Bool) {
		myBOptionG = bOptionG
		myMstrOptions = ""
		if myBOptionG == true {
			myMstrOptions += "g"
		}
		if myBOptionI == true {
			myMstrOptions += "i"
		}
	}

	func setOptionI(_ bOptionI: Bool) {
		myBOptionI = bOptionI
		myMstrOptions = ""
		if myBOptionG == true {
			myMstrOptions += "g"
		}
		if myBOptionI == true {
			myMstrOptions += "i"
		}
	}

	func replace() -> String? {
		let tkPerl = Process()
		let ppOutput = Pipe()
		var aArguments: [Any]

		// preparing for launching the task
		aArguments = [myMstrScriptPath, myStrOrigin, myStrFound, myStrReplacedWith, myMstrOptions]
		tkPerl.arguments = aArguments as? [String]
		tkPerl.launchPath = PERL_PATH
		tkPerl.standardOutput = ppOutput

		// ready
		tkPerl.launch()
		tkPerl.waitUntilExit()

		//printf("The termination status is %d\n", [tkPerl terminationStatus]);
		if Int(tkPerl.terminationStatus) == 0 {
			let dtOutput: Data = ppOutput.fileHandleForReading.availableData
			let strOutput = String(data: dtOutput, encoding: .utf8)
			strOutput

			return strOutput
		} else {
			NSException.raise(INVALID_REG_EXP_EXCEPTION, format: "Invalid Regular Expression")
			return ""
		}
	}
}

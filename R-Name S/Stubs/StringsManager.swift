//
//  StringsManager.swift
//  R-Name S
//
//  Created by Pedro Plowman on 13/5/19.
//  Copyright © 2019 p2made. All rights reserved.
//

import Foundation

class StringsManager: NSObject {
	var defaultCaseSensitive = true // default true;
	var defaultReplaceAllFound = true // default true;

	// Configuring StringManager
	func caseSensitive() -> Bool {
		return defaultCaseSensitive
	}

	func setCaseSensitive(_ bCaseSensitive: Bool) {
		defaultCaseSensitive = bCaseSensitive
	}

	func replaceAllFound() -> Bool {
		return defaultReplaceAllFound
	}

	func setReplaceAllFound(_ bReplaceAllFound: Bool) {
		defaultReplaceAllFound = bReplaceAllFound
	}

	// This method find & replace string.
	// This method returns YES if string was found & replaced, otherwise NO.
	// For example
	// 	strString = @"Hello, World"
	// 	strFind = @"Hello"
	// 	strReplace = @"Good morning"
	//			--> Return YES, strStringModified = @"Good morning, World".
	func modifyString(_ strStringToModify: String?, to strStringModified: String?, find strFind: String?, replace strReplace: String?) -> Bool {
		var strStringModified = strStringModified
		var scScanner: Scanner?
		var strScaned: String
		var bFound = false
		var mstrModifiedString: String

		mstrModifiedString = String(repeating: "\0", count: strStringToModify?.count ?? 0)

		scScanner = Scanner(string: strStringToModify ?? "")
		scScanner?.caseSensitive = caseSensitive()
		scScanner?.charactersToBeSkipped = nil

		// In this case, for example
		// find: "me", replace: "you",   "me and me" --> "you and you"
		if replaceAllFound() {
			while !scScanner?.isAtEnd() {
				if scScanner?.scanUpTo(strFind ?? "", into: &strScaned) ?? false {
					mstrModifiedString += strScaned
				}
				if scScanner?.scanString(strFind ?? "", into: &strScaned) ?? false {
					mstrModifiedString += strReplace ?? ""
					bFound = true
				}
			}
		} else {
			// bMyReplaceAllFound == NO
			while !scScanner?.isAtEnd() {
				if scScanner?.scanUpTo(strFind ?? "", into: &strScaned) ?? false {
					mstrModifiedString += strScaned
				}
				if scScanner?.scanString(strFind ?? "", into: nil) ?? false {
					if bFound == false {
						mstrModifiedString += strReplace ?? ""
					} else {
						mstrModifiedString += strFind ?? ""
					}

					bFound = true
				}
			}
		}

		strStringModified = mstrModifiedString
		return bFound
	}

	// This method returns string that is converted '/' and ':'
	func string(withSlushAndColonConverted strBefore: String?) -> String? {
		var strAfter = String(repeating: "\0", count: strBefore?.count ?? 0)
		let scScanner = Scanner(string: strBefore ?? "")
		let csSlushOrColon = CharacterSet(charactersIn: "/:")
		var strNoSlushOrColon: String
		var strSlushOrColon: String

		if strBefore == nil {
			return nil
		}
		if (strBefore?.count ?? 0) == 0 {
			return ""
		}

		scScanner.charactersToBeSkipped = nil
		while !scScanner.isAtEnd() {
			if scScanner.scanUpToCharacters(from: csSlushOrColon, into: &strNoSlushOrColon) {
				strAfter += strNoSlushOrColon
			}
			if scScanner.scanCharacters(from: csSlushOrColon, into: &strSlushOrColon) {
				var iCount: Int

				for iCount in 0..<strSlushOrColon.count {
					if strSlushOrColon[strSlushOrColon.index(strSlushOrColon.startIndex, offsetBy: UInt(iCount))] == "/" {
						strAfter += ":"
					} else {
						// if it is ':'
						strAfter += "/"
					}
				}
			}
		}

		return strAfter
	}
}

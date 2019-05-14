//
//  StringsManager.swift
//  R-Name S
//
//  Created by Pedro Plowman on 13/5/19.
//  Copyright © 2019 p2made. All rights reserved.
//

import Foundation

class StringsManager {

	// Unavailable Functions for class users //
	// MARK: Unavailable_Functions_for_class_users
	// Public Methods //
	// MARK: Public_Methods

	var bMyCaseSensitive = true
	var bMyReplaceAllFound = true

	init() {
		//self = super
		return
	}

	func dealloc() {
		//super.dealloc()
	}

	// Configuring an StringManager ///////////////////////
	func caseSensitive() -> Bool {
		return bMyCaseSensitive
	}

	func setCaseSensitive(_ bCaseSensitive: Bool) {
		bMyCaseSensitive = bCaseSensitive
	}

	func replaceAllFound() -> Bool {
		return bMyReplaceAllFound
	}

	func setReplaceAllFound(_ bReplaceAllFound: Bool) {
		bMyReplaceAllFound = bReplaceAllFound
	}

}

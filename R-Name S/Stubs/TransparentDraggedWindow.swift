//
//  TransparentDraggedWindow.swift
//  R-Name S
//
//  Created by Pedro Plowman on 14/5/19.
//  Copyright © 2019 p2made. All rights reserved.
//

import AppKit // needed?

class TransparentDraggedWindow {

	/*

	init(contentRect: NSRect, styleMask style: NSWindow.StyleMask, backing bufferingType: NSWindow.BackingStoreType, defer flag: Bool) {
		if let aStyle = NSWindow.StyleMask(rawValue: aStyle) {
			super.init(contentRect: contentRect, styleMask: aStyle, backing: bufferingType, defer: flag)
		}
	}

	func draggingEntered(_ sender: NSDraggingInfo) -> UInt {
		let vwRoot = contentView as? NSView

		NSColor.selectedControlColor.set()
		NSFrameRectWithWidth(vwRoot?.visibleRect, 2.5)
		displayIfNeeded()

		return NSDragOperation.generic.rawValue
	}

	func draggingUpdated(_ sender: NSDraggingInfo) -> UInt {
		return NSDragOperation.generic.rawValue
	}

	func draggingExited(_ sender: NSDraggingInfo?) {
		let vwRoot = contentView as? NSView

		NSEraseRect(vwRoot?.visibleRect)
		display()
	}

	func prepareForDragOperation(_ sender: NSDraggingInfo) -> Bool {
		return true
	}

	func performDragOperation(_ sender: NSDraggingInfo) -> Bool {
		if delegate().responds(to: #selector(TransparentDraggedWindow.performDrag(toWindowOperation:))) {
			return delegate().performDrag(toWindowOperation: sender)
		}

		return false
	}

	func concludeDragOperation(_ sender: NSDraggingInfo?) {
		let vwRoot = contentView as? NSView

		NSEraseRect(vwRoot?.visibleRect)
		display()
	}

	init(contentRect: NSRect, styleMask style: NSWindow.StyleMask, backing bufferingType: NSWindow.BackingStoreType, defer flag: Bool) {
		if let aStyle = NSWindow.StyleMask(rawValue: aStyle) {
			super.init(contentRect: contentRect, styleMask: aStyle, backing: bufferingType, defer: flag)
		}
	}

	func draggingEntered(_ sender: NSDraggingInfo) -> UInt {
		let vwRoot = contentView as? NSView

		NSColor.selectedControlColor.set()
		NSFrameRectWithWidth(vwRoot?.visibleRect, 2.5)
		displayIfNeeded()

		return NSDragOperation.generic.rawValue
	}

	func draggingUpdated(_ sender: NSDraggingInfo) -> UInt {
		return NSDragOperation.generic.rawValue
	}

	func draggingExited(_ sender: NSDraggingInfo?) {
		let vwRoot = contentView as? NSView

		NSEraseRect(vwRoot?.visibleRect)
		display()
	}

	func prepareForDragOperation(_ sender: NSDraggingInfo) -> Bool {
		return true
	}

	func performDragOperation(_ sender: NSDraggingInfo) -> Bool {
		if delegate().responds(to: #selector(TransparentDraggedWindow.performDrag(toWindowOperation:))) {
			return delegate().performDrag(toWindowOperation: sender)
		}

		return false
	}

	func concludeDragOperation(_ sender: NSDraggingInfo?) {
		let vwRoot = contentView as? NSView

		NSEraseRect(vwRoot?.visibleRect)
		display()
	}

	*/

}

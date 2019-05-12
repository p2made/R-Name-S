//
//  TransparentDraggedWindow.m
//  WindowTester
//
//  Created by Yoichi Tagaya on Wed May 01 2002.
//  Copyright (c) 2001 Yoichi Tagaya. All rights reserved.
//

#import "TransparentDraggedWindow.h"


@implementation TransparentDraggedWindow

- (id) initWithContentRect: (NSRect)contentRect
                 styleMask: (unsigned int)aStyle
                   backing: (NSBackingStoreType)bufferingType
                     defer: (BOOL)flag
{
   self = [super initWithContentRect: contentRect
                                    styleMask: aStyle
                                      backing: bufferingType
                                        defer: flag];
   return self;
}


- (unsigned int) draggingEntered: (id <NSDraggingInfo>)sender
{
   NSView *vwRoot = [self contentView];
   
   [[NSColor selectedControlColor] set];
   NSFrameRectWithWidth([vwRoot visibleRect], 2.5);
   [self displayIfNeeded];

   return NSDragOperationGeneric;
}

- (unsigned int) draggingUpdated: (id <NSDraggingInfo>)sender
{
   return NSDragOperationGeneric;
}

- (void) draggingExited: (id <NSDraggingInfo>)sender
{
   NSView *vwRoot = [self contentView];

   NSEraseRect([vwRoot visibleRect]);
   [self display];
}

- (BOOL) prepareForDragOperation: (id <NSDraggingInfo>)sender
{
   return YES;
}

- (BOOL) performDragOperation: (id <NSDraggingInfo>)sender
{
   if ([[self delegate] respondsToSelector: @selector(performDragToWindowOperation:)]) {
      return [[self delegate] performDragToWindowOperation: sender];
   }
   
   return NO;
}

- (void) concludeDragOperation: (id <NSDraggingInfo>)sender
{
   NSView *vwRoot = [self contentView];

   NSEraseRect([vwRoot visibleRect]);
   [self display];
}


@end

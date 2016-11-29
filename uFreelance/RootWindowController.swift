//
//  RootWindowController.swift
//  uFreelance
//
//  Created by Vasily Ulianov on 29.11.16.
//  Copyright © 2016 Vasily Ulianov. All rights reserved.
//

import Cocoa

class RootWindowController: NSWindowController {

    override func windowDidLoad() {
        super.windowDidLoad()
    
        // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
		
		self.window?.titleVisibility = .hidden
		self.window?.titlebarAppearsTransparent = true
		self.window?.isMovableByWindowBackground = true
    }

}

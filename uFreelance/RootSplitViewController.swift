//
//  RootSplitViewController.swift
//  uFreelance
//
//  Created by Vasily Ulianov on 28.11.16.
//  Copyright © 2016 Vasily Ulianov. All rights reserved.
//

import Cocoa

class RootSplitViewController: NSSplitViewController {
	
	var authorization: UpworkAuthorization?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
		
		self.view.wantsLayer = true
		self.view.window?.titlebarAppearsTransparent = true
		self.view.window?.isMovableByWindowBackground = true
    }
	
	override func viewDidAppear() {
		super.viewDidAppear()
		
		if let storedCredentials = CredentialsStorage().credentials {
			UpworkAuthorization.setOAuthCredentials(credentials: storedCredentials)
		} else {
			UpworkAuthorization.beginLoginAlert(for: self) {
				print("Completed")
			}
		}
	}
    
}

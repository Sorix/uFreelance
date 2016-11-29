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
		
		self.view.wantsLayer = true // avoiding visual glitches of blurred background
    }
	
	override func viewDidAppear() {
		super.viewDidAppear()
		
		if let storedCredentials = CredentialsStorage().credentials {
			UpworkAuthorization.setOAuthCredentials(credentials: storedCredentials)
			DispatchQueue.global().async {
				print(UpworkService.upworkAPI.metadata.listCategories())
			}
			
		} else {
			UpworkAuthorization.beginLoginAlert(for: self) {
				print("Completed")
			}
		}
	}
    
}

//
//  RootSplitViewController.swift
//  uFreelance
//
//  Created by Vasily Ulianov on 28.11.16.
//  Copyright © 2016 Vasily Ulianov. All rights reserved.
//

import Cocoa

class RootSplitViewController: NSSplitViewController {
	
	var authorization = UpworkAuthorization()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
		
		self.view.wantsLayer = true
    }
	
	override func viewDidAppear() {
		super.viewDidAppear()

		authorization.beginLoginAlert(for: self)
	}
    
}

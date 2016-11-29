//
//  UpworkAuthorization.swift
//  uFreelance
//
//  Created by Vasily Ulianov on 29.11.16.
//  Copyright © 2016 Vasily Ulianov. All rights reserved.
//

import Foundation
import OAuthSwift
import Cocoa

class UpworkAuthorization {	
	let oauth: OAuth1Swift
	
	init() {
		// Why we're storing keys here and not in config? Because we don't want to expose easily that key in memory
		// And if our secret will be compromised we can receive sanctions from Upwork
		// Better to do on-fly decryption so that key won't be in source code but it is in TODO list
		
		oauth = OAuth1Swift(
			consumerKey: "01d99a18e30d8744f993c321526adfa2",
			consumerSecret: "8a1d2d0195ae0efc",
			requestTokenUrl: "https://www.upwork.com/api/auth/v1/oauth/token/request",
			authorizeUrl: "https://www.upwork.com/services/api/auth",
			accessTokenUrl: "https://www.upwork.com/api/auth/v1/oauth/token/access"
		)
	}
	
	static var hasSavedCredentials: Bool {
		let storage = CredentialsStorage()
		return storage.token != nil && storage.tokenSecret != nil
	}
	
	func authorize(usingHandler handler: OAuthSwiftURLHandlerType, onSuccess: @escaping () -> Void, onError: @escaping (_ errorText: String) -> Void) {
		oauth.authorizeURLHandler = handler
		
		let successHandler: OAuthSwift.TokenSuccessHandler = { (credential, response, parameters) in
			let storage = CredentialsStorage()
			storage.token = credential.oauthToken
			storage.tokenSecret = credential.oauthTokenSecret
			
			onSuccess()
		}
		
		let failureHandler: OAuthSwift.FailureHandler = { error in
			onError(error.localizedDescription)
		}

		oauth.authorize(withCallbackURL: "oauth-swift://ufreelance", success: successHandler, failure: failureHandler)
	}
	
	func beginLoginAlert(for viewController: NSViewController) {
		let titleText = "Login to Upwork"
		let messageText = "In order to get a job list you need to login to Upwork (it is required for using Upwork API). You will login through Upwork website, no password will be stored or available to application."
		
		let alert = NSAlert()
		alert.addButton(withTitle: "Login")
		
		alert.addButton(withTitle: "Exit")
		alert.messageText = titleText
		alert.informativeText = messageText
		alert.alertStyle = .informational
		
		guard let window = viewController.view.window else {
			assertionFailure("No window found in View Controller")
			return
		}
		
		alert.beginSheetModal(for: window, completionHandler: { response in
			// Exit clicked
			if response != NSAlertFirstButtonReturn { exit(0) }
			
			DispatchQueue.main.async {
				let loginViewController = LoginWebViewController()
				viewController.presentViewControllerAsSheet(loginViewController)
				
				self.authorize(usingHandler: loginViewController, onSuccess: {
					print("Success")
				}, onError: { (errorText) in
					print(errorText)
				})
			}
		})
	}
}

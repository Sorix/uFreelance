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
	static let oauth = OAuth1Swift(
		consumerKey: "01d99a18e30d8744f993c321526adfa2",
		consumerSecret: "8a1d2d0195ae0efc",
		requestTokenUrl: "https://www.upwork.com/api/auth/v1/oauth/token/request",
		authorizeUrl: "https://www.upwork.com/services/api/auth",
		accessTokenUrl: "https://www.upwork.com/api/auth/v1/oauth/token/access"
	)
	
	/// Write stored credentials to OAuthSwift module
	static func setOAuthCredentials(credentials: OAuthCredentials) {
		oauth.client.credential.oauthToken = credentials.token
		oauth.client.credential.oauthTokenSecret = credentials.tokenSecret
	}
	
	/// Begin OAuth authorization process
	///
	/// - Parameters:
	///   - handler: ViewController with `OAuthSwiftURLHandlerType` type
	private static func authorize(usingHandler handler: OAuthSwiftURLHandlerType, onSuccess: @escaping () -> Void, onError: @escaping (_ errorText: String) -> Void) {
		oauth.authorizeURLHandler = handler
		
		let successHandler: OAuthSwift.TokenSuccessHandler = { (credential, response, parameters) in
			let oauthCredentials = OAuthCredentials(token: credential.oauthToken, tokenSecret: credential.oauthTokenSecret)
			CredentialsStorage().credentials = oauthCredentials
			
			oauth.authorizeURLHandler = OAuthSwiftOpenURLExternally.sharedInstance // retain reference to own handler
			
			onSuccess()
		}
		
		let failureHandler: OAuthSwift.FailureHandler = { error in
			oauth.authorizeURLHandler = OAuthSwiftOpenURLExternally.sharedInstance // retain reference to own handler
			
			onError(error.localizedDescription)
		}

		oauth.authorize(withCallbackURL: "oauth-swift://ufreelance", success: successHandler, failure: failureHandler)
	}
	
	
	/// Show sheet modal login alert, and if `Login` button is clicked show Upwork login page
	///
	/// - Parameters:
	///   - viewController: root view controller for `beginSheetModal` method
	///   - onSuccess: called upon success authorization
	static func beginLoginAlert(for viewController: NSViewController, onSuccess: @escaping () -> Void) {
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
					onSuccess()
				}, onError: { (errorText) in
					// FIXME: Error processing
					print(errorText)
				})
			}
		})
	}
}

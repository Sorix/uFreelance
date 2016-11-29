//
//  LoginWebViewController.swift
//  uFreelance
//
//  Created by Vasily Ulianov on 29.11.16.
//  Copyright © 2016 Vasily Ulianov. All rights reserved.
//

import Foundation
import Cocoa
import OAuthSwift
import WebKit

/// ViewController with Upwork login webview responsible for authentication flow
class LoginWebViewController: WebViewWithProgressIndicatorController, OAuthSwiftURLHandlerType {
	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.minimumWebViewHeightConstraint.constant = 530
	}
	
	convenience init() {
		self.init(autoload: URL(string: "https://www.upwork.com/login")!)
	}

	func handle(_ url: URL) {
		let req = URLRequest(url: url)
		webView.load(req)
	}
	
	func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
		guard let url = navigationAction.request.url else {
			decisionHandler(.allow)
			return
		}
		
		// Handle internally the callback url and call method that call handleOpenURL
		// We're not using OAuthSwift appSchemes
		if getVerifier(from: url) != nil {
			OAuthSwift.handle(url: url)
			decisionHandler(.cancel)
			
			dismissViewController(self)
			return
		}
		
		decisionHandler(.allow)
	}
	
	
	/// Extract Upwork OAuth verifier from URL, we need this becuase Upwork returns verifier in URL
	private func getVerifier(from webViewURL: URL?) -> String? {
		guard let urlString = webViewURL?.absoluteString else { return nil }
		
		guard let arguments = argumentsToDictionary(urlString: urlString) else { return nil }
		
		if let verifier = arguments["oauth_verifier"] {
			return verifier
		} else {
			return nil
		}
	}
	
	
	/// Convert HTTP arguments to dictionary
	///
	/// - Parameter urlString: URL in String with arguments, e.g.: `http://test.com/test.php?a=1&b=2`
	/// - Returns: arguments as dictionary, e.g.: `[a: 1, b:2]`
	private func argumentsToDictionary(urlString: String) -> Dictionary<String, String>? {
		var dictionary = Dictionary<String, String>()
		
		let separatedString = urlString.components(separatedBy: "?")
		
		let arguments: String
		if separatedString.count == 2 {
			arguments = separatedString[1]
		} else if separatedString.count == 1 {
			arguments = separatedString[0]
		} else {
			assertionFailure("Received string with too much `?` in URL: \(urlString)")
			return nil
		}
		
		var numberOfArguments = 0
		
		for argument in arguments.components(separatedBy: "&") {
			let argumentSplitted = argument.components(separatedBy: "=")
			
			guard argumentSplitted.count == 2 else {
				continue
			}
			
			dictionary[String(argumentSplitted[0])] = argumentSplitted[1]
			numberOfArguments += 1
		}
		
		return dictionary
	}
}

//
//  WebViewWithProgressIndicatorController
//  uFreelance
//
//  Created by Vasily Ulianov on 29.11.16.
//  Copyright © 2016 Vasily Ulianov. All rights reserved.
//

import Cocoa
import WebKit

class WebViewWithProgressIndicatorController: NSViewController {
	
	@IBOutlet weak var box: NSBox!
	@IBOutlet weak var progressIndicator: NSProgressIndicator!
	@IBOutlet weak var button: NSButton!
	weak var webView: WKWebView!
	
	var url: URL?

	convenience init() {
		self.init(nibName: "WebViewWithProgressIndicatorController", bundle: nil)!
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do view setup here.
		
		addWebView()
	}
	
	override func viewDidAppear() {
		super.viewDidAppear()
		
		if let url = url {
			let request = URLRequest(url: url)
			webView.load(request)
		}
	}
	
	// MARK: - Progress Management

	override func viewWillAppear() {
		super.viewWillAppear()
		webView.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil)
	}
	
	override func viewWillDisappear() {
		super.viewWillDisappear()
		webView.removeObserver(self, forKeyPath: "estimatedProgress")
	}
	
	override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
		if (keyPath == "estimatedProgress") { // listen to changes and updated view
			DispatchQueue.main.async {
				self.setProgress(self.webView.estimatedProgress * 100)
			}
		}
	}
	
	fileprivate func setProgress(_ value: Double) {
		if value == 100 {
			self.progressIndicator.isHidden = true
			return
		}
		
		self.progressIndicator.isHidden = false
		self.progressIndicator.doubleValue = value
	}
	
	// MARK: -

	private func addWebView() {
		let webView = WKWebView()
		self.webView = webView
		
		webView.frame = self.box.contentView!.bounds
		webView.navigationDelegate = self
		webView.translatesAutoresizingMaskIntoConstraints = false
		
		let contentView = box.contentView!
		contentView.addSubview(webView)
		
		NSLayoutConstraint.activate([
			webView.topAnchor.constraint(equalTo: contentView.topAnchor),
			webView.leftAnchor.constraint(equalTo: contentView.leftAnchor),
			webView.rightAnchor.constraint(equalTo: contentView.rightAnchor),
			webView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
			])
	}

	@IBAction func buttonClicked(_ sender: NSButton) {
		exit(0)
	}
}


extension WebViewWithProgressIndicatorController: WKNavigationDelegate {
	func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
		self.setProgress(0)
	}
	
	func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
		self.setProgress(100)
	}
}

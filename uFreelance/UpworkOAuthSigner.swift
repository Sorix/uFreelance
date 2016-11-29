//
//  UpworkOAuthSigner.swift
//  uFreelance
//
//  Created by Vasily Ulianov on 29.11.16.
//  Copyright © 2016 Vasily Ulianov. All rights reserved.
//

import Foundation
import Upwork
import OAuthSwift

/// Class responsible for signing request issued by Upwork framework via `UpworkDelegate` methods
class UpworkOAuthSigner: UpworkDelegate {
	let oauth: OAuth1Swift
	
	init(oauth: OAuth1Swift) {
		self.oauth = oauth
	}
	
	func upwork(signAndSendRequestTo url: URL, withParameters parameters: [String : AnyObject]?) -> Result<Data> {
		assert(!Thread.isMainThread, "Possible thread block, don't call it from main thread")
		
		var result: Result<Data>?
		
		let semaphore = DispatchSemaphore(value: 0)
		let _ = oauth.client.get(url.absoluteString, success: { (response) -> Void in
			result = .success(response.data)
			semaphore.signal()
		}, failure: { error in
			result = .error(UpworkError.custom(error.localizedDescription))
			semaphore.signal()
		})
		
		semaphore.wait()
		
		return result! // force unwrap because it will be set on semaphore call
	}
}

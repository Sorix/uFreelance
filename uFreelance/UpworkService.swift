//
//  UpworkSerice.swift
//  uFreelance
//
//  Created by Vasily Ulianov on 29.11.16.
//  Copyright © 2016 Vasily Ulianov. All rights reserved.
//

import Foundation
import Upwork
import OAuthSwift

class UpworkService {
	let upworkAPI: Upwork
	let requestSigner: UpworkOAuthSigner
	
	static let shared = UpworkService()
	
	init() {
		requestSigner = UpworkOAuthSigner(oauth: UpworkAuthorization.oauth)
		upworkAPI = Upwork(delegate: requestSigner)
	}
}


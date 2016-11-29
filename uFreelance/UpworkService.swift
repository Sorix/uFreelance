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
	static let upworkAPI = Upwork(delegate: requestSigner)
	static let requestSigner = UpworkOAuthSigner(oauth: UpworkAuthorization.oauth)
}


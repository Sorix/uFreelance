//
//  CredentialsStorage.swift
//  uFreelance
//
//  Created by Vasily Ulianov on 29.11.16.
//  Copyright © 2016 Vasily Ulianov. All rights reserved.
//

import Foundation
import KeychainAccess

class CredentialsStorage {
	private let tokenKeychain = Keychain(service: "uFreelance.token")
	private let secretKeychain = Keychain(service: "uFreelance.tokenSecret")
	
	var token: String? {
		get {
			return tokenKeychain["token"]
		}
		set {
			tokenKeychain["token"] = newValue
		}
	}
	
	var tokenSecret: String? {
		get {
			return secretKeychain["tokenSecret"]
		}
		set {
			secretKeychain["tokenSecret"] = newValue
		}
	}
}

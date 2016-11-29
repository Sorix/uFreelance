//
//  CredentialsStorage.swift
//  uFreelance
//
//  Created by Vasily Ulianov on 29.11.16.
//  Copyright © 2016 Vasily Ulianov. All rights reserved.
//

import Foundation
import KeychainAccess

struct OAuthCredentials {
	let token, tokenSecret: String
}

/// Secured keychain storage for token and secret
class CredentialsStorage {
	private let tokenKeychain = Keychain(service: "uFreelance.token")
	private let secretKeychain = Keychain(service: "uFreelance.tokenSecret")
	
	private var token: String? {
		get {
			return tokenKeychain["token"]
		}
		set {
			tokenKeychain["token"] = newValue
		}
	}
	
	private var tokenSecret: String? {
		get {
			return secretKeychain["tokenSecret"]
		}
		set {
			secretKeychain["tokenSecret"] = newValue
		}
	}
	
	/// On value changes credentials are automaticly saved and loaded from keychain
	var credentials: OAuthCredentials? {
		get {
			guard let token = self.token, let tokenSecret = self.tokenSecret else { return nil }
			return OAuthCredentials(token: token, tokenSecret: tokenSecret)
		}
		set {
			if let credentials = newValue {
				self.token = credentials.token
				self.tokenSecret = credentials.tokenSecret
			} else {
				self.token = nil
				self.tokenSecret = nil
			}
		}
	}
}

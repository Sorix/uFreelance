//
//  UpworkToCoreDataConverter.swift
//  uFreelance
//
//  Created by Vasily Ulianov on 30.11.16.
//  Copyright © 2016 Vasily Ulianov. All rights reserved.
//

import Foundation
import Upwork
import CoreData

class UpworkToCoreDataConverter {
	let context: NSManagedObjectContext
	
	init(context: NSManagedObjectContext) {
		self.context = context
	}
	
	/// Job
	func update(coreDataJob cdJob: CDJob, upworkJob: UpworkJob) {
		cdJob.id = upworkJob.id
		cdJob.category = upworkJob.category
		cdJob.url = upworkJob.url.absoluteString
		cdJob.title = upworkJob.title
		cdJob.snippet = upworkJob.snippet
		cdJob.subcategory = upworkJob.subcategory
		cdJob.workload = upworkJob.workload?.rawValue
		cdJob.budget = upworkJob.budget?.number
		cdJob.created = upworkJob.dateCreated as NSDate
		cdJob.jobType = upworkJob.jobType.rawValue
		cdJob.skills = upworkJob.skills?.joined(separator: ",")
		
		let client = CDClient(context: context)
		update(coreDataClient: client, upworkClient: upworkJob.client)
		cdJob.client = client
		
		if let upworkProfile = upworkJob.profile {
			let cdProfile = CDJobProfile(context: context)
			update(coreDataProfile: cdProfile, upworkJobProfile: upworkProfile)
			cdJob.profile = cdProfile
		} else {
			cdJob.profile = nil
		}
	}
	
	/// Job.Client
	private func update(coreDataClient cdClient: CDClient, upworkClient: UpworkJobClient) {
		cdClient.jobsPosted = upworkClient.jobsPosted.number
		cdClient.country = upworkClient.country
		cdClient.reviewsCount = upworkClient.reviewsCount.number
		cdClient.pastHires = upworkClient.pastHires.number
		cdClient.feedbackScore = upworkClient.feedback.number
		cdClient.verified = upworkClient.isVerifiedStatus
	}
	
	/// Job.Profile
	private func update(coreDataProfile cdProfile: CDJobProfile, upworkJobProfile upworkProfile: UpworkJobProfile) {
		cdProfile.ciphertext = upworkProfile.ciphertext
		cdProfile.text = upworkProfile.description
		cdProfile.title = upworkProfile.title
		cdProfile.payTier = upworkProfile.payTier?.rawValue.number
		cdProfile.attached = upworkProfile.attached?.absoluteString
		
		// Not completed: buyer, assignments
	}
	
	
	
}

extension Int {
	var number: NSNumber {
		return NSNumber(integerLiteral: self)
	}
}

extension Double {
	var number: NSNumber {
		return NSNumber(floatLiteral: self)
	}
}

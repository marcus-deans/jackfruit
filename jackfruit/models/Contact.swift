//
//  Contact.swift
//  jackfruit
//
//  Created by Marcus Deans on 2022-07-26.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift


struct Contact {
    @DocumentID var docId: String?
    var id: String? = UUID().uuidString
    var firstName: String?
    var lastName: String?
    var emailAddress: String?
    var phoneNumber: String?
    var location: String?
    var photoURL: String?
    var parameters: [String]?
    var personalContacts: [String]?
    var professionalContacts: [String]?
    var companyName: String?
    var companyPosition: String?
    var linkedinURL: String?
    var instagramURL: String?
    var snapchatURL: String?
    var githubURL: String?
    var twitterURL: String?
    var hometown: String?
    var birthMonth: String?
    var birthNumber: String?
    var universityName: String?
    var universityDegree: String?
    @ServerTimestamp var createdTime: Timestamp?
}

extension Contact: Codable, Identifiable, Equatable {
    static func == (lhs: Contact, rhs: Contact) -> Bool {
        return lhs.phoneNumber == rhs.phoneNumber
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case firstName = "first_name"
        case lastName = "last_name"
        case emailAddress = "email_address"
        case phoneNumber = "phone_number"
        case location
        case photoURL = "photo_url"
        case parameters
        case personalContacts = "personal_contacts"
        case professionalContacts = "professional_contacts"
        case companyName = "company_name"
        case companyPosition = "company_position"
        case linkedinURL = "linkedin_url"
        case instagramURL = "instagram_url"
        case snapchatURL = "snapchat_url"
        case githubURL = "github_url"
        case twitterURL = "twitter_url"
        case hometown
        case birthMonth = "birth_month"
        case birthNumber = "birth_number"
        case universityName = "university_name"
        case universityDegree = "university_degree"
    }
    
}

extension Contact: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(phoneNumber)
    }
}

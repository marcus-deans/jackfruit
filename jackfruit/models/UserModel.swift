//
//  UserModel.swift
//  jackfruit
//
//  Created by Marcus Deans on 2022-07-07.
//

import Foundation

struct UserModel : Codable, Identifiable, Hashable{
    var id: UUID
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
    
//    var professionalParameters: ProfessionalParameters?
//    var personalParameters: PersonalParameters?
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(phoneNumber)
    }
    
    static func == (lhs: UserModel, rhs: UserModel) -> Bool {
        return lhs.phoneNumber == rhs.phoneNumber
    }
    
    
    init(id: UUID? = UUID(), firstName: String? = "", lastName: String? = "", emailAddress: String? = "", phoneNumber: String? = "", location: String? = "", photoURL: String? = "", parameters: [String]? = [], personalContacts: [String]? = [], professionalContacts: [String]? = [], companyName: String? = "", companyPosition: String? = "", linkdinURL: String? = "", instagramURL: String? = "", snapchatURL: String? = "", githubURL: String? = "", twitterURL: String? = "", hometown: String? = "", birthMonth: String? = "", birthNumber: String? = "", universityName: String? = "", universityDegree: String? = "") {
        self.id = id ?? UUID()
        self.firstName = firstName ?? ""
        self.lastName = lastName ?? ""
        self.emailAddress = emailAddress ?? ""
        self.phoneNumber = phoneNumber ?? ""
        self.location = location ?? ""
        self.photoURL = photoURL ?? ""
        self.parameters = parameters ?? []
        self.personalContacts = personalContacts
        self.professionalContacts = professionalContacts
        self.companyName = companyName
        self.companyPosition = companyPosition
        self.linkedinURL = linkedinURL
        self.instagramURL = instagramURL
        self.snapchatURL = snapchatURL
        self.githubURL = githubURL
        self.twitterURL = twitterURL
        self.hometown = hometown
        self.birthMonth = birthMonth
        self.birthNumber = birthNumber
        self.universityName = universityName
        self.universityDegree = universityDegree
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
//        case professionalParameters = "professional_parameters"
//        case personalParameters = "personal_parameters"
    }
    
    struct ProfessionalParameters: Codable {
        var machineLearning: Bool?
        var hasMba: Bool?
        var hasCs: Bool?
        var hasEngineering: Bool?
        var finance: Bool?
        var marketing: Bool?
        var consulting: Bool?
        var startup: Bool?
//        var experienceYears: String?
//        var companyTitle: String?
//        var companyPosition: String?
//        var professional: Bool?
//        var backend: Bool?
//        var frontend: Bool?
//        var cloud: Bool?
        

        enum CodingKeys: String, CodingKey {
            case machineLearning = "machine_learning"
            case hasMba = "has_mba"
            case hasCs = "has_cs"
            case hasEngineering = "has_engineering"
            case finance
            case marketing
            case consulting
            case startup
//            case experienceYears = "experience_years"
//            case companyTitle = "company_title"
//            case companyPosition = "company_position"
//            case professional
//            case backend
//            case frontend
//            case cloud
        }
    }
    
    struct PersonalParameters: Codable {
        var soccer: Bool?
        var basketball: Bool?
        var tennis: Bool?
        var musician: Bool?
        var musicListener: Bool?
        var foodie: Bool?
        var fashion: Bool?
        var gamer: Bool?
        var pets: Bool?
        
        enum CodingKeys: String, CodingKey {
            case soccer
            case basketball
            case tennis
            case musician
            case musicListener = "music_listener"
            case foodie
            case fashion
            case gamer
            case pets
        }
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        do {
            self.id = try UUID(uuidString:  String(values.decode(Int.self, forKey: .id))) ?? UUID()
        } catch DecodingError.typeMismatch {
            self.id = try UUID(uuidString: values.decode(String.self, forKey: .id)) ?? UUID()
        }
        
        self.firstName = try values.decode(String.self, forKey: .firstName)
        self.lastName = try values.decode(String.self, forKey: .lastName)
        self.emailAddress = try values.decode(String.self, forKey: .emailAddress)
        do {
            self.phoneNumber = try String(values.decode(Int.self, forKey: .phoneNumber))
        } catch DecodingError.typeMismatch {
            self.phoneNumber = try String(values.decode(String.self, forKey: .phoneNumber))
        }
        self.location = try values.decode(String.self, forKey: .location)
        self.photoURL = try values.decode(String.self, forKey: .photoURL)
        self.parameters = try values.decode([String].self,forKey: .parameters)
        self.personalContacts = try values.decode([String].self, forKey: .personalContacts)
        self.professionalContacts = try values.decode([String].self, forKey: .professionalContacts)
        self.companyName = try values.decode(String.self, forKey: .companyName)
        self.companyPosition = try values.decode(String.self, forKey: .companyPosition)
        self.linkedinURL = try values.decode(String.self, forKey: .linkedinURL)
        self.instagramURL = try values.decode(String.self, forKey: .instagramURL)
        self.snapchatURL = try values.decode(String.self, forKey: .snapchatURL)
        self.githubURL = try values.decode(String.self, forKey: .githubURL)
        self.twitterURL = try values.decode(String.self, forKey: .twitterURL)
        self.hometown = try values.decode(String.self, forKey: .hometown)
        self.birthMonth = try values.decode(String.self, forKey: .birthMonth)
        self.birthNumber = try values.decode(String.self, forKey: .birthNumber)
        self.universityName = try values.decode(String.self, forKey: .universityName)
        self.universityDegree = try values.decode(String.self, forKey: .universityDegree)
//        self.instagram = try values.decode(String.self, forKey: .instagram)
//        self.professionalParameters = try values.decode(ProfessionalParameters.self, forKey: .professionalParameters)
//        self.personalParameters = try values.decode(PersonalParameters.self, forKey: .personalParameters)
    }
    //
    //    init (firstName: String? = "", lastName: String? = "", emailAddress: String? = "", phoneNumber: String? = "", linkedin: String? = "", instagram: String? = "", professionalParameters){
    ////        self.hasOnboarded = hasOnboarded
    //    }
}

extension UserModel: RawRepresentable {
    public init?(rawValue: String) {
        guard let data = rawValue.data(using: .utf8),
              let result = try? JSONDecoder().decode(UserModel.self, from: data)
        else {
            return nil
        }
        self = result
    }
    
    var rawValue: String {
        guard let data = try? JSONEncoder().encode(self),
              let result = String(data: data, encoding: .utf8)
        else {
            return "[]"
        }
        return result
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(firstName, forKey: .firstName)
        try container.encode(lastName, forKey: .lastName)
        try container.encode(emailAddress, forKey: .emailAddress)
        try container.encode(phoneNumber, forKey: .phoneNumber)
        try container.encode(location, forKey: .location)
        try container.encode(photoURL, forKey: .photoURL)
        try container.encode(parameters, forKey: .parameters)
        try container.encode(personalContacts, forKey: .personalContacts)
        try container.encode(professionalContacts, forKey: .professionalContacts)
        try container.encode(companyName, forKey: .companyName)
        try container.encode(companyPosition, forKey: .companyPosition)
        try container.encode(linkedinURL, forKey: .linkedinURL)
        try container.encode(instagramURL, forKey: .instagramURL)
        try container.encode(snapchatURL, forKey: .snapchatURL)
        try container.encode(githubURL, forKey: .githubURL)
        try container.encode(twitterURL, forKey: .twitterURL)
        try container.encode(hometown, forKey: .hometown)
        try container.encode(birthMonth, forKey: .birthMonth)
        try container.encode(birthNumber, forKey: .birthNumber)
        try container.encode(universityName, forKey: .universityName)
        try container.encode(universityDegree , forKey: .universityDegree)
//        try container.encode(instagram, forKey: .instagram)
//        try container.encode(professionalParameters, forKey: .professionalParameters)
//        try container.encode(personalParameters, forKey: .personalParameters)

    }
}

extension Optional: RawRepresentable where Wrapped: Codable {
    public var rawValue: String {
        guard let data = try? JSONEncoder().encode(self),
              let json = String(data: data, encoding: .utf8)
        else {
            return "{}"
        }
        return json
    }

    public init?(rawValue: String) {
        guard let data = rawValue.data(using: .utf8),
              let value = try? JSONDecoder().decode(Self.self, from: data)
        else {
            return nil
        }
        self = value
    }
}

import Foundation

public enum MrHammadClawContactsCommand: String, Codable, Sendable {
    case search = "contacts.search"
    case add = "contacts.add"
}

public struct MrHammadClawContactsSearchParams: Codable, Sendable, Equatable {
    public var query: String?
    public var limit: Int?

    public init(query: String? = nil, limit: Int? = nil) {
        self.query = query
        self.limit = limit
    }
}

public struct MrHammadClawContactsAddParams: Codable, Sendable, Equatable {
    public var givenName: String?
    public var familyName: String?
    public var organizationName: String?
    public var displayName: String?
    public var phoneNumbers: [String]?
    public var emails: [String]?

    public init(
        givenName: String? = nil,
        familyName: String? = nil,
        organizationName: String? = nil,
        displayName: String? = nil,
        phoneNumbers: [String]? = nil,
        emails: [String]? = nil)
    {
        self.givenName = givenName
        self.familyName = familyName
        self.organizationName = organizationName
        self.displayName = displayName
        self.phoneNumbers = phoneNumbers
        self.emails = emails
    }
}

public struct MrHammadClawContactPayload: Codable, Sendable, Equatable {
    public var identifier: String
    public var displayName: String
    public var givenName: String
    public var familyName: String
    public var organizationName: String
    public var phoneNumbers: [String]
    public var emails: [String]

    public init(
        identifier: String,
        displayName: String,
        givenName: String,
        familyName: String,
        organizationName: String,
        phoneNumbers: [String],
        emails: [String])
    {
        self.identifier = identifier
        self.displayName = displayName
        self.givenName = givenName
        self.familyName = familyName
        self.organizationName = organizationName
        self.phoneNumbers = phoneNumbers
        self.emails = emails
    }
}

public struct MrHammadClawContactsSearchPayload: Codable, Sendable, Equatable {
    public var contacts: [MrHammadClawContactPayload]

    public init(contacts: [MrHammadClawContactPayload]) {
        self.contacts = contacts
    }
}

public struct MrHammadClawContactsAddPayload: Codable, Sendable, Equatable {
    public var contact: MrHammadClawContactPayload

    public init(contact: MrHammadClawContactPayload) {
        self.contact = contact
    }
}

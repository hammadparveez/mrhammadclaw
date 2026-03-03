import Foundation

public enum MrHammadClawRemindersCommand: String, Codable, Sendable {
    case list = "reminders.list"
    case add = "reminders.add"
}

public enum MrHammadClawReminderStatusFilter: String, Codable, Sendable {
    case incomplete
    case completed
    case all
}

public struct MrHammadClawRemindersListParams: Codable, Sendable, Equatable {
    public var status: MrHammadClawReminderStatusFilter?
    public var limit: Int?

    public init(status: MrHammadClawReminderStatusFilter? = nil, limit: Int? = nil) {
        self.status = status
        self.limit = limit
    }
}

public struct MrHammadClawRemindersAddParams: Codable, Sendable, Equatable {
    public var title: String
    public var dueISO: String?
    public var notes: String?
    public var listId: String?
    public var listName: String?

    public init(
        title: String,
        dueISO: String? = nil,
        notes: String? = nil,
        listId: String? = nil,
        listName: String? = nil)
    {
        self.title = title
        self.dueISO = dueISO
        self.notes = notes
        self.listId = listId
        self.listName = listName
    }
}

public struct MrHammadClawReminderPayload: Codable, Sendable, Equatable {
    public var identifier: String
    public var title: String
    public var dueISO: String?
    public var completed: Bool
    public var listName: String?

    public init(
        identifier: String,
        title: String,
        dueISO: String? = nil,
        completed: Bool,
        listName: String? = nil)
    {
        self.identifier = identifier
        self.title = title
        self.dueISO = dueISO
        self.completed = completed
        self.listName = listName
    }
}

public struct MrHammadClawRemindersListPayload: Codable, Sendable, Equatable {
    public var reminders: [MrHammadClawReminderPayload]

    public init(reminders: [MrHammadClawReminderPayload]) {
        self.reminders = reminders
    }
}

public struct MrHammadClawRemindersAddPayload: Codable, Sendable, Equatable {
    public var reminder: MrHammadClawReminderPayload

    public init(reminder: MrHammadClawReminderPayload) {
        self.reminder = reminder
    }
}

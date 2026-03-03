import Foundation
import MrHammadClawKit

extension NodeAppModel {
    static func normalizeWatchNotifyParams(_ params: MrHammadClawWatchNotifyParams) -> MrHammadClawWatchNotifyParams {
        var normalized = params
        normalized.title = params.title.trimmingCharacters(in: .whitespacesAndNewlines)
        normalized.body = params.body.trimmingCharacters(in: .whitespacesAndNewlines)
        normalized.promptId = self.trimmedOrNil(params.promptId)
        normalized.sessionKey = self.trimmedOrNil(params.sessionKey)
        normalized.kind = self.trimmedOrNil(params.kind)
        normalized.details = self.trimmedOrNil(params.details)
        normalized.priority = self.normalizedWatchPriority(params.priority, risk: params.risk)
        normalized.risk = self.normalizedWatchRisk(params.risk, priority: normalized.priority)

        let normalizedActions = self.normalizeWatchActions(
            params.actions,
            kind: normalized.kind,
            promptId: normalized.promptId)
        normalized.actions = normalizedActions.isEmpty ? nil : normalizedActions
        return normalized
    }

    static func normalizeWatchActions(
        _ actions: [MrHammadClawWatchAction]?,
        kind: String?,
        promptId: String?) -> [MrHammadClawWatchAction]
    {
        let provided = (actions ?? []).compactMap { action -> MrHammadClawWatchAction? in
            let id = action.id.trimmingCharacters(in: .whitespacesAndNewlines)
            let label = action.label.trimmingCharacters(in: .whitespacesAndNewlines)
            guard !id.isEmpty, !label.isEmpty else { return nil }
            return MrHammadClawWatchAction(
                id: id,
                label: label,
                style: self.trimmedOrNil(action.style))
        }
        if !provided.isEmpty {
            return Array(provided.prefix(4))
        }

        // Only auto-insert quick actions when this is a prompt/decision flow.
        guard promptId?.isEmpty == false else {
            return []
        }

        let normalizedKind = kind?.trimmingCharacters(in: .whitespacesAndNewlines).lowercased() ?? ""
        if normalizedKind.contains("approval") || normalizedKind.contains("approve") {
            return [
                MrHammadClawWatchAction(id: "approve", label: "Approve"),
                MrHammadClawWatchAction(id: "decline", label: "Decline", style: "destructive"),
                MrHammadClawWatchAction(id: "open_phone", label: "Open iPhone"),
                MrHammadClawWatchAction(id: "escalate", label: "Escalate"),
            ]
        }

        return [
            MrHammadClawWatchAction(id: "done", label: "Done"),
            MrHammadClawWatchAction(id: "snooze_10m", label: "Snooze 10m"),
            MrHammadClawWatchAction(id: "open_phone", label: "Open iPhone"),
            MrHammadClawWatchAction(id: "escalate", label: "Escalate"),
        ]
    }

    static func normalizedWatchRisk(
        _ risk: MrHammadClawWatchRisk?,
        priority: MrHammadClawNotificationPriority?) -> MrHammadClawWatchRisk?
    {
        if let risk { return risk }
        switch priority {
        case .passive:
            return .low
        case .active:
            return .medium
        case .timeSensitive:
            return .high
        case nil:
            return nil
        }
    }

    static func normalizedWatchPriority(
        _ priority: MrHammadClawNotificationPriority?,
        risk: MrHammadClawWatchRisk?) -> MrHammadClawNotificationPriority?
    {
        if let priority { return priority }
        switch risk {
        case .low:
            return .passive
        case .medium:
            return .active
        case .high:
            return .timeSensitive
        case nil:
            return nil
        }
    }

    static func trimmedOrNil(_ value: String?) -> String? {
        let trimmed = value?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        return trimmed.isEmpty ? nil : trimmed
    }
}

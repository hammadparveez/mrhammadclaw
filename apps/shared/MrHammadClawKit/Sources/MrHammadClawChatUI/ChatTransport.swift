import Foundation

public enum MrHammadClawChatTransportEvent: Sendable {
    case health(ok: Bool)
    case tick
    case chat(MrHammadClawChatEventPayload)
    case agent(MrHammadClawAgentEventPayload)
    case seqGap
}

public protocol MrHammadClawChatTransport: Sendable {
    func requestHistory(sessionKey: String) async throws -> MrHammadClawChatHistoryPayload
    func sendMessage(
        sessionKey: String,
        message: String,
        thinking: String,
        idempotencyKey: String,
        attachments: [MrHammadClawChatAttachmentPayload]) async throws -> MrHammadClawChatSendResponse

    func abortRun(sessionKey: String, runId: String) async throws
    func listSessions(limit: Int?) async throws -> MrHammadClawChatSessionsListResponse

    func requestHealth(timeoutMs: Int) async throws -> Bool
    func events() -> AsyncStream<MrHammadClawChatTransportEvent>

    func setActiveSessionKey(_ sessionKey: String) async throws
}

extension MrHammadClawChatTransport {
    public func setActiveSessionKey(_: String) async throws {}

    public func abortRun(sessionKey _: String, runId _: String) async throws {
        throw NSError(
            domain: "MrHammadClawChatTransport",
            code: 0,
            userInfo: [NSLocalizedDescriptionKey: "chat.abort not supported by this transport"])
    }

    public func listSessions(limit _: Int?) async throws -> MrHammadClawChatSessionsListResponse {
        throw NSError(
            domain: "MrHammadClawChatTransport",
            code: 0,
            userInfo: [NSLocalizedDescriptionKey: "sessions.list not supported by this transport"])
    }
}

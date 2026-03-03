import CoreLocation
import Foundation
import MrHammadClawKit
import UIKit

protocol CameraServicing: Sendable {
    func listDevices() async -> [CameraController.CameraDeviceInfo]
    func snap(params: MrHammadClawCameraSnapParams) async throws -> (format: String, base64: String, width: Int, height: Int)
    func clip(params: MrHammadClawCameraClipParams) async throws -> (format: String, base64: String, durationMs: Int, hasAudio: Bool)
}

protocol ScreenRecordingServicing: Sendable {
    func record(
        screenIndex: Int?,
        durationMs: Int?,
        fps: Double?,
        includeAudio: Bool?,
        outPath: String?) async throws -> String
}

@MainActor
protocol LocationServicing: Sendable {
    func authorizationStatus() -> CLAuthorizationStatus
    func accuracyAuthorization() -> CLAccuracyAuthorization
    func ensureAuthorization(mode: MrHammadClawLocationMode) async -> CLAuthorizationStatus
    func currentLocation(
        params: MrHammadClawLocationGetParams,
        desiredAccuracy: MrHammadClawLocationAccuracy,
        maxAgeMs: Int?,
        timeoutMs: Int?) async throws -> CLLocation
    func startLocationUpdates(
        desiredAccuracy: MrHammadClawLocationAccuracy,
        significantChangesOnly: Bool) -> AsyncStream<CLLocation>
    func stopLocationUpdates()
    func startMonitoringSignificantLocationChanges(onUpdate: @escaping @Sendable (CLLocation) -> Void)
    func stopMonitoringSignificantLocationChanges()
}

protocol DeviceStatusServicing: Sendable {
    func status() async throws -> MrHammadClawDeviceStatusPayload
    func info() -> MrHammadClawDeviceInfoPayload
}

protocol PhotosServicing: Sendable {
    func latest(params: MrHammadClawPhotosLatestParams) async throws -> MrHammadClawPhotosLatestPayload
}

protocol ContactsServicing: Sendable {
    func search(params: MrHammadClawContactsSearchParams) async throws -> MrHammadClawContactsSearchPayload
    func add(params: MrHammadClawContactsAddParams) async throws -> MrHammadClawContactsAddPayload
}

protocol CalendarServicing: Sendable {
    func events(params: MrHammadClawCalendarEventsParams) async throws -> MrHammadClawCalendarEventsPayload
    func add(params: MrHammadClawCalendarAddParams) async throws -> MrHammadClawCalendarAddPayload
}

protocol RemindersServicing: Sendable {
    func list(params: MrHammadClawRemindersListParams) async throws -> MrHammadClawRemindersListPayload
    func add(params: MrHammadClawRemindersAddParams) async throws -> MrHammadClawRemindersAddPayload
}

protocol MotionServicing: Sendable {
    func activities(params: MrHammadClawMotionActivityParams) async throws -> MrHammadClawMotionActivityPayload
    func pedometer(params: MrHammadClawPedometerParams) async throws -> MrHammadClawPedometerPayload
}

struct WatchMessagingStatus: Sendable, Equatable {
    var supported: Bool
    var paired: Bool
    var appInstalled: Bool
    var reachable: Bool
    var activationState: String
}

struct WatchQuickReplyEvent: Sendable, Equatable {
    var replyId: String
    var promptId: String
    var actionId: String
    var actionLabel: String?
    var sessionKey: String?
    var note: String?
    var sentAtMs: Int?
    var transport: String
}

struct WatchNotificationSendResult: Sendable, Equatable {
    var deliveredImmediately: Bool
    var queuedForDelivery: Bool
    var transport: String
}

protocol WatchMessagingServicing: AnyObject, Sendable {
    func status() async -> WatchMessagingStatus
    func setReplyHandler(_ handler: (@Sendable (WatchQuickReplyEvent) -> Void)?)
    func sendNotification(
        id: String,
        params: MrHammadClawWatchNotifyParams) async throws -> WatchNotificationSendResult
}

extension CameraController: CameraServicing {}
extension ScreenRecordService: ScreenRecordingServicing {}
extension LocationService: LocationServicing {}

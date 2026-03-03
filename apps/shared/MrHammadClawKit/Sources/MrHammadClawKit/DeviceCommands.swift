import Foundation

public enum MrHammadClawDeviceCommand: String, Codable, Sendable {
    case status = "device.status"
    case info = "device.info"
}

public enum MrHammadClawBatteryState: String, Codable, Sendable {
    case unknown
    case unplugged
    case charging
    case full
}

public enum MrHammadClawThermalState: String, Codable, Sendable {
    case nominal
    case fair
    case serious
    case critical
}

public enum MrHammadClawNetworkPathStatus: String, Codable, Sendable {
    case satisfied
    case unsatisfied
    case requiresConnection
}

public enum MrHammadClawNetworkInterfaceType: String, Codable, Sendable {
    case wifi
    case cellular
    case wired
    case other
}

public struct MrHammadClawBatteryStatusPayload: Codable, Sendable, Equatable {
    public var level: Double?
    public var state: MrHammadClawBatteryState
    public var lowPowerModeEnabled: Bool

    public init(level: Double?, state: MrHammadClawBatteryState, lowPowerModeEnabled: Bool) {
        self.level = level
        self.state = state
        self.lowPowerModeEnabled = lowPowerModeEnabled
    }
}

public struct MrHammadClawThermalStatusPayload: Codable, Sendable, Equatable {
    public var state: MrHammadClawThermalState

    public init(state: MrHammadClawThermalState) {
        self.state = state
    }
}

public struct MrHammadClawStorageStatusPayload: Codable, Sendable, Equatable {
    public var totalBytes: Int64
    public var freeBytes: Int64
    public var usedBytes: Int64

    public init(totalBytes: Int64, freeBytes: Int64, usedBytes: Int64) {
        self.totalBytes = totalBytes
        self.freeBytes = freeBytes
        self.usedBytes = usedBytes
    }
}

public struct MrHammadClawNetworkStatusPayload: Codable, Sendable, Equatable {
    public var status: MrHammadClawNetworkPathStatus
    public var isExpensive: Bool
    public var isConstrained: Bool
    public var interfaces: [MrHammadClawNetworkInterfaceType]

    public init(
        status: MrHammadClawNetworkPathStatus,
        isExpensive: Bool,
        isConstrained: Bool,
        interfaces: [MrHammadClawNetworkInterfaceType])
    {
        self.status = status
        self.isExpensive = isExpensive
        self.isConstrained = isConstrained
        self.interfaces = interfaces
    }
}

public struct MrHammadClawDeviceStatusPayload: Codable, Sendable, Equatable {
    public var battery: MrHammadClawBatteryStatusPayload
    public var thermal: MrHammadClawThermalStatusPayload
    public var storage: MrHammadClawStorageStatusPayload
    public var network: MrHammadClawNetworkStatusPayload
    public var uptimeSeconds: Double

    public init(
        battery: MrHammadClawBatteryStatusPayload,
        thermal: MrHammadClawThermalStatusPayload,
        storage: MrHammadClawStorageStatusPayload,
        network: MrHammadClawNetworkStatusPayload,
        uptimeSeconds: Double)
    {
        self.battery = battery
        self.thermal = thermal
        self.storage = storage
        self.network = network
        self.uptimeSeconds = uptimeSeconds
    }
}

public struct MrHammadClawDeviceInfoPayload: Codable, Sendable, Equatable {
    public var deviceName: String
    public var modelIdentifier: String
    public var systemName: String
    public var systemVersion: String
    public var appVersion: String
    public var appBuild: String
    public var locale: String

    public init(
        deviceName: String,
        modelIdentifier: String,
        systemName: String,
        systemVersion: String,
        appVersion: String,
        appBuild: String,
        locale: String)
    {
        self.deviceName = deviceName
        self.modelIdentifier = modelIdentifier
        self.systemName = systemName
        self.systemVersion = systemVersion
        self.appVersion = appVersion
        self.appBuild = appBuild
        self.locale = locale
    }
}

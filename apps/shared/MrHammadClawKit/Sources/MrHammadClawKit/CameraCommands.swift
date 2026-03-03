import Foundation

public enum MrHammadClawCameraCommand: String, Codable, Sendable {
    case list = "camera.list"
    case snap = "camera.snap"
    case clip = "camera.clip"
}

public enum MrHammadClawCameraFacing: String, Codable, Sendable {
    case back
    case front
}

public enum MrHammadClawCameraImageFormat: String, Codable, Sendable {
    case jpg
    case jpeg
}

public enum MrHammadClawCameraVideoFormat: String, Codable, Sendable {
    case mp4
}

public struct MrHammadClawCameraSnapParams: Codable, Sendable, Equatable {
    public var facing: MrHammadClawCameraFacing?
    public var maxWidth: Int?
    public var quality: Double?
    public var format: MrHammadClawCameraImageFormat?
    public var deviceId: String?
    public var delayMs: Int?

    public init(
        facing: MrHammadClawCameraFacing? = nil,
        maxWidth: Int? = nil,
        quality: Double? = nil,
        format: MrHammadClawCameraImageFormat? = nil,
        deviceId: String? = nil,
        delayMs: Int? = nil)
    {
        self.facing = facing
        self.maxWidth = maxWidth
        self.quality = quality
        self.format = format
        self.deviceId = deviceId
        self.delayMs = delayMs
    }
}

public struct MrHammadClawCameraClipParams: Codable, Sendable, Equatable {
    public var facing: MrHammadClawCameraFacing?
    public var durationMs: Int?
    public var includeAudio: Bool?
    public var format: MrHammadClawCameraVideoFormat?
    public var deviceId: String?

    public init(
        facing: MrHammadClawCameraFacing? = nil,
        durationMs: Int? = nil,
        includeAudio: Bool? = nil,
        format: MrHammadClawCameraVideoFormat? = nil,
        deviceId: String? = nil)
    {
        self.facing = facing
        self.durationMs = durationMs
        self.includeAudio = includeAudio
        self.format = format
        self.deviceId = deviceId
    }
}

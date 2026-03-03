import Foundation

// Stable identifier used for both the macOS LaunchAgent label and Nix-managed defaults suite.
// nix-mrhammadclaw writes app defaults into this suite to survive app bundle identifier churn.
let launchdLabel = "ai.mrhammadclaw.mac"
let gatewayLaunchdLabel = "ai.mrhammadclaw.gateway"
let onboardingVersionKey = "mrhammadclaw.onboardingVersion"
let onboardingSeenKey = "mrhammadclaw.onboardingSeen"
let currentOnboardingVersion = 7
let pauseDefaultsKey = "mrhammadclaw.pauseEnabled"
let iconAnimationsEnabledKey = "mrhammadclaw.iconAnimationsEnabled"
let swabbleEnabledKey = "mrhammadclaw.swabbleEnabled"
let swabbleTriggersKey = "mrhammadclaw.swabbleTriggers"
let voiceWakeTriggerChimeKey = "mrhammadclaw.voiceWakeTriggerChime"
let voiceWakeSendChimeKey = "mrhammadclaw.voiceWakeSendChime"
let showDockIconKey = "mrhammadclaw.showDockIcon"
let defaultVoiceWakeTriggers = ["mrhammadclaw"]
let voiceWakeMaxWords = 32
let voiceWakeMaxWordLength = 64
let voiceWakeMicKey = "mrhammadclaw.voiceWakeMicID"
let voiceWakeMicNameKey = "mrhammadclaw.voiceWakeMicName"
let voiceWakeLocaleKey = "mrhammadclaw.voiceWakeLocaleID"
let voiceWakeAdditionalLocalesKey = "mrhammadclaw.voiceWakeAdditionalLocaleIDs"
let voicePushToTalkEnabledKey = "mrhammadclaw.voicePushToTalkEnabled"
let talkEnabledKey = "mrhammadclaw.talkEnabled"
let iconOverrideKey = "mrhammadclaw.iconOverride"
let connectionModeKey = "mrhammadclaw.connectionMode"
let remoteTargetKey = "mrhammadclaw.remoteTarget"
let remoteIdentityKey = "mrhammadclaw.remoteIdentity"
let remoteProjectRootKey = "mrhammadclaw.remoteProjectRoot"
let remoteCliPathKey = "mrhammadclaw.remoteCliPath"
let canvasEnabledKey = "mrhammadclaw.canvasEnabled"
let cameraEnabledKey = "mrhammadclaw.cameraEnabled"
let systemRunPolicyKey = "mrhammadclaw.systemRunPolicy"
let systemRunAllowlistKey = "mrhammadclaw.systemRunAllowlist"
let systemRunEnabledKey = "mrhammadclaw.systemRunEnabled"
let locationModeKey = "mrhammadclaw.locationMode"
let locationPreciseKey = "mrhammadclaw.locationPreciseEnabled"
let peekabooBridgeEnabledKey = "mrhammadclaw.peekabooBridgeEnabled"
let deepLinkKeyKey = "mrhammadclaw.deepLinkKey"
let modelCatalogPathKey = "mrhammadclaw.modelCatalogPath"
let modelCatalogReloadKey = "mrhammadclaw.modelCatalogReload"
let cliInstallPromptedVersionKey = "mrhammadclaw.cliInstallPromptedVersion"
let heartbeatsEnabledKey = "mrhammadclaw.heartbeatsEnabled"
let debugPaneEnabledKey = "mrhammadclaw.debugPaneEnabled"
let debugFileLogEnabledKey = "mrhammadclaw.debug.fileLogEnabled"
let appLogLevelKey = "mrhammadclaw.debug.appLogLevel"
let voiceWakeSupported: Bool = ProcessInfo.processInfo.operatingSystemVersion.majorVersion >= 26

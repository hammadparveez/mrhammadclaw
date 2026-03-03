package ai.mrhammadclaw.android.node

import ai.mrhammadclaw.android.protocol.MrHammadClawCanvasA2UICommand
import ai.mrhammadclaw.android.protocol.MrHammadClawCanvasCommand
import ai.mrhammadclaw.android.protocol.MrHammadClawCameraCommand
import ai.mrhammadclaw.android.protocol.MrHammadClawLocationCommand
import ai.mrhammadclaw.android.protocol.MrHammadClawNotificationsCommand
import ai.mrhammadclaw.android.protocol.MrHammadClawScreenCommand
import ai.mrhammadclaw.android.protocol.MrHammadClawSmsCommand

enum class InvokeCommandAvailability {
  Always,
  CameraEnabled,
  LocationEnabled,
  SmsAvailable,
  DebugBuild,
}

data class InvokeCommandSpec(
  val name: String,
  val requiresForeground: Boolean = false,
  val availability: InvokeCommandAvailability = InvokeCommandAvailability.Always,
)

object InvokeCommandRegistry {
  val all: List<InvokeCommandSpec> =
    listOf(
      InvokeCommandSpec(
        name = MrHammadClawCanvasCommand.Present.rawValue,
        requiresForeground = true,
      ),
      InvokeCommandSpec(
        name = MrHammadClawCanvasCommand.Hide.rawValue,
        requiresForeground = true,
      ),
      InvokeCommandSpec(
        name = MrHammadClawCanvasCommand.Navigate.rawValue,
        requiresForeground = true,
      ),
      InvokeCommandSpec(
        name = MrHammadClawCanvasCommand.Eval.rawValue,
        requiresForeground = true,
      ),
      InvokeCommandSpec(
        name = MrHammadClawCanvasCommand.Snapshot.rawValue,
        requiresForeground = true,
      ),
      InvokeCommandSpec(
        name = MrHammadClawCanvasA2UICommand.Push.rawValue,
        requiresForeground = true,
      ),
      InvokeCommandSpec(
        name = MrHammadClawCanvasA2UICommand.PushJSONL.rawValue,
        requiresForeground = true,
      ),
      InvokeCommandSpec(
        name = MrHammadClawCanvasA2UICommand.Reset.rawValue,
        requiresForeground = true,
      ),
      InvokeCommandSpec(
        name = MrHammadClawScreenCommand.Record.rawValue,
        requiresForeground = true,
      ),
      InvokeCommandSpec(
        name = MrHammadClawCameraCommand.Snap.rawValue,
        requiresForeground = true,
        availability = InvokeCommandAvailability.CameraEnabled,
      ),
      InvokeCommandSpec(
        name = MrHammadClawCameraCommand.Clip.rawValue,
        requiresForeground = true,
        availability = InvokeCommandAvailability.CameraEnabled,
      ),
      InvokeCommandSpec(
        name = MrHammadClawLocationCommand.Get.rawValue,
        availability = InvokeCommandAvailability.LocationEnabled,
      ),
      InvokeCommandSpec(
        name = MrHammadClawNotificationsCommand.List.rawValue,
      ),
      InvokeCommandSpec(
        name = MrHammadClawSmsCommand.Send.rawValue,
        availability = InvokeCommandAvailability.SmsAvailable,
      ),
      InvokeCommandSpec(
        name = "debug.logs",
        availability = InvokeCommandAvailability.DebugBuild,
      ),
      InvokeCommandSpec(
        name = "debug.ed25519",
        availability = InvokeCommandAvailability.DebugBuild,
      ),
      InvokeCommandSpec(name = "app.update"),
    )

  private val byNameInternal: Map<String, InvokeCommandSpec> = all.associateBy { it.name }

  fun find(command: String): InvokeCommandSpec? = byNameInternal[command]

  fun advertisedCommands(
    cameraEnabled: Boolean,
    locationEnabled: Boolean,
    smsAvailable: Boolean,
    debugBuild: Boolean,
  ): List<String> {
    return all
      .filter { spec ->
        when (spec.availability) {
          InvokeCommandAvailability.Always -> true
          InvokeCommandAvailability.CameraEnabled -> cameraEnabled
          InvokeCommandAvailability.LocationEnabled -> locationEnabled
          InvokeCommandAvailability.SmsAvailable -> smsAvailable
          InvokeCommandAvailability.DebugBuild -> debugBuild
        }
      }
      .map { it.name }
  }
}

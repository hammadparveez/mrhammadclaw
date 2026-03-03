package ai.mrhammadclaw.android.protocol

import org.junit.Assert.assertEquals
import org.junit.Test

class MrHammadClawProtocolConstantsTest {
  @Test
  fun canvasCommandsUseStableStrings() {
    assertEquals("canvas.present", MrHammadClawCanvasCommand.Present.rawValue)
    assertEquals("canvas.hide", MrHammadClawCanvasCommand.Hide.rawValue)
    assertEquals("canvas.navigate", MrHammadClawCanvasCommand.Navigate.rawValue)
    assertEquals("canvas.eval", MrHammadClawCanvasCommand.Eval.rawValue)
    assertEquals("canvas.snapshot", MrHammadClawCanvasCommand.Snapshot.rawValue)
  }

  @Test
  fun a2uiCommandsUseStableStrings() {
    assertEquals("canvas.a2ui.push", MrHammadClawCanvasA2UICommand.Push.rawValue)
    assertEquals("canvas.a2ui.pushJSONL", MrHammadClawCanvasA2UICommand.PushJSONL.rawValue)
    assertEquals("canvas.a2ui.reset", MrHammadClawCanvasA2UICommand.Reset.rawValue)
  }

  @Test
  fun capabilitiesUseStableStrings() {
    assertEquals("canvas", MrHammadClawCapability.Canvas.rawValue)
    assertEquals("camera", MrHammadClawCapability.Camera.rawValue)
    assertEquals("screen", MrHammadClawCapability.Screen.rawValue)
    assertEquals("voiceWake", MrHammadClawCapability.VoiceWake.rawValue)
  }

  @Test
  fun screenCommandsUseStableStrings() {
    assertEquals("screen.record", MrHammadClawScreenCommand.Record.rawValue)
  }

  @Test
  fun notificationsCommandsUseStableStrings() {
    assertEquals("notifications.list", MrHammadClawNotificationsCommand.List.rawValue)
  }
}

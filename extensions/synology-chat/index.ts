import type { MrHammadClawPluginApi } from "mrhammadclaw/plugin-sdk";
import { emptyPluginConfigSchema } from "mrhammadclaw/plugin-sdk";
import { createSynologyChatPlugin } from "./src/channel.js";
import { setSynologyRuntime } from "./src/runtime.js";

const plugin = {
  id: "synology-chat",
  name: "Synology Chat",
  description: "Native Synology Chat channel plugin for MrHammadClaw",
  configSchema: emptyPluginConfigSchema(),
  register(api: MrHammadClawPluginApi) {
    setSynologyRuntime(api.runtime);
    api.registerChannel({ plugin: createSynologyChatPlugin() });
  },
};

export default plugin;

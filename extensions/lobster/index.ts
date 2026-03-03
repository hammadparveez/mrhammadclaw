import type {
  AnyAgentTool,
  MrHammadClawPluginApi,
  MrHammadClawPluginToolFactory,
} from "../../src/plugins/types.js";
import { createLobsterTool } from "./src/lobster-tool.js";

export default function register(api: MrHammadClawPluginApi) {
  api.registerTool(
    ((ctx) => {
      if (ctx.sandboxed) {
        return null;
      }
      return createLobsterTool(api) as AnyAgentTool;
    }) as MrHammadClawPluginToolFactory,
    { optional: true },
  );
}

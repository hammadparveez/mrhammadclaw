import os from "node:os";
import path from "node:path";
import type { PluginRuntime } from "mrhammadclaw/plugin-sdk";

export const msteamsRuntimeStub = {
  state: {
    resolveStateDir: (env: NodeJS.ProcessEnv = process.env, homedir?: () => string) => {
      const override = env.MRHAMMADCLAW_STATE_DIR?.trim() || env.MRHAMMADCLAW_STATE_DIR?.trim();
      if (override) {
        return override;
      }
      const resolvedHome = homedir ? homedir() : os.homedir();
      return path.join(resolvedHome, ".mrhammadclaw");
    },
  },
} as unknown as PluginRuntime;

import type { MrHammadClawConfig } from "./config.js";

export function ensurePluginAllowlisted(
  cfg: MrHammadClawConfig,
  pluginId: string,
): MrHammadClawConfig {
  const allow = cfg.plugins?.allow;
  if (!Array.isArray(allow) || allow.includes(pluginId)) {
    return cfg;
  }
  return {
    ...cfg,
    plugins: {
      ...cfg.plugins,
      allow: [...allow, pluginId],
    },
  };
}

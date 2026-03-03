import type { MrHammadClawConfig } from "../config/config.js";
import type { DmScope } from "../config/types.base.js";

export const ONBOARDING_DEFAULT_DM_SCOPE: DmScope = "per-channel-peer";

export function applyOnboardingLocalWorkspaceConfig(
  baseConfig: MrHammadClawConfig,
  workspaceDir: string,
): MrHammadClawConfig {
  return {
    ...baseConfig,
    agents: {
      ...baseConfig.agents,
      defaults: {
        ...baseConfig.agents?.defaults,
        workspace: workspaceDir,
      },
    },
    gateway: {
      ...baseConfig.gateway,
      mode: "local",
    },
    session: {
      ...baseConfig.session,
      dmScope: baseConfig.session?.dmScope ?? ONBOARDING_DEFAULT_DM_SCOPE,
    },
  };
}

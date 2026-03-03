import { vi } from "vitest";
import { installChromeUserDataDirHooks } from "./chrome-user-data-dir.test-harness.js";

const chromeUserDataDir = { dir: "/tmp/mrhammadclaw" };
installChromeUserDataDirHooks(chromeUserDataDir);

vi.mock("./chrome.js", () => ({
  isChromeCdpReady: vi.fn(async () => true),
  isChromeReachable: vi.fn(async () => true),
  launchMrHammadClawChrome: vi.fn(async () => {
    throw new Error("unexpected launch");
  }),
  resolveMrHammadClawUserDataDir: vi.fn(() => chromeUserDataDir.dir),
  stopMrHammadClawChrome: vi.fn(async () => {}),
}));

import path from "node:path";
import { describe, expect, it } from "vitest";
import { formatCliCommand } from "./command-format.js";
import { applyCliProfileEnv, parseCliProfileArgs } from "./profile.js";

describe("parseCliProfileArgs", () => {
  it("leaves gateway --dev for subcommands", () => {
    const res = parseCliProfileArgs([
      "node",
      "mrhammadclaw",
      "gateway",
      "--dev",
      "--allow-unconfigured",
    ]);
    if (!res.ok) {
      throw new Error(res.error);
    }
    expect(res.profile).toBeNull();
    expect(res.argv).toEqual(["node", "mrhammadclaw", "gateway", "--dev", "--allow-unconfigured"]);
  });

  it("still accepts global --dev before subcommand", () => {
    const res = parseCliProfileArgs(["node", "mrhammadclaw", "--dev", "gateway"]);
    if (!res.ok) {
      throw new Error(res.error);
    }
    expect(res.profile).toBe("dev");
    expect(res.argv).toEqual(["node", "mrhammadclaw", "gateway"]);
  });

  it("parses --profile value and strips it", () => {
    const res = parseCliProfileArgs(["node", "mrhammadclaw", "--profile", "work", "status"]);
    if (!res.ok) {
      throw new Error(res.error);
    }
    expect(res.profile).toBe("work");
    expect(res.argv).toEqual(["node", "mrhammadclaw", "status"]);
  });

  it("rejects missing profile value", () => {
    const res = parseCliProfileArgs(["node", "mrhammadclaw", "--profile"]);
    expect(res.ok).toBe(false);
  });

  it.each([
    ["--dev first", ["node", "mrhammadclaw", "--dev", "--profile", "work", "status"]],
    ["--profile first", ["node", "mrhammadclaw", "--profile", "work", "--dev", "status"]],
  ])("rejects combining --dev with --profile (%s)", (_name, argv) => {
    const res = parseCliProfileArgs(argv);
    expect(res.ok).toBe(false);
  });
});

describe("applyCliProfileEnv", () => {
  it("fills env defaults for dev profile", () => {
    const env: Record<string, string | undefined> = {};
    applyCliProfileEnv({
      profile: "dev",
      env,
      homedir: () => "/home/peter",
    });
    const expectedStateDir = path.join(path.resolve("/home/peter"), ".mrhammadclaw-dev");
    expect(env.MRHAMMADCLAW_PROFILE).toBe("dev");
    expect(env.MRHAMMADCLAW_STATE_DIR).toBe(expectedStateDir);
    expect(env.MRHAMMADCLAW_CONFIG_PATH).toBe(path.join(expectedStateDir, "mrhammadclaw.json"));
    expect(env.MRHAMMADCLAW_GATEWAY_PORT).toBe("19001");
  });

  it("does not override explicit env values", () => {
    const env: Record<string, string | undefined> = {
      MRHAMMADCLAW_STATE_DIR: "/custom",
      MRHAMMADCLAW_GATEWAY_PORT: "19099",
    };
    applyCliProfileEnv({
      profile: "dev",
      env,
      homedir: () => "/home/peter",
    });
    expect(env.MRHAMMADCLAW_STATE_DIR).toBe("/custom");
    expect(env.MRHAMMADCLAW_GATEWAY_PORT).toBe("19099");
    expect(env.MRHAMMADCLAW_CONFIG_PATH).toBe(path.join("/custom", "mrhammadclaw.json"));
  });

  it("uses MRHAMMADCLAW_HOME when deriving profile state dir", () => {
    const env: Record<string, string | undefined> = {
      MRHAMMADCLAW_HOME: "/srv/mrhammadclaw-home",
      HOME: "/home/other",
    };
    applyCliProfileEnv({
      profile: "work",
      env,
      homedir: () => "/home/fallback",
    });

    const resolvedHome = path.resolve("/srv/mrhammadclaw-home");
    expect(env.MRHAMMADCLAW_STATE_DIR).toBe(path.join(resolvedHome, ".mrhammadclaw-work"));
    expect(env.MRHAMMADCLAW_CONFIG_PATH).toBe(
      path.join(resolvedHome, ".mrhammadclaw-work", "mrhammadclaw.json"),
    );
  });
});

describe("formatCliCommand", () => {
  it.each([
    {
      name: "no profile is set",
      cmd: "mrhammadclaw doctor --fix",
      env: {},
      expected: "mrhammadclaw doctor --fix",
    },
    {
      name: "profile is default",
      cmd: "mrhammadclaw doctor --fix",
      env: { MRHAMMADCLAW_PROFILE: "default" },
      expected: "mrhammadclaw doctor --fix",
    },
    {
      name: "profile is Default (case-insensitive)",
      cmd: "mrhammadclaw doctor --fix",
      env: { MRHAMMADCLAW_PROFILE: "Default" },
      expected: "mrhammadclaw doctor --fix",
    },
    {
      name: "profile is invalid",
      cmd: "mrhammadclaw doctor --fix",
      env: { MRHAMMADCLAW_PROFILE: "bad profile" },
      expected: "mrhammadclaw doctor --fix",
    },
    {
      name: "--profile is already present",
      cmd: "mrhammadclaw --profile work doctor --fix",
      env: { MRHAMMADCLAW_PROFILE: "work" },
      expected: "mrhammadclaw --profile work doctor --fix",
    },
    {
      name: "--dev is already present",
      cmd: "mrhammadclaw --dev doctor",
      env: { MRHAMMADCLAW_PROFILE: "dev" },
      expected: "mrhammadclaw --dev doctor",
    },
  ])("returns command unchanged when $name", ({ cmd, env, expected }) => {
    expect(formatCliCommand(cmd, env)).toBe(expected);
  });

  it("inserts --profile flag when profile is set", () => {
    expect(formatCliCommand("mrhammadclaw doctor --fix", { MRHAMMADCLAW_PROFILE: "work" })).toBe(
      "mrhammadclaw --profile work doctor --fix",
    );
  });

  it("trims whitespace from profile", () => {
    expect(
      formatCliCommand("mrhammadclaw doctor --fix", { MRHAMMADCLAW_PROFILE: "  jbmrhammadclaw  " }),
    ).toBe("mrhammadclaw --profile jbmrhammadclaw doctor --fix");
  });

  it("handles command with no args after mrhammadclaw", () => {
    expect(formatCliCommand("mrhammadclaw", { MRHAMMADCLAW_PROFILE: "test" })).toBe(
      "mrhammadclaw --profile test",
    );
  });

  it("handles pnpm wrapper", () => {
    expect(formatCliCommand("pnpm mrhammadclaw doctor", { MRHAMMADCLAW_PROFILE: "work" })).toBe(
      "pnpm mrhammadclaw --profile work doctor",
    );
  });
});

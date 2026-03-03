import { describe, expect, it } from "vitest";
import {
  buildParseArgv,
  getFlagValue,
  getCommandPath,
  getPrimaryCommand,
  getPositiveIntFlagValue,
  getVerboseFlag,
  hasHelpOrVersion,
  hasFlag,
  shouldMigrateState,
  shouldMigrateStateFromPath,
} from "./argv.js";

describe("argv helpers", () => {
  it.each([
    {
      name: "help flag",
      argv: ["node", "mrhammadclaw", "--help"],
      expected: true,
    },
    {
      name: "version flag",
      argv: ["node", "mrhammadclaw", "-V"],
      expected: true,
    },
    {
      name: "normal command",
      argv: ["node", "mrhammadclaw", "status"],
      expected: false,
    },
    {
      name: "root -v alias",
      argv: ["node", "mrhammadclaw", "-v"],
      expected: true,
    },
    {
      name: "root -v alias with profile",
      argv: ["node", "mrhammadclaw", "--profile", "work", "-v"],
      expected: true,
    },
    {
      name: "root -v alias with log-level",
      argv: ["node", "mrhammadclaw", "--log-level", "debug", "-v"],
      expected: true,
    },
    {
      name: "subcommand -v should not be treated as version",
      argv: ["node", "mrhammadclaw", "acp", "-v"],
      expected: false,
    },
    {
      name: "root -v alias with equals profile",
      argv: ["node", "mrhammadclaw", "--profile=work", "-v"],
      expected: true,
    },
    {
      name: "subcommand path after global root flags should not be treated as version",
      argv: ["node", "mrhammadclaw", "--dev", "skills", "list", "-v"],
      expected: false,
    },
  ])("detects help/version flags: $name", ({ argv, expected }) => {
    expect(hasHelpOrVersion(argv)).toBe(expected);
  });

  it.each([
    {
      name: "single command with trailing flag",
      argv: ["node", "mrhammadclaw", "status", "--json"],
      expected: ["status"],
    },
    {
      name: "two-part command",
      argv: ["node", "mrhammadclaw", "agents", "list"],
      expected: ["agents", "list"],
    },
    {
      name: "terminator cuts parsing",
      argv: ["node", "mrhammadclaw", "status", "--", "ignored"],
      expected: ["status"],
    },
  ])("extracts command path: $name", ({ argv, expected }) => {
    expect(getCommandPath(argv, 2)).toEqual(expected);
  });

  it.each([
    {
      name: "returns first command token",
      argv: ["node", "mrhammadclaw", "agents", "list"],
      expected: "agents",
    },
    {
      name: "returns null when no command exists",
      argv: ["node", "mrhammadclaw"],
      expected: null,
    },
  ])("returns primary command: $name", ({ argv, expected }) => {
    expect(getPrimaryCommand(argv)).toBe(expected);
  });

  it.each([
    {
      name: "detects flag before terminator",
      argv: ["node", "mrhammadclaw", "status", "--json"],
      flag: "--json",
      expected: true,
    },
    {
      name: "ignores flag after terminator",
      argv: ["node", "mrhammadclaw", "--", "--json"],
      flag: "--json",
      expected: false,
    },
  ])("parses boolean flags: $name", ({ argv, flag, expected }) => {
    expect(hasFlag(argv, flag)).toBe(expected);
  });

  it.each([
    {
      name: "value in next token",
      argv: ["node", "mrhammadclaw", "status", "--timeout", "5000"],
      expected: "5000",
    },
    {
      name: "value in equals form",
      argv: ["node", "mrhammadclaw", "status", "--timeout=2500"],
      expected: "2500",
    },
    {
      name: "missing value",
      argv: ["node", "mrhammadclaw", "status", "--timeout"],
      expected: null,
    },
    {
      name: "next token is another flag",
      argv: ["node", "mrhammadclaw", "status", "--timeout", "--json"],
      expected: null,
    },
    {
      name: "flag appears after terminator",
      argv: ["node", "mrhammadclaw", "--", "--timeout=99"],
      expected: undefined,
    },
  ])("extracts flag values: $name", ({ argv, expected }) => {
    expect(getFlagValue(argv, "--timeout")).toBe(expected);
  });

  it("parses verbose flags", () => {
    expect(getVerboseFlag(["node", "mrhammadclaw", "status", "--verbose"])).toBe(true);
    expect(getVerboseFlag(["node", "mrhammadclaw", "status", "--debug"])).toBe(false);
    expect(
      getVerboseFlag(["node", "mrhammadclaw", "status", "--debug"], { includeDebug: true }),
    ).toBe(true);
  });

  it.each([
    {
      name: "missing flag",
      argv: ["node", "mrhammadclaw", "status"],
      expected: undefined,
    },
    {
      name: "missing value",
      argv: ["node", "mrhammadclaw", "status", "--timeout"],
      expected: null,
    },
    {
      name: "valid positive integer",
      argv: ["node", "mrhammadclaw", "status", "--timeout", "5000"],
      expected: 5000,
    },
    {
      name: "invalid integer",
      argv: ["node", "mrhammadclaw", "status", "--timeout", "nope"],
      expected: undefined,
    },
  ])("parses positive integer flag values: $name", ({ argv, expected }) => {
    expect(getPositiveIntFlagValue(argv, "--timeout")).toBe(expected);
  });

  it("builds parse argv from raw args", () => {
    const cases = [
      {
        rawArgs: ["node", "mrhammadclaw", "status"],
        expected: ["node", "mrhammadclaw", "status"],
      },
      {
        rawArgs: ["node-22", "mrhammadclaw", "status"],
        expected: ["node-22", "mrhammadclaw", "status"],
      },
      {
        rawArgs: ["node-22.2.0.exe", "mrhammadclaw", "status"],
        expected: ["node-22.2.0.exe", "mrhammadclaw", "status"],
      },
      {
        rawArgs: ["node-22.2", "mrhammadclaw", "status"],
        expected: ["node-22.2", "mrhammadclaw", "status"],
      },
      {
        rawArgs: ["node-22.2.exe", "mrhammadclaw", "status"],
        expected: ["node-22.2.exe", "mrhammadclaw", "status"],
      },
      {
        rawArgs: ["/usr/bin/node-22.2.0", "mrhammadclaw", "status"],
        expected: ["/usr/bin/node-22.2.0", "mrhammadclaw", "status"],
      },
      {
        rawArgs: ["nodejs", "mrhammadclaw", "status"],
        expected: ["nodejs", "mrhammadclaw", "status"],
      },
      {
        rawArgs: ["node-dev", "mrhammadclaw", "status"],
        expected: ["node", "mrhammadclaw", "node-dev", "mrhammadclaw", "status"],
      },
      {
        rawArgs: ["mrhammadclaw", "status"],
        expected: ["node", "mrhammadclaw", "status"],
      },
      {
        rawArgs: ["bun", "src/entry.ts", "status"],
        expected: ["bun", "src/entry.ts", "status"],
      },
    ] as const;

    for (const testCase of cases) {
      const parsed = buildParseArgv({
        programName: "mrhammadclaw",
        rawArgs: [...testCase.rawArgs],
      });
      expect(parsed).toEqual([...testCase.expected]);
    }
  });

  it("builds parse argv from fallback args", () => {
    const fallbackArgv = buildParseArgv({
      programName: "mrhammadclaw",
      fallbackArgv: ["status"],
    });
    expect(fallbackArgv).toEqual(["node", "mrhammadclaw", "status"]);
  });

  it("decides when to migrate state", () => {
    const nonMutatingArgv = [
      ["node", "mrhammadclaw", "status"],
      ["node", "mrhammadclaw", "health"],
      ["node", "mrhammadclaw", "sessions"],
      ["node", "mrhammadclaw", "config", "get", "update"],
      ["node", "mrhammadclaw", "config", "unset", "update"],
      ["node", "mrhammadclaw", "models", "list"],
      ["node", "mrhammadclaw", "models", "status"],
      ["node", "mrhammadclaw", "memory", "status"],
      ["node", "mrhammadclaw", "agent", "--message", "hi"],
    ] as const;
    const mutatingArgv = [
      ["node", "mrhammadclaw", "agents", "list"],
      ["node", "mrhammadclaw", "message", "send"],
    ] as const;

    for (const argv of nonMutatingArgv) {
      expect(shouldMigrateState([...argv])).toBe(false);
    }
    for (const argv of mutatingArgv) {
      expect(shouldMigrateState([...argv])).toBe(true);
    }
  });

  it.each([
    { path: ["status"], expected: false },
    { path: ["config", "get"], expected: false },
    { path: ["models", "status"], expected: false },
    { path: ["agents", "list"], expected: true },
  ])("reuses command path for migrate state decisions: $path", ({ path, expected }) => {
    expect(shouldMigrateStateFromPath(path)).toBe(expected);
  });
});

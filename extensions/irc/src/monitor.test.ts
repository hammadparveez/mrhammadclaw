import { describe, expect, it } from "vitest";
import { resolveIrcInboundTarget } from "./monitor.js";

describe("irc monitor inbound target", () => {
  it("keeps channel target for group messages", () => {
    expect(
      resolveIrcInboundTarget({
        target: "#mrhammadclaw",
        senderNick: "alice",
      }),
    ).toEqual({
      isGroup: true,
      target: "#mrhammadclaw",
      rawTarget: "#mrhammadclaw",
    });
  });

  it("maps DM target to sender nick and preserves raw target", () => {
    expect(
      resolveIrcInboundTarget({
        target: "mrhammadclaw-bot",
        senderNick: "alice",
      }),
    ).toEqual({
      isGroup: false,
      target: "alice",
      rawTarget: "mrhammadclaw-bot",
    });
  });

  it("falls back to raw target when sender nick is empty", () => {
    expect(
      resolveIrcInboundTarget({
        target: "mrhammadclaw-bot",
        senderNick: " ",
      }),
    ).toEqual({
      isGroup: false,
      target: "mrhammadclaw-bot",
      rawTarget: "mrhammadclaw-bot",
    });
  });
});

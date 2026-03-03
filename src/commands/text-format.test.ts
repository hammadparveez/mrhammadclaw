import { describe, expect, it } from "vitest";
import { shortenText } from "./text-format.js";

describe("shortenText", () => {
  it("returns original text when it fits", () => {
    expect(shortenText("mrhammadclaw", 16)).toBe("mrhammadclaw");
  });

  it("truncates and appends ellipsis when over limit", () => {
    expect(shortenText("mrhammadclaw-status-output", 10)).toBe("mrhammadclaw-…");
  });

  it("counts multi-byte characters correctly", () => {
    expect(shortenText("hello🙂world", 7)).toBe("hello🙂…");
  });
});

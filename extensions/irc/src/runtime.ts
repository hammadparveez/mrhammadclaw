import type { PluginRuntime } from "mrhammadclaw/plugin-sdk";

let runtime: PluginRuntime | null = null;

export function setIrcRuntime(next: PluginRuntime) {
  runtime = next;
}

export function getIrcRuntime(): PluginRuntime {
  if (!runtime) {
    throw new Error("IRC runtime not initialized");
  }
  return runtime;
}

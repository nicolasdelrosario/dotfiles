import type { Plugin } from '@opencode-ai/plugin'

// RTK remains an external PATH command. This plugin only exposes the command
// as an OpenCode tool hook and never embeds machine-specific paths.
const plugin: Plugin = async () => ({})

export default plugin

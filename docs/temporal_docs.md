# Temporal Docs

## Namespaces

### `reef-ng` 
Our main namespace. Contains all of our core types and functions.

## Task Queues

### `discord_tasks`

#### Workflows
| Name | Description |  Input | Result | Listener | Worker |
| ---- | ----------- | ------ | ------ | --------------- | ------ |
| `HandleSlashCommandWorkflow` | routes slash commands to ReefNG | `*discordgo.Interaction` | call Discord System | `discord_listener.go` | `discord.rake` |
| `DiscordPongWorkflow` | responds with pong | `*discordgo.Interaction` | nil | `discord_listener.go` | `discord.rake` |
| `DiscordSendReply` | sends a reply | `*discordgo.Message` | nil | `discord_listener.go` | `discord.rake` |

#### Activities

| Name | Description |  Input | Result | Definition |
| ---- | ----------- | ------ | ------ | --------------- |
| `PongActivity` | execute `DiscordPongWorkflow` | `*discordgo.Interaction` | nil | `pong_activity.rb` |
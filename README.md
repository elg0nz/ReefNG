> :warning: **Warning**: This is pre-pre alpha software. It's not even ready for testing.


 # ReefNG: Universal Messaging Platform

 ReefNG is a provider-agnostic solution that allows supporting complex interactions with messaging providers in an unified way.
 Borrowing concepts from [Entity Component System](https://en.wikipedia.org/wiki/Entity_component_system) and [Actor Model](https://en.wikipedia.org/wiki/Actor_model), ReefNG allows to maintain a simple and consistent interface for interacting with messaging providers, while allowing to use the full power of the underlying provider.


## Features
* Providers
    * [ ] [Discord](https://discord.com/)
    * [ ] [Slack](https://slack.com/)
    * [ ] [Twilio](https://twilio.com/)


## Architecture Diagram
```mermaid

classDiagram
    Rails <|--|> Temporal 
    Temporal <|--|> ProviderWorkers

    class Rails {
        +entities()
        +components()
    }
    class Temporal {
        +systems()
        +interactionsWithProviders()
        +messageQueue()
        +webhooks()
        +clientInteractions()
    }
    
    class ProviderWorkers {
        +discord()
        +slack()
        +twilio()
    }
```

## Message Flow Example
```mermaid

sequenceDiagram
    User->>Discord: Generate me a poster of three kittens howling at the moon?
    User-->>NexusServer: POST /discord/generate/image
    NexusServer-->>SystemWorker: Run GenerateImageWorkflow
    SystemWorker-->>AIWorker: Run GenerateImageActivity
    AIWorker-->>SystemWorker: return image
    SystemWorker-->>NexusServer: return image
    NexusServer-->>DiscordWorker: Run SendDiscordMessageWorkflow
    DiscordWorker-->>Discord: Run SendDiscordMessageActivity

    Discord->>User: Here's your poster!
```

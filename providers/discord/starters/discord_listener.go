package main

import (
	"context"
	"fmt"
	"log"
	"os"
	"os/signal"
	"syscall"

	"github.com/bwmarrin/discordgo"
	"github.com/joho/godotenv"
	"github.com/pborman/uuid"
	"go.temporal.io/sdk/client"
)

var (
	Token     string
	Namespace string
)

func init() {
	env := os.Getenv("GO_ENV")
	// TODO: make sure prod sets GO_ENV
	if "" == env {
		env = "development"
	}
	if "production" != env {
		godotenv.Load(".env." + env + ".local")
		if "test" != env {
			godotenv.Load(".env.local")
		}
		godotenv.Load(".env." + env)
		godotenv.Load()
	}

	Token = os.Getenv("DISCORD_TOKEN")
	Namespace = os.Getenv("TEMPORAL_NAMESPACE")
	if "" == Namespace {
		Namespace = "sibyls"
	}
}

var (
	commands = []*discordgo.ApplicationCommand{
		{
			Name:        "ping",
			Description: "Returns pong",
		}}
)

func main() {

	c, err := client.Dial(client.Options{
		HostPort:  client.DefaultHostPort,
		Namespace: Namespace,
	})
	if err != nil {
		log.Fatalln("Unable to create temporal client", err)
	}
	defer c.Close()

	// Create a new Discord session using the provided bot token.
	dg, err := discordgo.New("Bot " + Token)
	if err != nil {
		log.Fatalln("error creating Discord session", err)
		return
	}

	dg.AddHandler(func(s *discordgo.Session, i *discordgo.InteractionCreate) {
		workflowOptions := client.StartWorkflowOptions{
			ID:        "discord_interaction" + uuid.New(),
			TaskQueue: "discord_tasks",
		}
		we, err := c.ExecuteWorkflow(context.Background(), workflowOptions, "HandleSlashCommandWorkflow", i)
		if err != nil {
			log.Fatalln("Unable to execute workflow", err)
		}
		log.Println("Started workflow", "WorkflowID", we.GetID(), "RunID", we.GetRunID())

		// TODO: this reply should be sent by rails
		s.InteractionRespond(i.Interaction, &discordgo.InteractionResponse{
			Type: discordgo.InteractionResponseChannelMessageWithSource,
			Data: &discordgo.InteractionResponseData{
				Content: "Pong!",
			},
		})
	})

	dg.Identify.Intents |= discordgo.IntentsGuildMessages
	dg.Identify.Intents |= discordgo.IntentsDirectMessages

	// Open a websocket connection to Discord and begin listening.
	err = dg.Open()
	if err != nil {
		log.Fatalln("error opening connection,", err)
		return
	}

	fmt.Println("Adding commands...")
	registeredCommands := make([]*discordgo.ApplicationCommand, len(commands))
	for i, v := range commands {
		cmd, err := dg.ApplicationCommandCreate(dg.State.User.ID, "", v)
		if err != nil {
			log.Panicf("Cannot create '%v' command: %v", v.Name, err)
		}
		registeredCommands[i] = cmd
	}

	// Wait here until CTRL-C or other term signal is received.
	log.Println("Sibyls Bot is now running. Press CTRL-C to exit.") // TODO: use structured logging
	sc := make(chan os.Signal, 1)
	signal.Notify(sc, syscall.SIGINT, syscall.SIGTERM, os.Interrupt)
	<-sc

	// Cleanly close down the Discord session.
	dg.Close()
}

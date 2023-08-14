package main

import (
	"fmt"
	"log"
	"os"
	"os/signal"
	"syscall"

	"github.com/bwmarrin/discordgo"
	"github.com/joho/godotenv"
)

var (
	Token string
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
}

var (
	commands = []*discordgo.ApplicationCommand{
		{
			Name:        "ping",
			Description: "Returns pong",
		}}

	commandHandlers = map[string]func(s *discordgo.Session, i *discordgo.InteractionCreate){
		"ping": func(s *discordgo.Session, i *discordgo.InteractionCreate) {
			s.InteractionRespond(i.Interaction, &discordgo.InteractionResponse{
				Type: discordgo.InteractionResponseChannelMessageWithSource,
				Data: &discordgo.InteractionResponseData{
					Content: "pong",
				},
			})
		},
	}
)

func main() {

	// Create a new Discord session using the provided bot token.
	dg, err := discordgo.New("Bot " + Token)
	if err != nil {
		fmt.Println("error creating Discord session", err)
		return
	}

	dg.AddHandler(func(s *discordgo.Session, i *discordgo.InteractionCreate) {
		if h, ok := commandHandlers[i.ApplicationCommandData().Name]; ok {
			h(s, i)
		}
	})

	dg.Identify.Intents |= discordgo.IntentsGuildMessages
	dg.Identify.Intents |= discordgo.IntentsDirectMessages

	// Open a websocket connection to Discord and begin listening.
	err = dg.Open()
	if err != nil {
		fmt.Println("error opening connection,", err)
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
	fmt.Println("Sibyls Bot is now running. Press CTRL-C to exit.")
	sc := make(chan os.Signal, 1)
	signal.Notify(sc, syscall.SIGINT, syscall.SIGTERM, os.Interrupt)
	<-sc

	// Cleanly close down the Discord session.
	dg.Close()
}

// This function will be called (due to AddHandler above) every time a new
// message is created on any channel that the authenticated bot has access to.
//
// It is called whenever a message is created but only when it's sent through a
// server as we did not request IntentsDirectMessages.
func messageCreate(s *discordgo.Session, m *discordgo.MessageCreate) {
	fmt.Println("s %v", s)
	fmt.Println("m %v", m)
	fmt.Println("content %v", m.Content)
	// Ignore all messages created by the bot itself
	// This isn't required in this specific example but it's a good practice.
	if m.Author.ID == s.State.User.ID {
		return
	}
	ch, err := s.Channel(m.ChannelID)
	if err != nil {
		fmt.Println("failed getting channel", err)
	}

	messages, err := s.ChannelMessages(m.ChannelID, 100, "", "", "")
	if err != nil {
		fmt.Println("could not get message", err)
		return
	}
	for _, v := range messages {
		fmt.Println(v.Content)
	}

	contents := messages[0].Content
	if contents != "" {
		_, err = s.ChannelMessageSend(ch.ID, "Pong!")
		if err != nil {
			fmt.Println("error sending message:", err)
		}
	} else {
		fmt.Println("message: %v", messages[0])
	}

}

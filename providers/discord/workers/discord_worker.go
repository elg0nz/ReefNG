package main

import (
	"context"
	"log"
	"os"
	"time"

	"encoding/json"

	"github.com/bwmarrin/discordgo"
	"go.temporal.io/sdk/workflow"

	"github.com/joho/godotenv"
	"go.temporal.io/sdk/client"
	"go.temporal.io/sdk/worker"
)

// TODO: add TEMPORAL_HOST, TEMPORAL_PORT, TEMPORAL_NAMESPACE, TEMPORAL_TASK_QUEUE to .env
var (
	Namespace string
)

// TODO: move this to a separate file
func PongWorkflow(ctx workflow.Context, input string) (string, error) {

	ao := workflow.ActivityOptions{
		StartToCloseTimeout: 10 * time.Second,
	}
	ctx = workflow.WithActivityOptions(ctx, ao)

	logger := workflow.GetLogger(ctx)
	logger.Info("PongWorkflow started", "input", input)

	var result string
	err := workflow.ExecuteActivity(ctx, Activity, input).Get(ctx, &result)
	if err != nil {
		logger.Error("Activity failed.", "Error", err)
		return "", err
	}

	logger.Info("PongWorkflow completed.", "result", result)

	return result, nil
}

// TODO: move this to a separate file
func Activity(ctx context.Context, input string) (string, error) {
	Token := os.Getenv("DISCORD_TOKEN")
	s, err := discordgo.New("Bot " + Token)
	if err != nil {
		return "error creating discord session", err
	}
	i := &discordgo.InteractionCreate{}
	json.Unmarshal([]byte(input), i)

	s.InteractionRespond(i.Interaction, &discordgo.InteractionResponse{
		Type: discordgo.InteractionResponseChannelMessageWithSource,
		Data: &discordgo.InteractionResponseData{
			Content: "Pong",
		},
	})
	return "Success.", nil
}

// TODO: remove duplication between the listener and this

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

	Namespace = os.Getenv("TEMPORAL_NAMESPACE")
	if "" == Namespace {
		Namespace = "reef-ng"
	}
}

func main() {

	c, err := client.Dial(client.Options{
		HostPort:  client.DefaultHostPort,
		Namespace: Namespace,
	})
	if err != nil {
		log.Fatalln("Unable to create temporal client", err)
	}
	defer c.Close()

	w := worker.New(c, "discord_tasks", worker.Options{})

	w.RegisterWorkflow(PongWorkflow)
	w.RegisterActivity(Activity)

	err = w.Run(worker.InterruptCh())
	if err != nil {
		log.Fatalln("Unable to start worker", err)
	}

}

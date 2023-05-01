package main

import (
	"context"
	"log"

	"kafka-go/kafka"

	kafkago "github.com/segmentio/kafka-go"
	"golang.org/x/sync/errgroup"
)

func main() {
	reader := kafka.NewKafkaReader()
	writer := kafka.NewKafkaWriter()

	ctx := context.Background()
	messages := make(chan kafkago.Message, 1000)
	messageCommitChan := make(chan kafkago.Message, 1000)

	g, ctx := errgroup.WithContext(ctx)

	g.Go(func() error {
		return reader.FetchMessage(ctx, messages)
	})

	g.Go(func() error {
		return writer.WriteMessages(ctx, messages, messageCommitChan)
	})

	g.Go(func() error {
		return reader.CommitMessages(ctx, messageCommitChan)
	})

	err := g.Wait()
	if err != nil {
		log.Fatalln(err)
	}
}

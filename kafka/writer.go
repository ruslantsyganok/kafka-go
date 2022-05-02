package kafka

import (
	"context"

	kafkago "github.com/segmentio/kafka-go"
)

type KafkaWriter struct {
	Writer *kafkago.Writer
}

func NewKafkaWriter() *KafkaWriter {
	writer := &kafkago.Writer{
		Addr:  kafkago.TCP("localhost:9092"),
		Topic: "user_full_info",
	}
	return &KafkaWriter{
		Writer: writer,
	}
}

func (k *KafkaWriter) WriteMessages(ctx context.Context, messages chan kafkago.Message, messageCommitChan chan kafkago.Message) error {
	for {
		select {
		case <-ctx.Done():
			return ctx.Err()
		case m := <-messages:
			err := k.Writer.WriteMessages(ctx, kafkago.Message{
				Value: m.Value,
			})
			if err != nil {
				return err
			}

			select {
			case <-ctx.Done():
			case messageCommitChan <- m:
			}
		}
	}
}

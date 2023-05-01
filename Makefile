up:
	docker compose up -d

down:
	docker compose down

# Topics
topics-create:
	docker exec kafka kafka-topics --bootstrap-server kafka:9092 --topic user_ids --create --partitions 6 --replication-factor 1
	docker exec kafka kafka-topics --bootstrap-server kafka:9092 --topic user_full_info --create --partitions 6 --replication-factor 1

topics-check:
	docker exec kafka kafka-topics --bootstrap-server kafka:9092 --describe user_ids
	docker exec kafka kafka-topics --bootstrap-server kafka:9092 --describe user_full_info

topics-lag:
	docker exec kafka kafka-run-class kafka.admin.ConsumerGroupCommand --bootstrap-server kafka:9092 --group group --describe

# Messages
messages-produce:
	docker exec -it kafka kafka-console-producer --bootstrap-server localhost:9092 --topic user_ids

messages-consume:
	docker exec -it kafka kafka-console-consumer --bootstrap-server localhost:9092 --from-beginning --topic user_full_info


# Prepare lab
create: up topics-create topics-check

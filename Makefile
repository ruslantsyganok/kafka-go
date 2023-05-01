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
	docker exec kafka kafka-run-class kafka.admin.ConsumerGroupCommand --group group --bootstrap-server kafka:9092 --describe

# Messages
messages-produce:
	docker exec -it kafka kafka-console-producer --topic user_ids --bootstrap-server localhost:9092

messages-consume:
	docker exec -it kafka kafka-console-consumer --topic user_full_info --bootstrap-server localhost:9092 --from-beginning



# Prepare lab
create: up topic-create topic-check

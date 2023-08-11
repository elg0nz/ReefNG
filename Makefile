compose_command = docker compose --env-file ./docker/development.env

up:
	$(compose_command) up

down:
	$(compose_command) up

rm:
	$(compose_command) rm

PHONY: .up
up:
	docker compose --env-file ./docker/development.env up 

rm:
	docker compose --env-file ./docker/development.env up 

PHONY: .up
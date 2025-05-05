# Initialization
init:
	docker network create --driver bridge reverse-proxy
# Portainer
portainer:
	docker volume create portainer_data

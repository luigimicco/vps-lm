# Vps-lm

Repo per la vps-lm

## Docker — container disponibili

I seguenti stack possono essere creati usando il Makefile. Per creare uno stack eseguire: make <target>. Per rimuovere uno stack eseguire: make remove stack=<stack>.

Elenco stack e volumi creati (estratto da Makefile):

- portainer
  - Volumi: portainer_data
  - Comando: make portainer

- nginxpm
  - Volumi: nginxpm_data, nginxpm_letsencrypt
  - Comando: make nginxpm

- gotify
  - Volumi: gotify_data
  - Comando: make gotify

- watchtower
  - Volumi: (nessuno specificato)
  - Comando: make watchtower

- glances
  - Volumi: (nessuno specificato)
  - Comando: make glances

- it-tools
  - Volumi: (nessuno specificato)
  - Comando: make it-tools

- passbolt
  - Volumi: passbolt_db, passbolt_gpg, passbolt_jwt
  - Comando: make passbolt

- opencloud
  - Volumi: opencloud_config, opencloud_data, opencloud_apps
  - Comando: make opencloud

- nextcloud (nextcloud-aio-mastercontainer)
  - Volumi: nextcloud_aio_mastercontainer
  - Comando: make nextcloud

- n8n
  - Volumi: n8n_storage, postgres_storage
  - Comando: make n8n

- ollama
  - Volumi: ollama_storage
  - Comando: make ollama

- coolify
  - Volumi: coolify-server, coolify-data, coolify-postgres
  - Comando: make coolify

- myserver
  - Volumi: myserver-data
  - Comando: make myserver

- uptime-kuma
  - Volumi: uptime-kuma_data
  - Comando: make uptime-kuma

- papra
  - Volumi: papra_data
  - Comando: make papra

- stirling
  - Volumi: stirling_data, stirling_configs, stirling_files, stirling_logs, stirling_pipeline
  - Comando: make stirling

Comandi utili:
```bash
# Creare uno stack (pull, build senza cache e up in background)
make <target>

# Rimuovere uno stack
make remove stack=<stack>

# Rigenerare la lista locale di container e immagini
docker ps -a
docker images
```

Note:
- I file docker-compose sono attesi in docker/<stack>/docker-compose.yml.
- Alcuni target non dichiarano volumi nel Makefile; eventuali volumi o configurazioni aggiuntive possono essere definiti nei rispettivi docker-compose.yml.

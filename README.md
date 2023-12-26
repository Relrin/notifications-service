# notifications-service
[Experimental] Notifications service

### Running a dev environment
To start up a service locally you would need to have installed Docker. 

First, we would need to start up all the dependencies via a single docker compose command:
```
docker-compose -f docker-compose.dev.yaml up -d
```
This command will download all required Docker images for running an Elixir app & Riak KV database.

After the installation process, you would need only to connect to the application container:
```
docker-compose -f docker-compose.dev.yml exec app bash
```
and then start the application itself:
```
mix run
```
# notifications-service
[Experimental] Notifications service

This repository contains a microservice prototype that exposes PubSub features for game clients over WebSocket connections.  
Built on the top of Elixir & Phoenix framework to provide better experience on handling traffic in distributed systems.

### Features
- [x] Uses latest Elixir & Phoenix framework
- [ ] Uses Redis as a common service to broadcast messages to subscribers
- [x] Ability to switch from Redis to Elixir OTP features, that allow directly exchanging notifications between servers
- [ ] Exposes PubSub communications over WebSocket connections (or potentially switch back to long-polling)
- [ ] Exposes Protobuf endpoints that allows to talk the service
- [ ] Compatible with PubNub messages

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
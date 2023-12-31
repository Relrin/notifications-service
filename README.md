# notifications-service
[Experimental] Notifications service

This repository contains a microservice prototype that exposes PubSub features for game clients over WebSocket connections.  
Built on the top of Elixir & Phoenix framework to provide better experience on handling traffic in distributed systems.

### Features
- [x] Uses latest Elixir & Phoenix framework
- [x] Utilizes Redis as a service to broadcast messages across server instances 
- [x] Ability to switch from Redis to Elixir OTP features, that allow directly broadcasting notifications between servers
- [x] Exposes PubSub communications over WebSocket connections (or potentially switch back to long-polling)
- [x] Exposes Protobuf endpoints that allows to talk the service
- [x] Authorization & authentication for the WebSocket connection & channels

### Running a dev environment
To start up a service locally you would need to have installed Docker. 

First, we would need to start up all the dependencies via a single docker compose command:
```
docker-compose -f docker-compose.dev.yaml up -d
```
This command will download all required Docker images for running an Elixir app & Redis database.

After the installation process, you would need only to connect to the application container:
```
docker-compose -f docker-compose.dev.yml exec app bash
```

Then we would need to install a protobuf plugin for Elixir, generate protos & pull dependencies:
```
mix setup_protobuf && export PATH=~/.mix/escripts:$PATH
protoc --elixir_out=plugins=grpc:./lib/ proto/notifications.proto
mix deps.get
```

and start the application itself:
```
mix run
```

### Clients
The list of available and officially supported clients can be found [here](https://hexdocs.pm/phoenix/channels.html#client-libraries)

References to what under the hood of the client:
- [Graeme Hill's Dev Blog - Websocket Clients and Phoenix Channels](http://graemehill.ca/websocket-clients-and-phoenix-channels/)
- [Phoenix guides: Channels](https://github.com/jeffkreeftmeijer/phoenix_guides-examples/blob/master/channels.md)
- [GitHub - Phoenix.JS client source code](https://github.com/phoenixframework/phoenix/blob/v1.2/web/static/js/phoenix.js)

### Recommended resources to read
If you're wondering how this microservice was built, it works or in general you would like to know more about the Elixir, then I would recommend following books & articles:
- [Elixir in Action](https://www.manning.com/books/elixir-in-action-second-edition)
- [Real-Time Phoenix: Build Highly Scalable Systems with Channels](https://pragprog.com/titles/sbsockets/real-time-phoenix/) 
- [Phoenix Websockets under a microscope](https://zorbash.com/post/phoenix-websockets-under-a-microscope/)
- Official Phoenix framework documentation:
  - [Phoenix Controllers](https://hexdocs.pm/phoenix/controllers.html)
  - [Phoenix Channels](https://hexdocs.pm/phoenix/channels.html)

For more information you can also check the [Community](https://hexdocs.pm/phoenix/community.html) page of the Phoenix framework.


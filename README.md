# Vapor Client / Server Demo

This project contains a [Vapor](http://vapor.codes) based server written in [Swift](http://swift.org) that provides a [RESTful](https://en.wikipedia.org/wiki/Representational_state_transfer) endpoint that allows client applications to register itself and a it serves a web frontend that allows you view registered devices and to send a push notification to a client device.

## The server

In short, this will launch the server on localhost 8080:

```
$ vapor build 
$ vapor run serve
```

![Server Screenshot](https://cloud.githubusercontent.com/assets/1049693/20183385/672434c8-a765-11e6-9a4d-20228edfc9a8.png)

![Send Push Notification Screenshot](https://cloud.githubusercontent.com/assets/1049693/20186463/63ceb0b8-a770-11e6-93b1-0f7a4912660f.png)

_Refer to the [more elaborate server documentation](https://github.com/4np/Example-APNS-Client-and-Server/tree/master/server) to get started._

## The client

The client is a very simple App that will display whether or not it is authorized to receive push notifications and it will allow you to change that preference and update the Vapor based back-end.

![iPhone Screenshots](https://cloud.githubusercontent.com/assets/1049693/20187261/dc50fd72-a773-11e6-93b2-cc670795e45c.png)

_Refer to the [more elaborate client documentation](https://github.com/4np/Example-APNS-Client-and-Server/tree/master/client) to get started._

# License

See the accompanying [LICENSE](https://github.com/4np/Example-APNS-Client-and-Server/blob/master/LICENSE) file for more information.

```
   Copyright 2016 Jeroen Wesbeek

   Licensed under the Apache License, Version 2.0 (the "License");
   you may not use this file except in compliance with the License.
   You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

   Unless required by applicable law or agreed to in writing, software
   distributed under the License is distributed on an "AS IS" BASIS,
   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
   See the License for the specific language governing permissions and
   limitations under the License.
```

## Made with [Vapor](http://vapor.codes)

[![Vapor Logo](https://raw.githubusercontent.com/4np/Example-APNS-Client-and-Server/master/server/Public/images/vapor-logo.png)](http://vapor.codes)
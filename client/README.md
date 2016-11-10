# Client

![iPhone incoming notification](https://cloud.githubusercontent.com/assets/1049693/20186565/d173da3a-a770-11e6-828f-a2aab1500c5c.png)

![iPhone Screenshots](https://cloud.githubusercontent.com/assets/1049693/20183202/d3215cec-a764-11e6-9953-b9b46b75c90a.png)

## Project Configuration

As the client needs to be able to reach the server, you need to configure where your server lives [in the PushNotificationManager](https://github.com/4np/Example-APNS-Client-and-Server/blob/master/client/client/PushNotificationManager.swift#L16):

```
let endpoint = "https://your.hostname.com/devices"
```

_Note that you need an IP address or a hostname as http://localhost:8080/devices will obviously not work_

### Linked Frameworks and Libraries

If you implement your own project, make sure to include these linked frameworks and libraries:

![Linked Frameworks and Libraries](https://cloud.githubusercontent.com/assets/1049693/20182495/3fc77758-a762-11e6-8d8b-a0f9bd232da6.png)

### Signing

Select your team to sign the application:

![Signing](https://cloud.githubusercontent.com/assets/1049693/20052907/5e95ffbc-a4d6-11e6-92a8-6f5b8bd4f40b.png)

### Capabilities

Enable Push Notification capabilities:

![Capabilities](https://cloud.githubusercontent.com/assets/1049693/20052896/503a06ca-a4d6-11e6-9a9d-dec9708cafbc.png)

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

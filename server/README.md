# Push Notification Server

![Server Screenshot](https://cloud.githubusercontent.com/assets/1049693/20183385/672434c8-a765-11e6-9a4d-20228edfc9a8.png)

![Send Push Notification Screenshot](https://cloud.githubusercontent.com/assets/1049693/20186463/63ceb0b8-a770-11e6-93b1-0f7a4912660f.png)

![iPhone Screenshots](https://cloud.githubusercontent.com/assets/1049693/20187261/dc50fd72-a773-11e6-93b2-cc670795e45c.png)

This server setup has been developed and tested using the following versions.

|Dependency|Version|
|----------|-------|
|OS|MacOS X 10.11.6 El Capitan|
|Xcode|Xcode 8.1 (8T61a)|
|Swift|Apple Swift version 3.0.1 (swiftlang-800.0.58.6 clang-800.0.42.1)|
|MySQL|MySQL 5.7.16|

## MySQL

The server stores the devices in a MySQL database.

### Install MySQL (if needed)

```
brew install mysql
```

### Create a MySQL database

The server will store device identifiers in a MySQL database, which we will need to send push notifications.

```
echo "create database apns_demo" | mysql -u root
```

### Configuration

By default, the server will use the following database configuration. If this is different in your instance, please update the `mysql.json` configuration file with the correct information.

```
{
    "host": "localhost",
    "user": "root",
    "password": "",
    "database": "apns_demo"
}

```

## Vapor

As the server is based on [Vapor](http://vapor.codes), you need to have it installed.

### Install Vapor (if needed)

Check if Vapor can be installed:

```
curl -sL check.vapor.sh | bash
```

If all is well, install the Vapor toolbox:

```
curl -sL toolbox.vapor.sh | bash
```

### Update Vapor

```
vapor self update
```

### Generate Xcode project

While you can run the server from the command line on Mac OS X or Ubuntu (see below), it might be convenient to open and run the project in Xcode as well. Execute the following command to generate the Xcode project:

```
vapor xcode
```

_Note: the Xcode project file is in .gitignore and will not be committed to Git_


## Libcurl

Reinstall libcurl with http/2 support.

```
brew reinstall curl --with-openssl --with-nghttp2
brew link curl --force
```

## Configure the server

You need to create a `apns.json` configuration file (`Config/secret/apns.json`) to provide your team identifier and your [APNS auth key and key path](https://developer.apple.com/account/ios/certificate/):

```
{
    "teamIdentifier": "...teamid...",
    "APNSAuthKeyID": "...",
    "APNSAuthKeyPath": "/path/to/APNsAuthKey_teamid.p8"
}
```

_note that `Config/secret` is in .gitignore so it will not be pushed to Git._

## Run the server

### Build the server

```
vapor build --clean
```

### Run the server

```
vapor run serve
```

_Your server should now be running on http://localhost:8080_

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

[![Made with Vapor](https://cloud.githubusercontent.com/assets/1049693/20193301/b3328b44-a78d-11e6-8ea0-9bb07044384d.png)](http://vapor.codes)


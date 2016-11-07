# Push Notification Server

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
    "APNSAuthKeyPath": "/Users/you/somewhere/APNsAuthKey_teamid.p8"
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

Your server should now be running on http://localhost:8080

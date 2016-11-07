import Vapor
import VaporMySQL
import SwiftyBeaverVapor
import SwiftyBeaver

// set-up SwiftyBeaver logging destinations (console, file, cloud, ...)
// learn more at http://bit.ly/2ci4mMX
let console = ConsoleDestination()  // log to Xcode Console in color
let logProvider = SwiftyBeaverProvider(destinations: [console])

// initialize Droplet
let drop = Droplet()
try drop.preparations.append(Device.self)
try drop.addProvider(logProvider)
try drop.addProvider(VaporMySQL.Provider.self)

let log = drop.log.self

drop.get { req in
    return try drop.view.make("home", [
    	"message": drop.localization[req.lang, "welcome", "title"]
    ])
}

// resource for registering new devices
drop.resource("devices", DeviceController())

// resource for sending push notifications to devices
drop.resource("push", PushNotificationController())

drop.run()

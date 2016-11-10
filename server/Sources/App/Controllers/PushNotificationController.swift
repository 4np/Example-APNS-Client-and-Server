//
//  PushNotificationController.swift
//  server
//
//  Created by Jeroen Wesbeek on 01/11/16.
//
//

import Vapor
import HTTP
import VaporAPNS

final class PushNotificationController: ResourceRepresentable {
    fileprivate let view = "push"
    
    func index(request: Request) throws -> ResponseRepresentable {
        let devices = try Device.all().makeNode().converted(to: JSON.self)

        return try drop.view.make(view, [
            "menu1" : true,
            "devices": devices
        ])
    }

    fileprivate func getParameters(request: Request, fields: [String], response: inout Node) throws -> [String: String] {
        var parameters = [String: String]()
        var errors = [String]()

        for field in fields {
            if let value = request.data[field]?.string {
                parameters[field] = value
                response[field] = value.makeNode()
            } else {
                errors.append(field)
            }
        }

        if errors.count > 0 {
            //response["errors"] = errors
            throw Abort.custom(status: .serviceUnavailable, message: "Please fill out all required fields")
        }

        return parameters
    }
    
    func sendPushNotification(request: Request) throws -> ResponseRepresentable {
        // create base ResponseRepresentable
        var response: Node = try ["menu1": true].makeNode()

        // handle request
        do {
            // get the apns configuration
            guard
                let teamIdentifier = drop.config["apns", "teamIdentifier"]?.string,
                let APNSAuthKeyID = drop.config["apns", "APNSAuthKeyID"]?.string,
                let APNSAuthKeyPath = drop.config["apns", "APNSAuthKeyPath"]?.string
            else {
                throw Abort.custom(status: .serviceUnavailable, message: "Missing or invalid 'apns.json' configuration")
            }

            // get and validate request parameters
            let parameters = try getParameters(request: request, fields: ["title", "body", "id"], response: &response)
            let title = parameters["title"]!
            let body = parameters["body"]!
            let id = parameters["id"]!

            // get the device we need to send the push notification to
            guard let device = try Device.query().filter("id", id).first() else { throw Abort.badRequest }
            guard let deviceToken = device.token else { throw Abort.badRequest }
            guard let identifier = device.identifier else { throw Abort.badRequest }

            // send push notification to device
            let options = try Options(topic: identifier, teamId: teamIdentifier, keyId: APNSAuthKeyID, keyPath: APNSAuthKeyPath)
            let vaporAPNS = try VaporAPNS(options: options)
            let payload = Payload(title: title, body: body)
            let pushMessage = ApplePushMessage(priority: .immediately, payload: payload, sandbox: device.sandbox)
            let result = vaporAPNS.send(pushMessage, to: deviceToken)
            
            debugPrint("result: \(result)")

            // handle result
            switch result {
            case .success(let messageID, _, _):
                response["feedback"] = "Successfully sent a push notification to \(device.model!) '\(device.name!)'".makeNode()
                response["device"] = try device.makeNode()
                log.info("sent push notification \(messageID) to device \(id)")
                break
            case .error(_, _, let error):
                response["device"] = try device.disable().makeNode()
                log.error("Could not send push notification (\(error))")
                throw Abort.custom(status: .serviceUnavailable, message: "Could not sent the push notification (\(error))")
            case .networkError(let error):
                response["device"] = try device.disable().makeNode()
                log.error("Could not send push notification (\(error))")
                throw Abort.custom(status: .serviceUnavailable, message: "Could not sent the push notification (\(error))")
            }
        } catch Abort.custom(_, let message) {
            response["error"] = message.makeNode()
        } catch {
            response["error"] = "An unknown error occured"
        }
        
        // fetch all devices
        response["devices"] = try Device.all().makeNode().converted(to: JSON.self).makeNode()

        return try drop.view.make(view, response)
    }
    
    func makeResource() -> Resource<Device> {
        return Resource(
            index: index,
            store: sendPushNotification
        )
    }
}

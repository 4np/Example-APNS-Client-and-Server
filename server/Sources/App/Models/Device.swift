//
//  Device.swift
//  server
//
//  Created by Jeroen Wesbeek on 27/10/16.
//
//

import Vapor
import Fluent

// MARK: Device model

struct Device: Model {
    var id: Node?
    var vendorUUID: String?
    var advertisingUUID: String?
    var name: String?
    var model: String?
    var systemName: String?
    var systemVersion: String?
    var identifier: String?
    var token: String?
    var sandbox: Bool = false
    var enabled: Bool = false
    
    // used by Fluent internally
    var exists: Bool = false
}

// MARK: NodeConvertible

extension Device: NodeConvertible {
    init(node: Node, in context: Context) throws {
        id = node["id"]
        vendorUUID = node["vendorUUID"]?.string
        advertisingUUID = node["advertisingUUID"]?.string
        name = node["name"]?.string
        model = node["model"]?.string
        systemName = node["systemName"]?.string
        systemVersion = node["systemVersion"]?.string
        identifier = node["identifier"]?.string
        token = node["token"]?.string
        sandbox = node["sandbox"]?.bool ?? false
        enabled = node["enabled"]?.bool ?? true
    }
    
    func makeNode(context: Context) throws -> Node {
        return try Node.init(node:
            [
                "id": id,
                "vendorUUID": vendorUUID,
                "advertisingUUID": advertisingUUID,
                "name": name,
                "model": model,
                "systemName": systemName,
                "systemVersion": systemVersion,
                "identifier": identifier,
                "token": token,
                "sandbox": sandbox,
                "enabled": enabled
            ]
        )
    }
}

// MARK: Database preparations

extension Device: Preparation {
    static func prepare(_ database: Database) throws {
        try database.create("devices") { devices in
            devices.id()
            devices.string("vendorUUID")
            devices.string("advertisingUUID")
            devices.string("name")
            devices.string("model")
            devices.string("systemName")
            devices.string("systemVersion")
            devices.string("identifier")
            devices.string("token")
            devices.bool("sandbox")
            devices.bool("enabled")
        }
    }
    
    static func revert(_ database: Database) throws {
        fatalError("unimplemented \(#function)")
    }
}

// MARK: Merge data

extension Device {
    mutating func merge(updates: Device) {
        id = updates.id ?? id
        vendorUUID = updates.vendorUUID ?? vendorUUID
        advertisingUUID = updates.advertisingUUID ?? advertisingUUID
        name = updates.name ?? name
        model = updates.model ?? model
        systemName = updates.systemName ?? systemName
        systemVersion = updates.systemVersion ?? systemVersion
        identifier = updates.identifier ?? identifier
        token = updates.token ?? token
        sandbox = updates.sandbox
        enabled = updates.enabled
    }
}

// MARK: Update

extension Device {
    func disable() throws -> Device {
        var device = self
        device.enabled = false
        try device.save()
        return device
    }
    
    func enable() throws -> Device {
        var device = self
        device.enabled = true
        try device.save()
        return device
    }
}

// MARK: Get existing device based on uuid and / or token

extension Device {
    func getExistingDevice() -> Device? {
        // try to get the Device based on token
        do {
            if let token = self.token, let existingDevice = try Device.query().filter("token", token).first() {
                return existingDevice
            }
        } catch { }
        
        // try to get the Device based on vendor uuid
        do {
            if let vendorUUID = self.vendorUUID, let existingDevice = try Device.query().filter("vendorUUID", vendorUUID).first() {
                return existingDevice
            }
        } catch { }

        // try to get the Device based on advertising uuid
        do {
            if let advertisingUUID = self.advertisingUUID, let existingDevice = try Device.query().filter("advertisingUUID", advertisingUUID).first() {
                return existingDevice
            }
        } catch { }
        
        // no luck
        return nil
    }
}

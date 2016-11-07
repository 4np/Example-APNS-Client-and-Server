//
//  DeviceController.swift
//  server
//
//  Created by Jeroen Wesbeek on 27/10/16.
//
//

import Vapor
import HTTP

final class DeviceController: ResourceRepresentable {
    fileprivate let view = "devices"
    
    func index(request: Request) throws -> ResponseRepresentable {
        let devices = try Device.all().makeNode().converted(to: JSON.self)
        
        return try drop.view.make(view, [
            "menu2": true,
            "devices": devices.makeNode(),
            "hasDevices": true
        ])
    }
    
    func create(request: Request) throws -> ResponseRepresentable {
        var device = try request.post()
        var isNew = false
        
        // check if this device already exists
        if let token = device.token, let existingDevice = try Device.query().filter("token", token).first() {
            // update device with current data
            var updatedDevice = existingDevice
            updatedDevice.merge(updates: device)
            
            // use this device instead
            device = updatedDevice
            
            // re-enable device if it's disabled
            if !device.enabled {
                device.enabled = true
                log.verbose("re-enabling device \(device.id?.int)")
            }
        } else {
            isNew = true
        }
            
        // save this device
        try device.save()
        
        if isNew {
            log.verbose("created new device \(device.id?.int)")
        }
        
        return device
    }
    
    func makeResource() -> Resource<Device> {
        return Resource(
            index: index,       // GET (multiple)
            store: create       // POST (multiple)
//            show: show,       // GET
//            replace: replace, // PUT
//            modify: update,   // PATCH
//            destroy: delete,  // DELETE
//            clear: clear      // DELETE (multiple)
        )
    }
}

extension Request {
    func post() throws -> Device {
        guard let json = json else { throw Abort.badRequest }
        return try Device(node: json)
    }
}

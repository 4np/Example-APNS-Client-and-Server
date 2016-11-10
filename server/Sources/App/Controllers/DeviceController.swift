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
    
    fileprivate func index(request: Request) throws -> ResponseRepresentable {
        let allDevices = try Device.all()
        let devices = try allDevices.makeNode().converted(to: JSON.self)
        
        return try drop.view.make(view, [
            "menu2": true,
            "devices": devices.makeNode(),
            "hasDevices": (allDevices.count > 0)
        ])
    }
    
    fileprivate func createOrUpdate(request: Request) throws -> ResponseRepresentable {
        var device = try request.post()
        var isNew = false
        
        // check if this device already exists
        if let existingDevice = device.getExistingDevice() {
            // update device with current data
            var updatedDevice = existingDevice
            updatedDevice.merge(updates: device)
            
            // use this device instead
            device = updatedDevice
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
            index: index,           // GET (multiple)
            store: createOrUpdate   // POST (multiple)
//            modify: update      // PATCH
//            show: show,       // GET
//            replace: replace, // PUT
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

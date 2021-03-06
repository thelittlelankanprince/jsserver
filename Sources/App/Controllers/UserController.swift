//
//  UserController.swift
//  jumpseat-testPackageDescription
//
//  Created by Tarik Stafford on 13/2/18.
//

import Foundation
import Vapor


internal struct UserController {
    
    private var drop: Droplet
    
    internal init(drop: Droplet) {
        self.drop = drop
    }
    
    internal func addRoutes() {
        
        let group = drop.grouped("api", "users")
        group.get(handler: getAllUsers)
        group.get(User.parameter, "hostedRides", handler: getUserHostedRides)
        group.get(User.parameter, "allRides", handler: getUserRides)
        group.post(handler: addUser)
        
    }
    
    private func getAllUsers(_ req: Request) throws -> ResponseRepresentable {
        let users = try User.all()
        return try users.makeJSON()
    }
    
    private func addUser(_ req: Request) throws -> ResponseRepresentable {
        
        guard let json = req.json else { throw Abort.badRequest }
        let user = try User.init(json: json, drop: drop)
        try user.save()
        return try user.makeJSON()
    }
    
    private func getUserHostedRides(_ req: Request) throws -> ResponseRepresentable {
        
        let user = try req.parameters.next(User.self)
        return try user.hostedRides.all().makeJSON()
        
    }
    
    private func getUserRides(_ req: Request) throws -> ResponseRepresentable {
        
        let user = try req.parameters.next(User.self)
        let rides = try user.addedRides.all()
        return try rides.makeJSON()
    }
    
}

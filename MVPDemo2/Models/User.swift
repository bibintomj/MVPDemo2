//
//  User.swift
//  MVPDemo2
//
//  Created by Bibin on 06/02/19.
//  Copyright © 2019 Bibin. All rights reserved.
//

import UIKit

class User: Codable {
    
    let name:       Name
    let email:      String
    let phone:      String
    let imageURL:   ImageURL
    var image:      UIImage? = nil
    
    private enum CodingKeys: String, CodingKey {
        case name, email, phone
        case imageURL = "picture"
    }
}

extension User: Equatable {
    static func == (lhs: User, rhs: User) -> Bool {
        return (lhs.name == rhs.name &&
                lhs.email == rhs.email &&
                lhs.phone == rhs.phone &&
                lhs.imageURL == rhs.imageURL &&
                lhs.image == rhs.image)
    }
}



struct Name: Codable {
    let title:  String
    let first:  String
    let last:   String
    
    var full: String { return self.title + "." + self.first + " " + self.last }
    
    private enum CodingKeys: String, CodingKey {
        case title, first, last
    }
}

extension Name: Equatable {}


struct ImageURL: Codable {
    let large:      String
    let medium:     String
    let thumbnail:  String
    
    private enum CodingKeys: String, CodingKey {
        case large, medium, thumbnail
    }
    
}

extension ImageURL: Equatable {}

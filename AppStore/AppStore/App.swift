//
//  App.swift
//  AppStore
//
//  Created by Süleyman Koçak on 4.05.2020.
//  Copyright © 2020 Suleyman Kocak. All rights reserved.
//

import Foundation

struct App: Decodable, Hashable {
    let id: Int
    let tagline: String
    let name: String
    let subheading: String
    let image: String
    let iap: Bool
}

//
//  SelfConfiguringCell.swift
//  AppStore
//
//  Created by Süleyman Koçak on 4.05.2020.
//  Copyright © 2020 Suleyman Kocak. All rights reserved.
//

import Foundation

protocol SelfConfiguringCell {
    static var reuseIdentifier:String {get}
    func configure(with app:App)
}

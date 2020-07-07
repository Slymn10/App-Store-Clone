//
//  SmallTableCell.swift
//  AppStore
//
//  Created by Süleyman Koçak on 4.05.2020.
//  Copyright © 2020 Suleyman Kocak. All rights reserved.
//

import UIKit

class SmallTableCell: UICollectionViewCell,SelfConfiguringCell {
    static var reuseIdentifier: String = "SmallTableCell"
    let name = UILabel()
    let imageView = UIImageView()

    override init(frame: CGRect) {
        super.init(frame: frame)

        name.font = UIFont.preferredFont(forTextStyle: .title2)
        name.textColor = .label
        imageView.layer.cornerRadius = 7
        imageView.clipsToBounds = true
        let stackView = UIStackView(arrangedSubviews: [imageView,name])
        stackView.alignment = .center
        stackView.spacing = 20
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(stackView)

        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with app: App) {
        name.text = app.name
        imageView.image = UIImage(named: app.image)
    }
}

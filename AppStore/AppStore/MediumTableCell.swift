//
//  MediumTableCell.swift
//  AppStore
//
//  Created by Süleyman Koçak on 4.05.2020.
//  Copyright © 2020 Suleyman Kocak. All rights reserved.
//

import UIKit

class MediumTableCell: UICollectionViewCell,SelfConfiguringCell {


    static let reuseIdentifier: String = "MediumTableCell"
    let name = UILabel()
    let subtitle = UILabel()
    let imageView = UIImageView()
    let buyButton = UIButton(type: .custom)

    override init(frame: CGRect) {
        super.init(frame: frame)
        name.font = UIFont.preferredFont(forTextStyle: .headline)
        name.textColor = .label
        subtitle.font = UIFont.preferredFont(forTextStyle: .subheadline)
        subtitle.textColor = .secondaryLabel

        imageView.layer.cornerRadius = 15
        imageView.clipsToBounds = true

        buyButton.setImage(UIImage(systemName: "icloud.and.arrow.down"), for: .normal)

        imageView.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        buyButton.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        let innerStackView = UIStackView(arrangedSubviews: [name,subtitle])
        innerStackView.axis = .vertical
        let outerStackView = UIStackView(arrangedSubviews: [imageView,innerStackView,buyButton])
        outerStackView.axis = .horizontal
        outerStackView.alignment = .center
        outerStackView.spacing = 10
        outerStackView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(outerStackView)

        NSLayoutConstraint.activate([
            outerStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            outerStackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            outerStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
        ])


    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }



    func configure(with app: App) {
        name.text = app.name
        subtitle.text = app.subheading
        imageView.image = UIImage(named: app.image)
    }

}

//
//  DropDownCell.swift
//  DemonTest
//
//  Created by Olya Chebotkova on 15.11.2020.
//

import UIKit

class DropDownCell: UITableViewCell{
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Helvetica", size: 20)
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

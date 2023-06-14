//
//  SettingTableViewCell.swift
//  lets-talk
//
//  Created by Stefan de Gier on 04/06/2023.
//

import UIKit

class SettingTableViewCell: UITableViewCell {

    @IBOutlet weak var iconContainer: UIView!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    func configure(with title: String, icon: UIImage, iconBackgroundColor: UIColor) {
        self.titleLabel.text = title
        self.iconImageView.image = icon
        self.iconContainer.backgroundColor = iconBackgroundColor
    }
    
    override func prepareForReuse() {
        self.titleLabel.text = nil
        self.iconImageView.image = nil
        self.iconContainer.backgroundColor = nil
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.iconContainer.layer.cornerRadius = 5.0
        self.iconContainer.clipsToBounds = true
    }

    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)
        if highlighted {
            HapticFeedbackManager.shared.performImpactFeedback(style: .medium)
            self.backgroundColor = UIColor.secondarySystemFill
        } else {
            self.backgroundColor = UIColor.systemBackground
        }
    }
    
}

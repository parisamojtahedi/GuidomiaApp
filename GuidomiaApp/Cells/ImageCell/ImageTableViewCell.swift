//
//  ImageTableViewCell.swift
//  GuidomiaApp
//
//  Created by Parisa Mojtahedi on 2021-11-22.
//

import UIKit

struct ImageTableViewCellModel {
    let image: UIImage
    let topLabelText: String
}
class ImageTableViewCell: UITableViewCell, ConfigurableCell {
    
    @IBOutlet weak var topContainerView: UIView!
    @IBOutlet weak var topLabel: UILabel!
    @IBOutlet weak var mainImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        topContainerView.backgroundColor = UIColor(hexString: "#FC6016")
        topLabel.textColor = .white
    }
    func configure(model: ImageTableViewCellModel) {
        mainImageView.image = model.image
        topLabel.text = model.topLabelText
    }
}

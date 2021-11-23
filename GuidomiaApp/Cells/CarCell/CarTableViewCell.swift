//
//  CarTableViewCell.swift
//  GuidomiaApp
//
//  Created by Parisa Mojtahedi on 2021-11-22.
//

import UIKit

struct CarTableViewCellModel {
    let image: UIImage
    let name: String
    let price: String
    let numericStar: Int
    
}
class CarTableViewCell: UITableViewCell, ConfigurableCell {
    
    lazy var thumbnailImageView: UIImageView = {
        let imgView = UIImageView(frame: .zero)
        imgView.clipsToBounds = true
        imgView.contentMode = .scaleAspectFit
        
        return imgView
    }()
    
    lazy var titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.textColor = UIColor(hexString: "#858585")
        lbl.font = UIFont.systemFont(ofSize: 18)
        return lbl
    }()
    
    lazy var priceLabel: UILabel = {
        let lbl = UILabel()
        lbl.textColor = UIColor(hexString: "#858585")
        lbl.font = UIFont.systemFont(ofSize: 12)
        return lbl
    }()
    
    lazy var starsStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .horizontal
        sv.alignment = .fill
        sv.distribution = .fillEqually
        sv.addArrangedSubview(UIImageView(image: UIImage(systemName: "star")))
        sv.addArrangedSubview(UIImageView(image: UIImage(systemName: "star")))
        sv.addArrangedSubview(UIImageView(image: UIImage(systemName: "star")))
        sv.addArrangedSubview(UIImageView(image: UIImage(systemName: "star")))
        sv.addArrangedSubview(UIImageView(image: UIImage(systemName: "star")))

        return sv
    }()
    
    lazy var descStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.alignment = .leading
        sv.distribution = .equalSpacing
        sv.addArrangedSubview(titleLabel)
        sv.addArrangedSubview(priceLabel)
        sv.addArrangedSubview(starsStackView)
        return sv
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        contentView.addSubview(thumbnailImageView)
        contentView.addSubview(descStackView)

        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupConstraints() {
        thumbnailImageView.translatesAutoresizingMaskIntoConstraints = false
        thumbnailImageView.widthAnchor.constraint(equalToConstant: 100).isActive = true
        thumbnailImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8).isActive = true
        thumbnailImageView.heightAnchor.constraint(equalTo: thumbnailImageView.widthAnchor).isActive = true
        thumbnailImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        
        descStackView.translatesAutoresizingMaskIntoConstraints = false
        descStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        descStackView.leadingAnchor.constraint(equalTo: thumbnailImageView.trailingAnchor).isActive = true
        descStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        descStackView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(model: CarTableViewCellModel) {
        thumbnailImageView.image = model.image
        titleLabel.text = model.name
        priceLabel.text = model.price
        
        for index in 0...model.numericStar - 1 {
            
            if let imgview = starsStackView.subviews[index] as? UIImageView {
                imgview.image = UIImage(systemName: "star.fill")
                imgview.tintColor = UIColor(hexString: "#FC6016")
            }
        }
    }

}

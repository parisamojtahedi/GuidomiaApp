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
    let prosList: [String]
    let consList: [String]
}
class CarTableViewCell: UITableViewCell, ConfigurableCell {
    lazy var containerView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.alignment = .fill
        sv.distribution = .fillEqually
        sv.backgroundColor = UIColor(hexString: "#D5D5D5")
        return sv
    }()
    
    lazy var separatorLine: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hexString: "#FC6016")
        return view
    }()
    
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
        sv.isUserInteractionEnabled = false
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
        sv.spacing = 2
        return sv
    }()
    
    
    lazy var topStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .horizontal
        sv.alignment = .center
        sv.distribution = .fillEqually
        sv.addArrangedSubview(thumbnailImageView)
        sv.addArrangedSubview(descStackView)
        sv.spacing = 16
        thumbnailImageView.widthAnchor.constraint(equalToConstant: 100).isActive = true

        return sv
    }()
    
    lazy var bottomStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.alignment = .fill
        sv.distribution = .fillEqually
        return sv
    }()
    
    var shouldExpand: Bool = false
    var isInitialLoad: Bool = true
    let proConsView = ProConsView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        containerView.addArrangedSubview(topStackView)
        contentView.addSubview(containerView)
        contentView.addSubview(separatorLine)
        containerView.addArrangedSubview(proConsView)
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupConstraints() {
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10).isActive = true
        containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8).isActive = true
        containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8).isActive = true
        containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8).isActive = true
        
        separatorLine.translatesAutoresizingMaskIntoConstraints = false
        separatorLine.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        separatorLine.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16).isActive = true
        separatorLine.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16).isActive = true
        separatorLine.heightAnchor.constraint(equalToConstant: 2).isActive = true
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
        
        if model.numericStar < starsStackView.subviews.count {
            for index in model.numericStar...starsStackView.subviews.count - 1 {
                
                if let imgview = starsStackView.subviews[index] as? UIImageView {
                    imgview.image = UIImage(systemName: "star")
                    imgview.tintColor = UIColor(hexString: "#FC6016")
                }
            }
        }

        proConsView.prosSV.subviews.forEach({ $0.removeFromSuperview() })
        proConsView.consSV.subviews.forEach({ $0.removeFromSuperview() })

        proConsView.configure(proList: model.prosList,
                              proTitle: "Pros",
                              consList: model.consList,
                              consTitle: "Cons")
        if shouldExpand {
            proConsView.isHidden = false
        } else {
            proConsView.isHidden = true
        }
        
        layoutIfNeeded()
    }
    
    private func buildSV(using list: [String], title: String) {
        
        let titleLabel = UILabel()
        titleLabel.text = title
        bottomStackView.addArrangedSubview(titleLabel)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        thumbnailImageView.image = nil
        bottomStackView.subviews.compactMap({ $0 as? UILabel }).forEach({ $0.text = nil })
    }

}

//
//  ProConsView.swift
//  GuidomiaApp
//
//  Created by Parisa Mojtahedi on 2021-11-23.
//

import UIKit

class ProConsView: UIView {
    lazy var prosLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 24)
        label.textColor = UIColor(hexString: "#858585")
        return label
    }()
    
    lazy var prosSV: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.alignment = .fill
        sv.distribution = .fill
        return sv
    }()
    
    lazy var consLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 24)
        label.textColor = UIColor(hexString: "#858585")
        return label
    }()
    
    lazy var consSV: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.alignment = .fill
        sv.distribution = .fill
        return sv
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupConstraints() {
        addSubview(prosLabel)
        addSubview(prosSV)
        addSubview(consLabel)
        addSubview(consSV)
        
        prosLabel.translatesAutoresizingMaskIntoConstraints = false
        prosLabel.topAnchor.constraint(equalTo: topAnchor).isActive = true
        prosLabel.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        prosLabel.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        
        prosSV.translatesAutoresizingMaskIntoConstraints = false
        prosSV.topAnchor.constraint(equalTo: prosLabel.bottomAnchor).isActive = true
        prosSV.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        prosSV.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        
        consLabel.translatesAutoresizingMaskIntoConstraints = false
        consLabel.topAnchor.constraint(equalTo: prosSV.bottomAnchor).isActive = true
        consLabel.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        consLabel.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        
        consSV.translatesAutoresizingMaskIntoConstraints = false
        consSV.topAnchor.constraint(equalTo: consLabel.bottomAnchor).isActive = true
        consSV.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        consSV.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        consSV.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true

    }
    var hasConfigured: Bool = false
    
    func configure(proList: [String], proTitle: String,
                   consList: [String], consTitle: String) {
        
        if !proList.isEmpty {
            prosLabel.text = proTitle
            
            for pro in proList {
                let itemLbl = UILabel()
                itemLbl.numberOfLines = 0

                let text = NSMutableAttributedString()
                text.append(NSAttributedString(string: "\u{2022} ", attributes: [NSAttributedString.Key.foregroundColor: UIColor(hexString: "#FC6016"),
                     NSAttributedString.Key.font: UIFont.systemFont(ofSize: 28)]))

                text.append(NSAttributedString(string: pro, attributes: [NSAttributedString.Key.foregroundColor: UIColor.black]))

                itemLbl.attributedText = text
                prosSV.addArrangedSubview(itemLbl)
                
            }
        }

        if !consList.isEmpty {
            consLabel.text = consTitle
            
            for con in consList {
                let itemLbl = UILabel()
                itemLbl.numberOfLines = 0

                let text = NSMutableAttributedString()
                text.append(NSAttributedString(string: "\u{2022} ", attributes: [NSAttributedString.Key.foregroundColor: UIColor(hexString: "#FC6016"),
                     NSAttributedString.Key.font: UIFont.systemFont(ofSize: 28)]))

                text.append(NSAttributedString(string: con, attributes: [NSAttributedString.Key.foregroundColor: UIColor.black]))

                itemLbl.attributedText = text
                consSV.addArrangedSubview(itemLbl)
                
            }
        }
            
        
    }
}

//  Created by Edoardo de Cal on 10/26/19.
//  Copyright © 2019 Edoardo de Cal. All rights reserved.
//

import Foundation
import UIKit

class CustomView: UIView {
    
    let labelStreet: UILabel = {
        let label = UILabel()
        label.text = "Street name"
        return label
    }()
    
    let labelCity: UILabel = {
        let label = UILabel()
        label.text = "City name"
        return label
    }()
    
    let labelRegion: UILabel = {
        let label = UILabel()
        label.text = "Region name"
        return label
    }()
    
    let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        backgroundColor = .white
        layer.cornerRadius = 20
        translatesAutoresizingMaskIntoConstraints = false
        heightAnchor.constraint(equalToConstant: 120).isActive = true
        widthAnchor.constraint(equalToConstant: 300).isActive = true
        setupStackView()
    }
    
    func setupStackView() {
        addSubview(stackView)
        stackView.addArrangedSubview(labelStreet)
        stackView.addArrangedSubview(labelCity)
        stackView.addArrangedSubview(labelRegion)
        stackView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        stackView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
    
    public func setTextLabels(textStreet: String, textCity: String, textRegion: String) {
        labelStreet.text = textStreet
        labelCity.text = textCity
        labelRegion.text = textRegion
    }
    
}

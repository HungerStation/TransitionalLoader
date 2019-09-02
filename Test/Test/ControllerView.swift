//
//  ControllerView.swift
//  TransitionalLoaderShowcase
//
//  Created by Ammar Altahhan on 11/08/2019.
//  Copyright © 2019 Ammar Altahhan. All rights reserved.
//

import UIKit

class ControllerView: UIView {
    
    var didTapView: ((_ view: UIView)->Void)?
    
    private var firstButton = UIButton()
    private var secondButton = UIButton()
    private var thirdButton = UIButton()
    
    private lazy var markImageView : UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(color: .white, size: CGSize(width: 24, height: 24))
        iv.contentMode = .scaleAspectFit
        iv.backgroundColor = .white
        iv.layer.cornerRadius = 12
        iv.clipsToBounds = true
        iv.isUserInteractionEnabled = true
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.layer.borderColor = UIColor.gray.cgColor
        iv.layer.borderWidth = 1
        return iv
    }()
    
    init() {
        super.init(frame: CGRect.zero)
        backgroundColor = .white
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        
        firstButton.translatesAutoresizingMaskIntoConstraints = false
        firstButton.tag = 1
        secondButton.translatesAutoresizingMaskIntoConstraints = false
        secondButton.tag = 2
        thirdButton.translatesAutoresizingMaskIntoConstraints = false
        thirdButton.tag = 3
        
        firstButton.backgroundColor = .purple
        firstButton.setTitleColor(.white, for: .normal)
        firstButton.layer.cornerRadius = 6
        firstButton.setTitle("Tap me", for: .normal)
        secondButton.backgroundColor = .orange
        secondButton.setTitleColor(.white, for: .normal)
        secondButton.layer.cornerRadius = 6
        secondButton.setTitle("Tap me", for: .normal)
        thirdButton.backgroundColor = .blue
        thirdButton.setTitleColor(.white, for: .normal)
        thirdButton.layer.cornerRadius = 6
        thirdButton.setTitle("Tap me", for: .normal)
        
        firstButton.addTarget(self, action: #selector(btnTapped(_:)), for: .touchUpInside)
        secondButton.addTarget(self, action: #selector(btnTapped(_:)), for: .touchUpInside)
        thirdButton.addTarget(self, action: #selector(btnTapped(_:)), for: .touchUpInside)
        
        markImageView.tag = 4
        markImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(viewTapped(_:))))
        markImageView.backgroundColor = nil
        
        let stackView = UIStackView(arrangedSubviews: [firstButton, secondButton, thirdButton, markImageView])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 24
        stackView.alignment = .center
        stackView.distribution = .fill
        
        addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 32),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -32),
            firstButton.widthAnchor.constraint(equalToConstant: 120),
            secondButton.heightAnchor.constraint(equalToConstant: 60),
            thirdButton.heightAnchor.constraint(equalToConstant: 15),
            thirdButton.widthAnchor.constraint(equalToConstant: 30),
            
            markImageView.widthAnchor.constraint(equalToConstant: 24),
            markImageView.heightAnchor.constraint(equalToConstant: 24)
            ])
    }
    
    @objc func btnTapped(_ sender: UIButton) {
        didTapView?(sender)
    }
    
    @objc func viewTapped(_ sender: UITapGestureRecognizer) {
        didTapView?(markImageView)
    }
    
}

public extension UIImage {
    convenience init?(color: UIColor, size: CGSize = CGSize(width: 1, height: 0.4)) {
        let rect = CGRect(origin: .zero, size: size)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        color.setFill()
        UIRectFill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        guard let cgImage = image?.cgImage else { return nil }
        self.init(cgImage: cgImage)
    }
}

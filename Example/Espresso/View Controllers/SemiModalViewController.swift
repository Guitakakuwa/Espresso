//
//  SemiModalViewController.swift
//  Espresso_Example
//
//  Created by Mitch Treece on 10/25/19.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import Espresso

class SemiModalViewController: UISemiModalViewController {
              
    private var nextState: UISemiModalState {
        
        switch self.state {
        case .semiModal: return .modal
        case .modal: return .fullscreen
        case .fullscreen: return .semiModal
        }
        
    }
    
    init() {
        
        super.init(nibName: nil, bundle: nil)
        setupSemiModalStyle()
        
    }
    
    required init?(coder: NSCoder) {
        
        super.init(coder: coder)
        setupSemiModalStyle()
        
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        setupSubviews()
                
        self.view.addTapGesture { _ in
            self.transition(to: self.nextState)
        }
        
        self.view.addLongPressGesture { _ in
            self.dismiss(animated: true)
        }
        
    }
    
    private func setupSemiModalStyle() {
        
        // self.style = .cover
        // self.presentationDuration = 0.5
        // self.dismissalDuration = 0.3
        
    }
    
    private func setupSubviews() {
        
        self.view.backgroundColor = .white
        
        let button = UIButton()
        button.backgroundColor = .groupTableViewBackground
        button.setTitle("Another", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.layer.cornerRadius = 6
        button.addTarget(self, action: #selector(didTapAnother(_:)), for: .touchUpInside)
        self.view.addSubview(button)
        button.snp.makeConstraints { make in
            make.leading.equalTo(20)
            make.bottom.equalTo(-(UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 20))
            make.trailing.equalTo(-20)
            make.height.equalTo(50)
        }

    }
    
    @objc private func didTapAnother(_ sender: UIButton) {
        
        let vc = SemiModalViewController()
        vc.view.backgroundColor = UIColor.random()
        self.present(vc, animated: true, completion: nil)
        
    }
    
}

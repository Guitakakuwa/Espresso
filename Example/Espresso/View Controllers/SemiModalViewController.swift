//
//  SemiModalViewController.swift
//  Espresso_Example
//
//  Created by Mitch Treece on 10/25/19.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import Espresso

class SemiModalViewController: UISemiModalViewController {
    
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

        let anotherButton = UIButton()
        anotherButton.backgroundColor = .groupTableViewBackground
        anotherButton.setTitle("Present Another", for: .normal)
        anotherButton.setTitleColor(.black, for: .normal)
        anotherButton.layer.cornerRadius = 6
        anotherButton.addTarget(self, action: #selector(didTapAnother(_:)), for: .touchUpInside)
        self.view.addSubview(anotherButton)
        anotherButton.snp.makeConstraints { make in
            make.leading.equalTo(20)
            make.bottom.equalTo(-(UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 20))
            make.trailing.equalTo(-20)
            make.height.equalTo(50)
        }
        
        let stateControl = UISegmentedControl()
        stateControl.insertSegment(withTitle: "Semi-modal", at: 0, animated: false)
        stateControl.insertSegment(withTitle: "Modal", at: 1, animated: false)
        stateControl.insertSegment(withTitle: "Fullscreen", at: 2, animated: false)
        stateControl.selectedSegmentIndex = 0
        stateControl.addTarget(self, action: #selector(stateControlDidChange(_:)), for: .valueChanged)
        self.view.addSubview(stateControl)
        stateControl.snp.makeConstraints { make in
            make.leading.equalTo(20)
            make.trailing.equalTo(-20)
            make.bottom.equalTo(anotherButton.snp.top).offset(-8)
            make.height.equalTo(30)
        }

    }
    
    @objc private func stateControlDidChange(_ sender: UISegmentedControl) {
        
        switch sender.selectedSegmentIndex {
        case 0: transition(to: .semiModal)
        case 1: transition(to: .modal)
        case 2: transition(to: .fullscreen)
        default: break
        }
        
    }
    
    @objc private func didTapAnother(_ sender: UIButton) {
        
        let vc = SemiModalViewController()
        vc.view.backgroundColor = UIColor.random()
        self.present(vc, animated: true, completion: nil)
        
    }
    
}

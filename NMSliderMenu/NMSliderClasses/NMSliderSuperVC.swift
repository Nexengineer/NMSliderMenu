//
//  NMSliderSuperVC.swift
//  NMSliderMenu
//
//  Created by Neeraj Kumar Mishra on 8/17/17.
//  Copyright © 2017 NexEngineer. All rights reserved.
//

import UIKit

class NMSliderSuperVC: UIViewController {
    var enabledHamburger: Bool = true
    let btnName = UIButton()

    //MARK:: View Controller LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override open func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if !enabledHamburger {
            return
        }
        
        self.navigationController?.navigationBar.tintColor = UIColor.white
        btnName.frame = CGRect(x: 0, y: 0, width: 44, height: 44)
        
        btnName.backgroundColor = UIColor.clear
        btnName.setImage(UIImage(named: "MenuFilled"), for: .normal)
        btnName.tintColor = UIColor.white
            
        btnName.addTarget(self, action: #selector(NMSliderSuperVC.menutapped), for: .touchUpInside)
        let leftBarButton = UIBarButtonItem()
        leftBarButton.customView = btnName
        
        self.navigationController?.navigationBar.addSubview(btnName)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Additional Methods
    public func menutapped() {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Menu"), object: nil)
    }
    
    func openSideBar() {
        self.menutapped()
    }

}



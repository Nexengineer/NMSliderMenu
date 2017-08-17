//
//  NMSliderMenuVC.swift
//  NMSliderMenu
//
//  Created by Neeraj Kumar Mishra on 8/17/17.
//  Copyright © 2017 NexEngineer. All rights reserved.
//

import UIKit

// Enum For checking the current state
enum SectionState {
    case collapsed
    case expanded
}

// Protocol for sending the item selected

@objc
protocol NMMenuViewControllerDelegate {
    func indexSelectedLeftView(_ identifier: Int, title: String)
}

// Class Defination
class NMSliderMenuVC: UIViewController {
    @IBOutlet weak var tableViewMenu: UITableView!
    @IBOutlet weak var spaceFromLeft: NSLayoutConstraint!
    var delegateSlider: NMMenuViewControllerDelegate?
    
    fileprivate let arrTableViewData = ["First View", "Second View", "Third View", "Fourth View"]

    override func viewDidLoad() {
        super.viewDidLoad()
        self.spaceFromLeft.constant = 0
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: Swipe Gesture
//    @IBAction func hamburgerSwipe(_ sender: UISwipeGestureRecognizer) {
//        if let hamburgerContainerViewController = self.parent as? NMSliderContainerVCViewController {
//            hamburgerContainerViewController.toggleLeftPanel()
//        } else {
//            let obj = NMSliderContainerVCViewController()
//            obj.toggleLeftView(type:2)
//        }
//    }
}

// MARK :: Table View Data Source
extension NMSliderMenuVC: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrTableViewData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "menuCell")
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: "menuCell")
        }
        cell?.textLabel?.text = arrTableViewData[indexPath.row]
        return cell!
    }
}

extension NMSliderMenuVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.delegateSlider?.indexSelectedLeftView(indexPath.row, title: arrTableViewData[indexPath.row])
    }
}





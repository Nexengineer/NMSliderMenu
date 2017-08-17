//
//  NMSliderContainerVCViewController.swift
//  NMSliderMenu
//
//  Created by Neeraj Kumar Mishra on 8/17/17.
//  Copyright © 2017 NexEngineer. All rights reserved.
//

import UIKit
// MARK: To check the current state of Slider
enum SlideOutState {
    case collapsed
    case leftPanelExpanded
}

// MARK: Class defination
class NMSliderContainerVCViewController: UIViewController, NMMenuViewControllerDelegate {

    static var referanceToSelf: NMSliderContainerVCViewController?
    
    // Regular variables used here
    var centerNavigationController: UINavigationController!
    var leftViewController: NMSliderMenuVC?
    var centerPanelExpandedOffset: CGFloat?
    var currentState: SlideOutState = .collapsed
    
    override func viewDidLoad() {
        super.viewDidLoad()
        centerPanelExpandedOffset = 56.0
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        self.navigationController?.isNavigationBarHidden = true
        
        self.moveToViewControllers(0, title: "First")


    }

    override public func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(NMSliderContainerVCViewController.callMenu(notification:)), name:NSNotification.Name(rawValue: "Menu"), object: nil)
    }
    
    override public func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
   
}

// MARK: UIStoryBoard Extention
private extension UIStoryboard {
    class func containerStoryboard() -> UIStoryboard {
        return UIStoryboard(name: "NMSlider", bundle: Bundle.main)
    }
    
    class func mainStoryboard() -> UIStoryboard {
        return UIStoryboard(name: "Main", bundle: Bundle.main)
    }
    
    class func leftViewController() -> NMSliderMenuVC? {
        return containerStoryboard().instantiateViewController(withIdentifier: "NMSliderMenuVC") as? NMSliderMenuVC
    }
}


// MARK: Extenstion for handling the delegates
extension NMSliderContainerVCViewController{
    
    func animateLeftViewPosition(viewObj: UIView, durationLeftPanel: CGFloat, durationOtherControls: CGFloat, targetedPosition: CGFloat, completion: ((Bool) -> Void)! = nil) {
        viewObj.layoutIfNeeded()
        // For animating leftPanel
        UIView.animate(withDuration: 0.5, delay: TimeInterval(durationLeftPanel), usingSpringWithDamping: 1.0, initialSpringVelocity: 0, options: UIViewAnimationOptions(), animations: {
            viewObj.layoutIfNeeded()
            self.leftViewController?.view.frame.origin.x = targetedPosition
        }, completion: nil)
        
        // For animating rest of the screen
        UIView.animate(withDuration: 0.5, delay: TimeInterval(durationOtherControls), usingSpringWithDamping: 1.0, initialSpringVelocity: 0, options: UIViewAnimationOptions(), animations: {
            viewObj.layoutIfNeeded()
            if targetedPosition == 0 {
                viewObj.viewWithTag(101)?.frame.origin.x = (viewObj.frame.width)/4
                viewObj.viewWithTag(1001)?.frame.origin.x = (viewObj.frame.width)/4
                viewObj.viewWithTag(1002)?.frame.origin.x =  (self.leftViewController?.view.frame.width)!
            } else {
                viewObj.viewWithTag(101)?.frame.origin.x = 0
                viewObj.viewWithTag(1001)?.frame.origin.x = 0
                viewObj.viewWithTag(1002)?.removeFromSuperview()
            }
        }, completion: completion)
    }
    
    // Setting the left view Frame
    func setFrameOfleftView() {
        if UIDevice.current.userInterfaceIdiom == .pad {
            leftViewController?.view.frame = CGRect(x: -(self.view.bounds.width), y: 0, width: self.view.bounds.width/4, height: self.view.bounds.height)
        } else {
            leftViewController?.view.frame = CGRect(x: -(self.view.bounds.width), y: 0, width: self.view.bounds.width - 60, height: self.view.bounds.height)
        }
    }
    
    // For Regular View Controller
    func callMenu(notification: NSNotification) {
        self.toggleLeftPanel()
    }
    
    // Add slider to the central view
    func addSliderToCentral() {
        leftViewController = UIStoryboard.leftViewController()
        leftViewController?.view.frame.origin.x = -(self.view.bounds.width)
        self.setFrameOfleftView()
        self.addChildViewController(leftViewController!)
        self.view.addSubview((leftViewController?.view)!)
        leftViewController?.delegateSlider = self
        leftViewController?.didMove(toParentViewController: self)
    }
    
    public func toggleLeftPanel() {
        let notAlreadyExpanded = (currentState != .leftPanelExpanded)
        if notAlreadyExpanded {
            addSliderToCentral()
        }
        animateLeftPanel(notAlreadyExpanded)
    }
    
    public func collapseSidePanels() {
        switch currentState {
        case .leftPanelExpanded:
            currentState = .leftPanelExpanded
            toggleLeftPanel()
        default:
            break
        }
    }
    
    func configureMaskViewForOverlay(_ isSVC: Bool) -> UIView {
        let overLayView =  UIView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height))
        overLayView.backgroundColor = UIColor.black.withAlphaComponent(0.2)
        overLayView.tag = 1002
        var swipeGestureRecognizer: UISwipeGestureRecognizer?
        var tapGestureReconizer: UITapGestureRecognizer?
        swipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(NMSliderContainerVCViewController.handlePanGesture(_:)))
        swipeGestureRecognizer?.direction = UISwipeGestureRecognizerDirection.left
            tapGestureReconizer = UITapGestureRecognizer(target: self, action: #selector(NMSliderContainerVCViewController.handlePanGesture(_:)))
        overLayView.addGestureRecognizer(swipeGestureRecognizer!)
        overLayView.addGestureRecognizer(tapGestureReconizer!)
        return overLayView
    }
    
    func animateLeftPanel(_ shouldExpand: Bool) {
        if shouldExpand {
            currentState = .leftPanelExpanded
            self.centerNavigationController.view.addSubview(self.configureMaskViewForOverlay(false))
            self.animateLeftViewPosition(viewObj: centerNavigationController.view, durationLeftPanel: 0, durationOtherControls: 0.1, targetedPosition: 0, completion: { (Bool) in
            })
        } else {
            self.animateLeftViewPosition(viewObj: centerNavigationController.view, durationLeftPanel: 0.1, durationOtherControls: 0, targetedPosition: -self.view.bounds.width, completion: { (Bool) in
                self.currentState = .collapsed
                if self.leftViewController != nil {
                    self.leftViewController?.view.removeFromSuperview()
                    self.leftViewController?.removeFromParentViewController()
                    self.leftViewController = nil
                }
            })
        }
    }
}

// Gesture recognizer off
extension NMSliderContainerVCViewController: UIGestureRecognizerDelegate {
    func handlePanGesture(_ recognizer: UISwipeGestureRecognizer) {
        self.toggleLeftPanel()
    }
}

extension NMSliderContainerVCViewController {
    func indexSelectedLeftView(_ identifier: Int, title: String) {
        moveToViewControllers(identifier, title: title)
    }
    
    func moveToViewControllers(_ identifier: Int, title: String) {
        weak var tempSelf = self
        UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: UIViewAnimationOptions(), animations: {
            if tempSelf?.centerNavigationController != nil {
                tempSelf?.centerNavigationController.view.frame.origin.x = 0
            }
        }) { (Bool) in
                if tempSelf?.centerNavigationController != nil {
                    tempSelf?.centerNavigationController.view.removeFromSuperview()
                }
                var topViewController: NMSliderSuperVC?
                switch identifier {
                case 0:
                    topViewController = UIStoryboard.mainStoryboard().instantiateViewController(withIdentifier: "FirstViewController") as! FirstViewController
                case 1:
                    topViewController = UIStoryboard.mainStoryboard().instantiateViewController(withIdentifier: "SecondViewController") as! SecondViewController
                case 2:
                    topViewController = UIStoryboard.mainStoryboard().instantiateViewController(withIdentifier: "ThirdViewController") as! ThirdViewController
                case 3:
                    topViewController = UIStoryboard.mainStoryboard().instantiateViewController(withIdentifier: "FourthViewController") as! FourthViewController
                default:
                    print("Default case")
                }
                topViewController?.title = title
                tempSelf?.setCentralViewController(vcObj: topViewController!)
            }
    }
    
    
    func setCentralViewController(vcObj: NMSliderSuperVC) {
        self.centerNavigationController = nil
        self.centerNavigationController = UINavigationController(rootViewController: vcObj)
        self.view.addSubview(self.centerNavigationController.view)
        self.addChildViewController(self.centerNavigationController)
        self.centerNavigationController.didMove(toParentViewController: self)
        self.centerNavigationController.isNavigationBarHidden = false
        self.addGesture()
        self.currentState = .collapsed
        
    }
    
    func addGesture() {
        let swipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(NMSliderContainerVCViewController.handlePanGesture(_:)))
        swipeGestureRecognizer.direction = UISwipeGestureRecognizerDirection.right
        self.centerNavigationController.viewControllers.first?.view.addGestureRecognizer(swipeGestureRecognizer)
    }

    
    func topViewController(_ base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        return self.centerNavigationController.visibleViewController
    }
}




//
//  FloatWindow.swift
//  FloatWindow
//
//  Created by janlionly<jan_ron@qq.com> on 2019/11/15.
//  Copyright © 2018年 janlionly<jan_ron@qq.com>. All rights reserved.
//

import UIKit

enum FloatWindowStatus {
    case windowHideen
    case ballViewShowed
    case ballViewHideen
}

open class FloatWindow: UIWindow {
    private var isNeedCustomTransition = false
    private static var _shared: FloatWindow? = nil
    private let screenSize = UIScreen.main.bounds.size
    private let collectViewWidth: CGFloat = 150
    private var ballViewMargin: CGFloat = 6
    private var isHiding: Bool = false
    private var collectionViewOriginalFrame: CGRect {
        return CGRect(x: screenSize.width, y: UIScreen.main.bounds.size.height, width: collectViewWidth, height: collectViewWidth)
    }
    private var collectionViewDisplayFrame: CGRect {
        return CGRect(x: screenSize.width - collectViewWidth, y: screenSize.height - collectViewWidth, width: collectViewWidth, height: collectViewWidth)
    }

    private var collectView: FloatCollectView!
    weak private var originDelegate: UINavigationControllerDelegate?
    
    var status: FloatWindowStatus = .windowHideen
    
    public var ballView: FloatRoundEntryView!
     
    public var stayPoint: CGPoint = .zero {
        didSet {
            ballView.frame = CGRect(x: stayPoint.x, y: stayPoint.y, width: ballWidth, height: ballWidth)
        }
    }
    public var ballWidth: CGFloat = 54 {
        didSet {
            stayPoint = CGPoint(x: screenSize.width - ballViewMargin - ballWidth, y: stayPoint.y)
            ballView.frame = CGRect(x: stayPoint.x, y: stayPoint.y, width: ballWidth, height: ballWidth)
            ballView.layer.cornerRadius = ballWidth/2
        }
    }
    
    static public var shared: FloatWindow {
        get {
            if _shared == nil {
                _shared = FloatWindow()
            }
            return _shared!
        }
        set {
            _shared = newValue
        }
    }
    public var root: UIViewController? = nil
    weak public var nav: UINavigationController? {
        willSet {
            originDelegate = newValue?.delegate
        }
    }
    
    public var isShowPanExitView: Bool = false
    public var imageView: UIImageView! {
        willSet {
            imageView.removeFromSuperview()
        }
        didSet {
            imageView.frame = CGRect(x: 0, y: 0, width: ballWidth, height: ballWidth)
            imageView.layer.cornerRadius = ballWidth/2
            imageView.layer.masksToBounds = true
            ballView.addSubview(imageView)
        }
    }
    public var ballImage: UIImage? {
        didSet {
            imageView.frame = CGRect(x: 0, y: 0, width: ballWidth, height: ballWidth)
            imageView.layer.cornerRadius = ballWidth/2
            imageView.layer.masksToBounds = true
            imageView.image = ballImage
        }
    }
    public var userInfo: [AnyHashable : Any]?
    public var isHideIntoBall: Bool {
        return ballView.isHidden == false && root != nil
    }
    
    init() {
        super.init(frame: UIScreen.main.bounds)

        windowLevel = UIWindow.Level.statusBar - 1
        isHidden = true
        backgroundColor = UIColor.clear

        collectView = FloatCollectView(frame: collectionViewOriginalFrame)
        addSubview(collectView)
        stayPoint = CGPoint(x: screenSize.width - ballViewMargin - ballWidth, y: (screenSize.height - ballWidth)/2.0)
        ballView = FloatRoundEntryView(frame: CGRect(x: stayPoint.x, y: stayPoint.y, width: ballWidth, height: ballWidth))
        ballView.layer.cornerRadius = ballWidth/2
        ballView.backgroundColor = .systemTeal
        ballView.isHidden = true
        ballView.clickedCallback = {[weak self] in
            self?.show()
        }
        addSubview(ballView)
        
        imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: ballWidth, height: ballWidth))
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = ballWidth/2
        imageView.layer.masksToBounds = true
        ballView.addSubview(imageView)

        let pan = UIPanGestureRecognizer(target: self, action: #selector(processRoundEntryView(gesture:)))
        ballView.addGestureRecognizer(pan)
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("FloatWindow deinit")
    }
    
    open func push(root: UIViewController, in nav: UINavigationController?) {
        self.root = root
        self.nav = nav
        
        isHidden = false
        isHiding = false
        ballView.isHidden = true
        isNeedCustomTransition = false
        
        nav?.delegate = self
        nav?.pushViewController(root, animated: true)
    }
    
    open func show() {
        guard let root = root else {
            print("⚠️You should call push(root:in:) method firstly before call show() method")
            return
        }
        
        isHidden = false
        isHiding = false
        ballView.isHidden = true
        isNeedCustomTransition = true
        
        nav?.delegate = self
        nav?.pushViewController(root, animated: true)
        _ = FloatRoundEntryAnimator(operation: .push, sourceCenter: ballView.center)
        
    }
    
    open func hide() {
        isHidden = false
        isHiding = true
        ballView.isHidden = false
        isNeedCustomTransition = true
        
        status = .ballViewShowed
        hideCollectView(completion: nil)
        ballView.alpha = 1
        popRoot()
        nav?.delegate = originDelegate
    }
    
    open func clear() {
        isNeedCustomTransition = false
        isHiding = false
        ballView.isHidden = true
        nav?.delegate = originDelegate
        root = nil
        isHidden = true
    }
    
    open func destroy() {
        isNeedCustomTransition = false
        isHiding = false
        ballView.isHidden = true
        
        popRoot()
        nav?.delegate = originDelegate
        root = nil
        isHidden = true
    }
    
    private func popRoot() {
        if let nav = nav, let root = root {
            if let index = nav.viewControllers.firstIndex(of: root) {
                if index - 1 >= 0 {
                    nav.popToViewController(nav.viewControllers[index - 1], animated: true)
                } else {
                    nav.popToRootViewController(animated: true)
                }
            }
        }
    }

    //MARK: - Gesture
    
    @objc private func processRoundEntryView(gesture: UIPanGestureRecognizer) {
        let point = gesture.location(in: self)
        if gesture.state == .began {
            if isShowPanExitView {
                displayCollectView()
            }
            UIView.animate(withDuration: 0.1, delay: 0, options: .curveEaseOut, animations: {
                self.ballView.center = point
            }) { (finished) in

            }
        }else if gesture.state == .changed {
            ballView.center = point
            var isCollectViewInside = false
            let collectViewPoint = self.convert(point, to: collectView)
            if collectView.point(inside: collectViewPoint, with: nil) == true {
                isCollectViewInside = true
            }
            collectView.updateBGLayerPath(isSmall: !isCollectViewInside)
        }else if gesture.state == .ended || gesture.state == .cancelled {
            let collectViewPoint = self.convert(point, to: collectView)
            if collectView.point(inside: collectViewPoint, with: nil) == true {
                hideCollectView(completion: nil)
                UIView.animate(withDuration: 0.1, delay: 0, options: .curveLinear, animations: {
                    self.ballView.alpha = 0
                }) { (finished) in
                    self.ballView.isHidden = true
                    self.ballView.alpha = 1
                    self.isHidden = true
                    self.status = .windowHideen
                    self.destroy()
                }
            }else {
                var frame = ballView.frame
                if point.x > screenSize.width/2 {
                    frame.origin.x = screenSize.width - ballViewMargin - ballWidth
                }else {
                    frame.origin.x = ballViewMargin
                }
                var safeInsets = UIEdgeInsets.zero
                if #available(iOS 11.0, *) {
                    safeInsets = safeAreaInsets
                }
                if frame.origin.y > screenSize.height - ballWidth - safeInsets.bottom {
                    frame.origin.y = screenSize.height - ballWidth - safeInsets.bottom
                }
                if frame.origin.y < safeInsets.top {
                    frame.origin.y = safeInsets.top
                }
                hideCollectView(completion: nil)
                UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseOut, animations: {
                    self.ballView.frame = frame
                }) { (finished) in

                }
            }
        }
    }

    // MARK: - Exit view
    
    private func displayCollectView() {
        UIView.animate(withDuration: 0.1, delay: 0, options: .curveEaseOut, animations: {
            self.collectView.frame = self.collectionViewDisplayFrame
        }) { (finished) in

        }
    }

    private func hideCollectView(completion: (()->())?) {
        UIView.animate(withDuration: 0.1, delay: 0, options: .curveEaseOut, animations: {
            self.collectView.frame = self.collectionViewOriginalFrame
        }) { (finished) in
            completion?()
        }
    }

    //MARK: - Private
    
    private func interpolate(from: CGFloat, to: CGFloat, percent: CGFloat) -> CGFloat {
        return from + (to - from) * percent
    }

    override open func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        let ballViewPoint = self.convert(point, to: ballView)
        if ballView.point(inside: ballViewPoint, with: event) == true {
            return true
        }
        let collectViewPoint = self.convert(point, to: collectView)
        if collectView.point(inside: collectViewPoint, with: event) == true {
            return true
        }
        return false
    }
}

extension FloatWindow: UINavigationControllerDelegate {
    
    public func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        var isCustomTransition = false
        if operation == .push {
            if toVC == FloatWindow.shared.root {
                isCustomTransition = isNeedCustomTransition
            }
        }else if operation == .pop {
            if fromVC == FloatWindow.shared.root || isHiding {
                isCustomTransition = isNeedCustomTransition
                ballView.isHidden = false
            }
        }
        if isCustomTransition {
            return FloatRoundEntryAnimator(operation: operation, sourceCenter: FloatWindow.shared.ballView.center)
        }else {
            return nil
        }
    }
}

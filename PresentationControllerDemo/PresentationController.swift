//
//  PresentationController.swift
//  PresentationControllerDemo
//
//  Created by Binh Le on 9/26/18.
//  Copyright © 2018 Binh Le. All rights reserved.
//

import UIKit

class PresentationController: UIPresentationController {
    private var dimmingView: UIView
    private var defaultY: CGFloat = 0
    
    override var frameOfPresentedViewInContainerView: CGRect {
        guard let containerView = containerView else { return .zero }
        return CGRect(x: 0, y: containerView.bounds.height / 2, width: containerView.bounds.width, height: containerView.bounds.height / 2)
    }
    
    override init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?) {
        self.dimmingView = UIView()
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
        configureDimmingView()
    }
    
    override func containerViewDidLayoutSubviews() {
        super.containerViewDidLayoutSubviews()
        adjustDimmingViewFrame()
    }
    
    override func presentationTransitionWillBegin() {
        containerView?.addSubview(dimmingView)
        dimmingView.alpha = 0
        let coordinator = presentedViewController.transitionCoordinator
        coordinator?.animate(alongsideTransition: { [weak self] (_) in
            self?.dimmingView.alpha = 0.5
        }, completion: nil)
    }
    
    override func dismissalTransitionWillBegin() {
        let coordinator = presentedViewController.transitionCoordinator
        coordinator?.animate(alongsideTransition: { [weak self] (_) in
            self?.dimmingView.alpha = 0
        }, completion: nil)
    }
    
    override func dismissalTransitionDidEnd(_ completed: Bool) {
        if completed {
            dimmingView.removeFromSuperview()
        }
    }
    
    @objc func onTap(_ gesture: UITapGestureRecognizer) {
        presentedViewController.dismiss(animated: true, completion: nil)
    }
    
    func handlePan(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: containerView)
        let velocity = gesture.velocity(in: containerView)
        switch gesture.state {
        case .began:
            defaultY = presentedView?.frame.origin.y ?? 0
        case .changed:
            var frame = presentedView?.frame ?? .zero
            let newY = max(frame.origin.y + translation.y, defaultY)
            frame.origin.y = newY
            presentedView?.frame = frame
        case .cancelled, .ended, .failed:
            if velocity.y > 200 {
                presentedViewController.dismiss(animated: true, completion: nil)
            } else {
                let offsetY = abs(presentedView!.frame.origin.y - defaultY)
                if offsetY > presentedView!.bounds.height / 2 {
                    presentedViewController.dismiss(animated: true, completion: nil)
                } else {
                    var frame = presentedView?.frame ?? .zero
                    let progress = offsetY * 2 / presentedView!.frame.height
                    frame.origin.y = defaultY
                    UIView.animate(withDuration: TimeInterval(0.3 * progress)) {
                        self.presentedView?.frame = frame
                    }
                }
            }
            
        default:
            break
        }
        gesture.setTranslation(.zero, in: containerView)
    }
    
    private func configureDimmingView() {
        dimmingView.backgroundColor = .gray
        let tap = UITapGestureRecognizer(target: self, action: #selector(onTap(_:)))
        dimmingView.addGestureRecognizer(tap)
    }
    
    private func adjustDimmingViewFrame() {
        guard let containerView = containerView else { return }
        dimmingView.frame = containerView.bounds
    }
}

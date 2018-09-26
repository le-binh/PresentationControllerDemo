//
//  ViewController.swift
//  PresentationControllerDemo
//
//  Created by Binh Le on 9/26/18.
//  Copyright © 2018 Binh Le. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    @IBAction func goRed(_ sender: Any?) {
        let redViewController = RedViewController(nibName: "RedViewController", bundle: nil)
        redViewController.modalPresentationStyle = .custom
        redViewController.transitioningDelegate = self
        present(redViewController, animated: true, completion: nil)
    }
}

extension ViewController: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return PresentationController(presentedViewController: presented, presenting: presenting)
    }
}

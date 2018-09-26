//
//  RedViewController.swift
//  PresentationControllerDemo
//
//  Created by Binh Le on 9/26/18.
//  Copyright © 2018 Binh Le. All rights reserved.
//

import UIKit

class RedViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: "Cell")
    }
    
    @IBAction func onPan(_ sender: UIPanGestureRecognizer) {
        let presentationController = self.presentationController as? PresentationController
        presentationController?.handlePan(sender)
    }
}

extension RedViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 50
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = "Item \(indexPath.row)"
        return cell
    }
}

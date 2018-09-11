//
//  ToggleConstraintsViewController.swift
//  TryXcode10
//
//  Created by satoutakeshi on 2018/08/23.
//  Copyright © 2018年 Personal Factory. All rights reserved.
//

import UIKit
import os.signpost

class ToggleConstraintsViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        registerCell()
    }

    func registerCell() {
        tableView.register(UINib(nibName: "RemoveConstraintCell", bundle: nil), forCellReuseIdentifier: "cell")
    }

    @IBAction func refresh(_ sender: UIBarButtonItem) {
        
        let signpostID = OSSignpostID(log: OSLog.toggleConstraints)
        os_signpost(.begin,
                    log: OSLog.toggleConstraints,
                    name: "reload data",
                    signpostID: signpostID,
                    "%s", self.description)
        tableView.reloadData()
        os_signpost(.end,
                    log: OSLog.toggleConstraints,
                    name: "reload data",
                    signpostID: signpostID,
                    "%s", "end")
    }
}

extension ToggleConstraintsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 30
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell") else {
            return UITableViewCell()
        }

        return cell
    }


}

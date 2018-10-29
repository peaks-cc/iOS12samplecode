//
//  RemoveConstraintsViewController.swift
//  TryXcode10
//
//  Created by satoutakeshi on 2018/08/23.
//  Copyright © 2018年 Personal Factory. All rights reserved.
//

import UIKit
import os.signpost

class RemoveConstraintsViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
        registerCell()
    }

    func registerCell() {
        tableView.register(UINib(nibName: "RemoveConstraintCell", bundle: nil), forCellReuseIdentifier: "RemoveConstraintCell")
    }
    @IBAction func refresh(_ sender: UIBarButtonItem) {

        let signpostID = OSSignpostID(log: removeConstraintsLog)
        os_signpost(.begin,
                    log: removeConstraintsLog,
                    name: "reload data",
                    signpostID: signpostID,
                    "%s", self.description)
        tableView.reloadData()
        os_signpost(.end,
                    log: removeConstraintsLog,
                    name: "reload data",
                    signpostID: signpostID,
                    "%s", "end")
    }
}

extension RemoveConstraintsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 30
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "RemoveConstraintCell") as? RemoveConstrainTableViewCell else {
            return UITableViewCell()
        }

        return cell
    }
}



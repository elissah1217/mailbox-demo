//
//  MessageListViewController.swift
//  mailbox demo
//
//  Created by Hsin Yi Huang on 5/21/15.
//  Copyright (c) 2015 Hsin Yi Huang. All rights reserved.
//

import UIKit

class MessageListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{
    

    @IBOutlet weak var messageTableView: UITableView!
    //let data = ["New York, NY",  "Fort Worth, TX"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        messageTableView.dataSource = self
        messageTableView.delegate = self

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("com.hy.MessageTableViewCell", forIndexPath: indexPath) as MessageTableViewCell
        //let cityState = data[indexPath.row].componentsSeparatedByString(", ")

        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    

}

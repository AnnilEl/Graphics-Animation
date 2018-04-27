//
//  MainTableViewController.swift
//  Graphics&Animation
//
//  Created by CharlieW on 2018/4/25.
//  Copyright © 2018年 CharlieW. All rights reserved.
//

import UIKit

class MainTableViewController: UITableViewController {

    
    let examples: [String] = [ "UIKitDynamics","CoreImage","DynamicsTossing"]
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return examples.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let id = "reuseIdentifier"
        var cell = tableView.dequeueReusableCell(withIdentifier: id)
        if cell == nil {
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: id)
        }
        cell?.textLabel?.text = examples[indexPath.row]
        return cell!
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        var nextVC: UIViewController!
        
        switch indexPath.row {
        case 0:
            nextVC = DynamicsViewController()

        case 1:
            nextVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CoreImageViewController")
       
        case 2:
            nextVC = DynamicsTossingVC()
        default:
            return
        }
        navigationController?.pushViewController(nextVC, animated: true)

    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

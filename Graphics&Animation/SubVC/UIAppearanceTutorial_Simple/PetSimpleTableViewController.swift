//
//  PetSimpleTableViewController.swift
//  Graphics&Animation
//
//  Created by CharlieW on 2018/4/27.
//  Copyright © 2018年 CharlieW. All rights reserved.
//

import UIKit

struct Pet {
    var name = ""
    var type = ""
}

let pets =  [
    Pet(name: "Rusty", type: "Golder Retriever"),
    Pet(name: "Max", type: "Mixed Terrier"),
    Pet(name: "Lucifer", type: "Freaked Out"),
    Pet(name: "Tiger", type: "Sensitive Whiskers"),
    Pet(name: "Widget", type: "Mouse Catcher"),
    Pet(name: "Wiggles", type: "Border Collie"),
    Pet(name: "Clover", type: "Mixed Breed"),
    Pet(name: "Snow White", type: "Black Cat"),
]

class PetSimpleTableViewController: UITableViewController, UIPopoverPresentationControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let titleImgView = UIImageView(image: UIImage(named: "catdog"))
        titleImgView.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        titleImgView.contentMode = .scaleAspectFit
        navigationItem.titleView = titleImgView
        
        let searchBtn = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(search))
        navigationItem.rightBarButtonItem = searchBtn
        
        let settingsBtn = UIBarButtonItem(image: UIImage(named: "settings"), style: .plain, target: self, action: #selector(settings))
        navigationItem.leftBarButtonItem = settingsBtn
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    // MARK: -- search
    
    @objc fileprivate func search() {
        let searchVC = UIStoryboard(name: "AppearanceSimple", bundle: nil).instantiateViewController(withIdentifier: "SearchSimpleTableViewController")
        searchVC.modalTransitionStyle = .coverVertical
        searchVC.modalPresentationStyle = .popover
        searchVC.popoverPresentationController?.delegate = self
        present(searchVC, animated: true, completion: nil)
    }
    
    // MARK: -- settings
    @objc fileprivate func settings() {
        let settingsVC = UIStoryboard(name: "AppearanceSimple", bundle: nil).instantiateViewController(withIdentifier: "SettingsSimpleTableViewController")
        settingsVC.modalTransitionStyle = .coverVertical
        settingsVC.modalPresentationStyle = .popover
        settingsVC.popoverPresentationController?.delegate = self
        present(settingsVC, animated: true, completion: nil)
    }

    
    // MARK: -- Popover
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .overCurrentContext
    }
    
    func presentationController(_ controller: UIPresentationController, viewControllerForAdaptivePresentationStyle style: UIModalPresentationStyle) -> UIViewController? {
        let navController = UINavigationController(rootViewController: controller.presentedViewController)
        return navController
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pets.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PetCell", for: indexPath)
        cell.imageView!.image = UIImage(named: "pet\(indexPath.row)")
        cell.imageView!.layer.masksToBounds = true
        cell.imageView!.layer.cornerRadius = 5
        
        cell.detailTextLabel!.text = pets[indexPath.row].type
        
        cell.textLabel!.text = pets[indexPath.row].name
        return cell
    }

    // MARK: -- Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowPet" {
            let selectedPetIndex = tableView.indexPath(for: sender as! UITableViewCell)!.row
            (segue.destination as! PetSimpleViewController).petIndex = selectedPetIndex
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

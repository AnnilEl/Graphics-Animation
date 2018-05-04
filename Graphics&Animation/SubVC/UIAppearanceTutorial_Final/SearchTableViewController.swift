//
//  SearchSimpleTableViewController.swift
//  Graphics&Animation
//
//  Created by CharlieW on 2018/4/27.
//  Copyright © 2018年 CharlieW. All rights reserved.
//

import UIKit

class SearchTableViewController: UITableViewController, UITextFieldDelegate {

    @IBOutlet weak var nameTextField: UITextField!
    
    @IBOutlet weak var numberOfPawsLabel: UILabel!
    
    
    @IBOutlet weak var distanceLabel: UILabel!

    @IBOutlet weak var searchProgress: UIProgressView!
    
    @IBOutlet weak var pawStepper: UIStepper!
    
    @IBOutlet weak var searchButton: UIButton!
    
    @IBOutlet weak var distanceSlider: UISlider!
    
    @IBOutlet weak var speciesSelector: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .done, target: self, action: #selector(dismissVC))
        
        
    }
    @objc fileprivate func dismissVC() {
        self.dismiss(animated: true, completion: nil)
    }
    
    fileprivate func hideKeyboard() {
        nameTextField.resignFirstResponder()
    }
    
    override func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        hideKeyboard()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        hideKeyboard()
        return true
    }
    
    @IBAction func updateDistance(_ sender: UISlider) {
        distanceLabel.text = "\(Int(sender.value)) miles"
    }
    
    @IBAction func updateNumberOfPaws(_ sender: UIStepper) {
        numberOfPawsLabel.text = "\(Int(sender.value)) paws"
    }
    
    @IBAction func search(_ sender: UIButton) {
        UIView.animate(withDuration: 5.0, animations: {
            self.searchProgress.setProgress(1.0, animated: true)
            self.view.alpha = 0.7
        }) { (finished) in
            if finished {
                self.dismissVC()
            }
        }
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }



}

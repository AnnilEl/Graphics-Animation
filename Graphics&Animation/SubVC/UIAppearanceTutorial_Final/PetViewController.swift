//
//  PetSimpleViewController.swift
//  Graphics&Animation
//
//  Created by CharlieW on 2018/4/27.
//  Copyright © 2018年 CharlieW. All rights reserved.
//

import UIKit

class PetViewController: UIViewController {
  
    @IBOutlet weak var petImageView: UIImageView!
    var petIndex: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Adopt", style: .plain, target: self, action: #selector(adopt))
        title = pets_final[petIndex].name
        
        petImageView.image = UIImage(named: "pet\(petIndex)")

    }
    
    @objc fileprivate func adopt() {
        performSegue(withIdentifier: "ShowAdopt", sender: self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

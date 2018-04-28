//
//  DynamicsViewController.swift
//  Graphics&Animation
//
//  Created by CharlieW on 2018/4/25.
//  Copyright © 2018年 CharlieW. All rights reserved.
//

import UIKit

class DynamicsViewController: UIViewController, UICollisionBehaviorDelegate {
    
    var animtor: UIDynamicAnimator!
    var gravity: UIGravityBehavior!
    var collision: UICollisionBehavior!
    lazy var square:UIView = {
        let squareView = UIView(frame: CGRect(x: 100, y: 100, width: 100, height: 100))
        squareView.backgroundColor = .orange
        view.addSubview(squareView)
        return squareView
    }()
    
    lazy var barrier: UIView = {
        let  tempView = UIView(frame: CGRect(x: 0, y: 300, width: 130, height: 20))
        tempView.backgroundColor = .red
        
        view.addSubview(tempView)
        return tempView
    }()
    
    var firstContact = false
    
    var snp: UISnapBehavior!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        animtor = UIDynamicAnimator(referenceView: view)
        gravity = UIGravityBehavior(items: [square])
        animtor.addBehavior(gravity)
        collision = UICollisionBehavior(items: [square])
        collision.addBoundary(withIdentifier: "barrier" as NSCopying, for: UIBezierPath(rect: barrier.frame))
        collision.translatesReferenceBoundsIntoBoundary = true
        animtor.addBehavior(collision)
        collision.collisionDelegate = self
        


/**

         elasticity - 决定“弹性”碰撞的方式，即物体在碰撞中的弹性或“橡胶状”程度。
         friction - 决定沿表面滑动时的运动阻力。
         density - 当与大小相结合时，这将给出物品的整体质量。质量越大，加速或减速物体越难。
         resistance - 决定抵抗任何线性移动的数量。这与仅适用于滑动运动的摩擦形成对比。
         angularResistance - 确定抵抗任何旋转运动的量。
         allowsRotation - 如果将此属性设置为NO，则不管发生的旋转力如何，对象都不会旋转。
 
 */
        let itemBehaviour = UIDynamicItemBehavior(items: [square])
        itemBehaviour.elasticity = 0.6
        animtor.addBehavior(itemBehaviour)
        
        addPosition()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if snp != nil {
            animtor.removeBehavior(snp)
        }
        let touchs = touches as NSSet
        
        let touch = touchs.anyObject() as! UITouch
        snp = UISnapBehavior(item: square, snapTo: touch.location(in: view))
        animtor.addBehavior(snp)
    }
    
    func addPosition()  {
        var updateCount = 0
        collision.action = {
            if updateCount % 3 == 0 {
                let outLine = UIView(frame: self.square.bounds)
                outLine.transform = self.square.transform
                outLine.center = self.square.center
                
                outLine.alpha = 0.5
                outLine.backgroundColor = .clear
                outLine.layer.borderColor = self.square.layer.presentation()?.backgroundColor
                outLine.layer.borderWidth = 1.0
                self.view.addSubview(outLine)
            }
            updateCount += 1
        }
    }
    func collisionBehavior(_ behavior: UICollisionBehavior, beganContactFor item: UIDynamicItem, withBoundaryIdentifier identifier: NSCopying?, at p: CGPoint) {
        print("Boundary contact occurred - \(String(describing: identifier))")
        
        let collidingView = item as! UIView
        UIView.animate(withDuration: 1) {
            collidingView.backgroundColor = .gray
        }
        
        if !firstContact {
            firstContact = true

            let square = UIView(frame: CGRect(x: 30, y: 0, width: 100, height: 100))
            square.backgroundColor = .gray
            view.addSubview(square)
            collision.addItem(square)
            gravity.addItem(square)
            let attach = UIAttachmentBehavior(item: collidingView, attachedTo: square)
            animtor.addBehavior(attach)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}




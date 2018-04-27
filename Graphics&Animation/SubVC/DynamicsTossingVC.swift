//
//  DynamicsTossingVC.swift
//  Graphics&Animation
//
//  Created by CharlieW on 2018/4/27.
//  Copyright © 2018年 CharlieW. All rights reserved.
//

import UIKit

class DynamicsTossingVC: UIViewController {
    
    @IBOutlet weak var imgView: UIImageView!
    
    @IBOutlet weak var redSquare: UIView!
    
    @IBOutlet weak var blueSquare: UIView!
    
    private var originalBounds = CGRect.zero
    private var originalCenter = CGPoint.zero
    
    private var animator: UIDynamicAnimator!
    private var attachmentBehavior: UIAttachmentBehavior!
    private var pushBehavior: UIPushBehavior!
    private var itemBehavior: UIDynamicItemBehavior!
    
    let ThrowingThreshold: CGFloat = 1000
    let ThrowingVelocityPadding: CGFloat = 35
    
    @IBAction func handleAttachmentGesture(_ sender: UIPanGestureRecognizer) {
        let location = sender.location(in: self.view)
        let boxLocation = sender.location(in: self.imgView)
        switch sender.state {
        case .began:
            print("Touch start position is \(location)")
            print("Start location in image is \(boxLocation)")
            // 删除可能存在的任何现有动画行为。
            animator.removeAllBehaviors()
            // 创建一个UIAttachmentBehavior，它将图像视图中的点附加到用户点击一个锚点（碰巧是完全相同的点）。 稍后，更改定位点使图像视图移动。
            // 将锚点附加到视图就像安装一个将锚点连接到视图上的固定附件位置的不可见杆。
            let centerOffset = UIOffset(horizontal: boxLocation.x - imgView.bounds.midX, vertical: boxLocation.y - imgView.bounds.midY)
            attachmentBehavior = UIAttachmentBehavior(item: imgView, offsetFromCenter: centerOffset, attachedToAnchor: location)
            // 更新红色方块以指示定位点，并使用蓝色方块来指示图像视图内所附的点。 当手势开始时，这些将是相同的点。
            redSquare.center = attachmentBehavior.anchorPoint
            blueSquare.center = location
            // 将此行为添加到动画器以使其生效。
            animator.addBehavior(attachmentBehavior)
        case .ended:
            print("Touch end position is \(location)")
            print("End location in image is \(boxLocation)")
//            resetDemo()
            animator.removeAllBehaviors()
            // 获取手势的拖动速度。
            // 计算速度的大小 - 这是由x方向速度和y方向速度形成的三角形的斜边。
            
            // 要理解这个背后的理论，请查看这个Trigonometry for Game Programming教程。
            let velocity = sender.velocity(in: view)
            let magnitude = sqrt(velocity.x * velocity.x + velocity.y * velocity.y)
            
            if magnitude > ThrowingThreshold {
                // 假设手势速度超过为动作设置的最小阈值，则设置push行为。
                // 所需的方向由x和y速度组成，并转换为一个给定方向部分的向量。 一旦设置了推送行为，就将其添加到动画序列中。
                let pushBehavior = UIPushBehavior(items: [imgView], mode: .instantaneous)
                pushBehavior.pushDirection = CGVector(dx: velocity.x / 10, dy: velocity.y / 10)
                pushBehavior.magnitude = magnitude / ThrowingVelocityPadding
                
                self.pushBehavior = pushBehavior
                animator.addBehavior(pushBehavior)
                
                // 本部分设置了一些旋转以使图像“飞走”。 在这里阅读复杂的计算。
                // 其中一些取决于手指在启动手势时距离手指边缘的距离。
                
                // 调整这块的value，观察运动如何改变效果。
                let angle = Int(arc4random_uniform(20)) - 10
                
                itemBehavior = UIDynamicItemBehavior(items: [imgView])
                itemBehavior.friction = 0.2
                itemBehavior.allowsRotation = true
                itemBehavior.addAngularVelocity(CGFloat(angle), for: imgView)
                animator.addBehavior(itemBehavior)
                
                // 在指定的时间间隔之后，动画通过将图像发送回目的地进行重置，所以它会缩回并返回到屏幕 - 就像球从墙上弹起一样
                let timeOffset = Int(0.4 * Double(NSEC_PER_SEC))
                DispatchQueue.main.asyncAfter(deadline: DispatchTime
                    .now() + DispatchTimeInterval.seconds(timeOffset)) {
                    self.resetDemo()
                }
            } else {
                resetDemo()
            }
        default:
            attachmentBehavior.anchorPoint = sender.location(in: view)
            redSquare.center = attachmentBehavior.anchorPoint
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        animator = UIDynamicAnimator(referenceView: view)
        originalBounds = imgView.bounds
        originalCenter = imgView.center
    }
    
    fileprivate func resetDemo() {
        animator.removeAllBehaviors()
        UIView.animate(withDuration: 0.5) {
            self.imgView.bounds = self.originalBounds
            self.imgView.center = self.originalCenter
            self.imgView.transform = CGAffineTransform.identity
        }
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


//
//  GlobalProperties.swift
//  Graphics&Animation
//
//  Created by CharlieW on 2018/4/25.
//  Copyright © 2018年 CharlieW. All rights reserved.
//

import UIKit
// MARK: --屏幕属性

/// 宽
let SCREENWIDTH: CGFloat = UIScreen.main.bounds.size.width
/// 高
let SCREENHEIGHT: CGFloat = UIScreen.main.bounds.size.height
/// 中心点
let SCREENCENTER: CGPoint = CGPoint(x: SCREENWIDTH / 2.0, y: SCREENHEIGHT / 2.0)
/// iphoneX
let isIphoneX: Bool = (SCREENHEIGHT == CGFloat(812) && SCREENWIDTH == CGFloat(375))
/// 导航栏高度
let NavgationBarHeight: CGFloat = isIphoneX ? 88 : 64

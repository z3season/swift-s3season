//
//  Const.swift
//  SwiftS3season
//
//  Created by mula on 2021/7/26.
//

import UIKit

let SCREEN_HEIGHT = UIScreen.main.bounds.size.height
let SCREEN_WIDTH = UIScreen.main.bounds.size.width

let IS_IPHONEX_ALL: Bool = (SCREEN_HEIGHT == 812 || SCREEN_WIDTH == 896)
//导航栏高
let NAVIGATION_BAR_HEIGHT = (IS_IPHONEX_ALL ? 88 : 64)
//状态栏高
let STATUS_HEIGHT = (IS_IPHONEX_ALL ? 44 : 20)
// 底部安全距离
let BOTTOM_SAFE_HEIGHT = (IS_IPHONEX_ALL ? 34 : 0)


// rgb颜色
func RGBCOLOR(r:CGFloat,_ g:CGFloat,_ b:CGFloat) -> UIColor {UIColor(red: (r) / 255.0, green: (g) / 255.0, blue: (b) / 255.0, alpha: 1.0)}
// rgba颜色
func RGBACOLOR(r: CGFloat, _ g: CGFloat, _ b: CGFloat, _ a: CGFloat = 1.0) -> UIColor {UIColor(red: (r) / 255.0, green: (g) / 255.0, blue: (b) / 255.0, alpha: a)}

// 设计图的宽高
fileprivate let UI_WIDTH: CGFloat = 375.0
fileprivate let UI_HEIGHT: CGFloat = 667.0

// 宽度比例
func SCALE_WIDTH(_ font:CGFloat) -> (CGFloat) { (SCREEN_WIDTH / UI_WIDTH) * font }
// 高度比例
func SCALE_HEIGHT(_ font:CGFloat) -> (CGFloat) { SCREEN_HEIGHT / UI_HEIGHT * font }
// 字体比例
func SCALE_FONT(_ font:CGFloat) -> (CGFloat) { SCREEN_WIDTH / UI_WIDTH * font }


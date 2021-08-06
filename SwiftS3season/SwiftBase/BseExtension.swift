//
//  BseExtensionProtocol.swift
//  SwiftS3season
//
//  Created by season on 2021/7/24.
//

import UIKit
import Foundation

// MARK: 扩展 extension
/**
    
 扩展作用：
 1,添加计算型实例属性和计算型类属性
 2,定义实例方法和类方法
 3,提供新的构造器
 4,定义下标
 5,定义和使用新的嵌套类型
 6,使已经存在的类型遵循（conform）一个协议

 语法：
 extension SomeType {
   // 在这里给 SomeType 添加新的功能
 }

 extension SomeType: SomeProtocol, AnotherProtocol {
   // 协议所需要的实现写在这里
 }

 */

// MARK: 扩展 计算型属性
extension Double {
    var km: Double { return self * 1_000.0 }
    var m: Double { return self }
    var cm: Double { return self / 100.0 }
    var mm: Double { return self / 1_000.0 }
    var ft: Double { return self / 3.28084 }
}
struct MySize {
    var width = 0.0, height = 0.0
}
struct MyPoint {
    var x = 0.0, y = 0.0
}
struct MyRect {
    var origin = MyPoint()
    var size = MySize()
}

// MARK: 扩展 构造器
extension MyRect {
    init(center: MyPoint, size: MySize) {
        let originX = center.x - (size.width / 2)
        let originY = center.y - (size.height / 2)
        self.init(origin: MyPoint(x: originX, y: originY), size: size)
    }
}

// MARK: 扩展 方法
extension Int {
    func repetitions(task: () -> Void) {
        for _ in 0..<self {
            task()
        }
    }
}

// MARK: 扩展 可变实例方法 使用关键字 mutating
extension Int {
    mutating func square() {
        self = self * self
    }
}

// MARK: 扩展 下标
extension Int {
    subscript(digitIndex: Int) -> Int {
        var decimalBase = 1
        for _ in 0..<digitIndex {
            decimalBase *= 10
        }
        return (self / decimalBase) % 10
    }
}

// MARK: 扩展 嵌套类型
extension Int {
    enum Kind {
        case negative, zero, positive
    }
    var kind: Kind {
        switch self {
        case 0:
            return .zero
        case let x where x > 0:
            return .positive
        default:
            return .negative
        }
    }
}

class BseExtension: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 使用扩展
        let oneInch = 25.4.mm
        print("One inch is \(oneInch) meters")
        // 打印“One inch is 0.0254 meters”
        let threeFeet = 3.ft
        print("Three feet is \(threeFeet) meters")
        // 打印“Three feet is 0.914399970739201 meters”

        var someInt = 3
        someInt.square()
        // someInt 现在是 9
    
        printIntegerKinds([3, 19, -27, 0, -6, 0, 7])
        // 打印“+ + - 0 - 0 + ”
    }
    
    func printIntegerKinds(_ numbers: [Int]) {
        for number in numbers {
            switch number.kind {
            case .negative:
                print("- ", terminator: "")
            case .zero:
                print("0 ", terminator: "")
            case .positive:
                print("+ ", terminator: "")
            }
        }
        print("")
    }
}

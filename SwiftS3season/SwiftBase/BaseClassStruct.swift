//
//  BaseClassStruct.swift
//  SwiftS3season
//
//  Created by mula on 2021/7/23.
//

import UIKit

/**
 
 Swift 中结构体和类有很多共同点。
 
 两者都可以：
 class、struct ->:
 定义属性用于存储值:
 定义方法用于提供功能
 定义下标操作用于通过下标语法访问它们的值
 定义构造器用于设置初始值
 通过扩展以增加默认实现之外的功能
 遵循协议以提供某种标准功能
 
 与结构体相比，类还有如下的附加功能：
 class->
 继承允许一个类继承另一个类的特征
 类型转换允许在运行时检查和解释一个类实例的类型
 析构器允许一个类实例释放任何其所被分配的资源
 引用计数允许对一个类的多次引用
 */

// MARK: 结构体和枚举是值类型 类是引用类型

struct Point {
    var x = 0.0, y = 0.0
}
struct Size {
    var width = 0.0, height = 0.0
}
struct Rect11 {
    var origin = Point()
    var size = Size()
    // MARK: 计算属性
    var center: Point {
        get {
            let centerX = origin.x + (size.width / 2)
            let centerY = origin.y + (size.height / 2)
            return Point(x: centerX, y: centerY)
        }
        set(newCenter) {
            origin.x = newCenter.x - (size.width / 2)
            origin.y = newCenter.y - (size.height / 2)
        }
        // 可简化计算数学 get set
        /*
         get {
             Point(x: origin.x + (size.width / 2),
                   y: origin.y + (size.height / 2))
         }
         set {
             origin.x = newValue.x - (size.width / 2)
             origin.y = newValue.y - (size.height / 2)
         }
         */
        
    }
}

struct Cuboid {
    var width = 0.0, height = 0.0, depth = 0.0
    // MARK: 只读计算数学 省略了get
    var volume: Double {
        return width * height * depth
    }
}

class StepCounter {
    // MARK: 属性观察器
    var totalSteps: Int = 0 {
        willSet(newTotalSteps) {
            print("将 totalSteps 的值设置为 \(newTotalSteps)")
        }
        didSet {
            if totalSteps > oldValue  {
                print("增加了 \(totalSteps - oldValue) 步")
            }
        }
    }
}

// MARK: 属性包装器
@propertyWrapper
struct SmallNumber {
    private var maximum: Int
    private var number: Int
    var projectedValue = false

    var wrappedValue: Int {
        get { return number }
        set {
            if newValue > 12 {
                number = 12
                projectedValue = true
            } else {
                number = newValue
                projectedValue = false
            }
        }
    }

    // MARK: 设置被包装属性的初始值
    init() {
        maximum = 12
        number = 0
    }
    init(wrappedValue: Int) {
        maximum = 12
        number = min(wrappedValue, maximum)
    }
    init(wrappedValue: Int, maximum: Int) {
        self.maximum = maximum
        number = min(wrappedValue, maximum)
    }
}

class BaseClassStruct: BaseViewController {
    
    // MARK: 延时加载存储属性
    // 全局的常量或变量都是延迟计算的，跟延时加载存储属性相似，不同的地方在于，全局的常量或变量不需要标记 lazy 修饰符。
    lazy var importer = SomeClass()
    
    // MARK: 使用属性包装器
    // 可以在局部存储型变量上使用属性包装器，但不能在全局变量或者计算型变量上使用
    @SmallNumber var height1: Int
    // 设置默认值
    @SmallNumber var width: Int = 1
    // 设置检查值 最大值max
    @SmallNumber(maximum: 14) var height2: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let stepCounter = StepCounter()
        stepCounter.totalSteps = 200
        // 将 totalSteps 的值设置为 200
        // 增加了 200 步
        stepCounter.totalSteps = 360
        // 将 totalSteps 的值设置为 360
        // 增加了 160 步
        stepCounter.totalSteps = 896
        // 将 totalSteps 的值设置为 896
        // 增加了 536 步

        // MARK: $+属性可以访问从属性包装器中呈现的一个值（projectedValue）
        print($height1); // false
        
    }
    
}

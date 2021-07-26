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
    
    // MARK: 指定构造器 便利构造器convenience
    // 每一个类都必须至少拥有一个指定构造器。在某些情况下，许多类通过继承了父类中的指定构造器而满足了这个条件
    
    /**
     为了简化指定构造器和便利构造器之间的调用关系，Swift 构造器之间的代理调用遵循以下三条规则：
     规则 1
         指定构造器必须调用其直接父类的的指定构造器。
     规则 2
         便利构造器必须调用同类中定义的其它构造器。
     规则 3
         便利构造器最后必须调用指定构造器。
     */
    convenience init(name: String, desc: String) {
        self.init();
    }
    
}

class SubStepCounter: StepCounter {
    convenience init(name: String) {
        // MARK: 报错 不能指向父类的便利构造器跟指定构造器
//        super.init(name: "", desc: "");
        self.init()
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

class Residence {
    var rooms: [Int] = []
    var numberOfRooms: Int {
        return rooms.count
    }
    // MARK: subscript 下标访问
    subscript(i: Int) -> Int {
        get {
            return rooms[i]
        }
        set {
            rooms[i] = newValue
        }
    }
    func printNumberOfRooms() {
        print("The number of rooms is \(numberOfRooms)")
    }
    var address: Int?
}

class BaseClassStruct: BaseViewController {
    
    // MARK: 延时加载存储属性
    // 全局的常量或变量都是延迟计算的，跟延时加载存储属性相似，不同的地方在于，全局的常量或变量不需要标记 lazy 修饰符。
    lazy var importer = SomeClass()
    lazy var array: NSArray = {
        let names = NSArray()
        print("只在首次访问输出")
        return names
    }();
    
    // MARK: 使用属性包装器
    // 可以在局部存储型变量上使用属性包装器，但不能在全局变量或者计算型变量上使用
    @SmallNumber var height1: Int
    // 设置默认值
    @SmallNumber var width: Int = 1
    // 设置检查值 最大值max
    @SmallNumber(maximum: 14) var height2: Int = 0
    
    // 重写父类方法
    override func setNavBackBtn() {
        
    }

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
        
        // MARK: lazy懒加载数组 map
        // 只有当访问数组成员时才会去初始化数组的某个成员
        let data = 1...3
        let result = data.lazy.map {
            (i: Int) -> Int in
            print("正在处理 \(i)")
            return i * 2
        }

        print("准备访问结果")
        for i in result {
            print("操作后结果为 \(i)")
        }

        print("操作完毕")

    }
    
    // MARK: 类型转换 （as? 或 as!）
    // 某类型的一个常量或变量可能在幕后实际上属于一个子类。当确定是这种情况时，你可以尝试用类型转换操作符（as? 或 as!）向下转到它的子类型
 
    
    // MARK: Any 和 AnyObject 的类型转换
    /**
     Any 可以表示任何类型，包括函数类型。

     AnyObject 可以表示任何类类型的实例。
     */
    
    func anyAnyObject() {
        var things: [Any] = []
        
        things.append(0)
        things.append(0.0)
        things.append(42)
        things.append(3.14159)
        things.append("hello")
        things.append((3.0, 5.0))
        things.append(Point(x: 1, y: 2))
        things.append({ (name: String) -> String in "Hello, \(name)" })

        for thing in things {
            switch thing {
            case 0 as Int:
                print("zero as an Int")
            case 0 as Double:
                print("zero as a Double")
            case let someInt as Int:
                print("an integer value of \(someInt)")
            case let someDouble as Double where someDouble > 0:
                print("a positive double value of \(someDouble)")
            case is Double:
                print("some other double value that I don't want to print")
            case let someString as String:
                print("a string value of \"\(someString)\"")
            case let (x, y) as (Double, Double):
                print("an (x, y) point at \(x), \(y)")
            case let point as Point:
                print("a movie called \(point.x), dir. \(point.y)")
            case let stringConverter as (String) -> String:
                print(stringConverter("Michael"))
            default:
                print("something else")
            }
        }

        
    }
    
}

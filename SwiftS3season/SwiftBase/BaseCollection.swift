//
//  BaseCollection.swift
//  SwiftS3season
//
//  Created by mula on 2021/7/22.
//

//https://swiftgg.gitbook.io/swift/swift-jiao-cheng/05_control_flow
import UIKit

// 集合类型 控制流 函数
class BaseCollection: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        baseOprate()
        dic()
    }
    
    // MARK: 数组 Array 集合 Set
    var someInts: [Int] = Array()
    var threeDoubles = Array(repeating: 0.0, count: 3)
    var anotherThreeDoubles = Array(repeating: 2.5, count: 3)
    // anotherThreeDoubles 被推断为 [Double]，等价于 [2.5, 2.5, 2.5]

    func baseOprate() {
        someInts.append(3)
        print("someInts is of type [Int] with \(someInts.count) items.")
        
        let sixDoubles = threeDoubles + anotherThreeDoubles
        // sixDoubles 被推断为 [Double]，等价于 [0.0, 0.0, 0.0, 2.5, 2.5, 2.5]
        print(sixDoubles)
        
        var shoppingList = ["1", "2", "3", "4", "5", "6", "7"];
        shoppingList[4...6] = ["Bananas", "Apples"]
        // ["1", "2", "3", "4", "Bananas", "Apples"]
        print(shoppingList)
    }
    
    // MARK: 集合操作
    /**
     使用 intersection(_:) 方法根据两个集合的交集创建一个新的集合。
     使用 symmetricDifference(_:) 方法根据两个集合不相交的值创建一个新的集合。
     使用 union(_:) 方法根据两个集合的所有值创建一个新的集合。
     使用 subtracting(_:) 方法根据不在另一个集合中的值创建一个新的集合。
     */
    
    // MARK: 集合成员关系和相等
    /**
     使用“是否相等”运算符（==）来判断两个集合包含的值是否全部相同。
     使用 isSubset(of:) 方法来判断一个集合中的所有值是否也被包含在另外一个集合中。
     使用 isSuperset(of:) 方法来判断一个集合是否包含另一个集合中所有的值。
     使用 isStrictSubset(of:) 或者 isStrictSuperset(of:) 方法来判断一个集合是否是另外一个集合的子集合或者父集合并且两个集合并不相等。
     使用 isDisjoint(with:) 方法来判断两个集合是否不含有相同的值（是否没有交集）。
     */
    
    // MARK: 字典 Dictionary
    // 空字典
    var namesOfIntegers: [Int: String] = [:]
    var airports: [String: String] = ["YYZ": "Toronto Pearson", "DUB": "Dublin"]

    func dic() {
        
        // updateValue(_:forKey:) 方法会返回对应值类型的可选类型
        if let oldValue = airports.updateValue("Dublin Airport", forKey: "DUB") {
            print("The old value for DUB was \(oldValue).")
        }

        airports["APL"] = "Apple Internation"
        // “Apple Internation”不是真的 APL 机场，删除它
        airports["APL"] = nil
        // APL 现在被移除了
        
        if let removedValue = airports.removeValue(forKey: "DUB") {
            print("The removed airport's name is \(removedValue).")
        } else {
            print("The airports dictionary does not contain a value for DUB.")
        }

        // MARK: 遍历
        for (airportCode, airportName) in airports {
            print("\(airportCode): \(airportName)")
        }
        
        for airportCode in airports.keys {
            print("Airport code: \(airportCode)")
        }
        
        for airportName in airports.values {
            print("Airport name: \(airportName)")
        }

    }
    
    // MARK: 控制语句
    func control() {
        
        // MARK: switch
        let anotherCharacter: Character = "a"
        switch anotherCharacter {
        case "a", "A":
            print("The letter A")
        default:
            print("Not the letter A")
        }

        // MARK: 区间匹配
        let approximateCount = 62
        let countedThings = "moons orbiting Saturn"
        let naturalCount: String
        switch approximateCount {
        case 0:
            naturalCount = "no"
        case 1..<5:
            naturalCount = "a few"
        case 5..<12:
            naturalCount = "several"
        case 12..<100:
            naturalCount = "dozens of"
        case 100..<1000:
            naturalCount = "hundreds of"
        default:
            naturalCount = "many"
        }
        print("There are \(naturalCount) \(countedThings).")
        // 输出“There are dozens of moons orbiting Saturn.”
        
        // 元祖
        let somePoint = (1, 1)
        switch somePoint {
        case (0, 0):
            print("\(somePoint) 原点")
        case (_, 0):
            print("\(somePoint) 在x轴")
        case (0, _):
            print("\(somePoint) 在y轴")
        case (-2...2, -2...2):
            print("\(somePoint) 在区域内")
        default:
            print("\(somePoint) 区域外")
        }
        
        // 元祖值绑定
        let anotherPoint = (2, 0)
        switch anotherPoint {
        case (let x, 0):
            print("on the x-axis with an x value of \(x)")
        case (0, let y):
            print("on the y-axis with a y value of \(y)")
        case let (x, y):
            print("somewhere else at (\(x), \(y))")
        }

        // MARK: case 分支的模式可以使用 where 语句来判断额外的条件。
        let yetAnotherPoint = (1, -1)
        switch yetAnotherPoint {
        case let (x, y) where x == y:
            print("(\(x), \(y)) is on the line x == y")
        case let (x, y) where x == -y:
            print("(\(x), \(y)) is on the line x == -y")
        case let (x, y):
            print("(\(x), \(y)) is just some arbitrary point")
        }
        // 输出“(1, -1) is on the line x == -y”
        
        // MARK: case贯穿 fallthrough
        let integerToDescribe = 5
        var description = "The number \(integerToDescribe) is"
        switch integerToDescribe {
        case 2, 3, 5, 7, 11, 13, 17, 19:
            description += " a prime number, and also"
            fallthrough
        default:
            description += " an integer."
        }
        print(description)
        // 输出“The number 5 is a prime number, and also an integer.”

        // MARK: 标签
        let finalSquare = 25
        var board = [Int](repeating: 0, count: finalSquare + 1)
        board[03] = +08; board[06] = +11; board[09] = +09; board[10] = +02
        board[14] = -10; board[19] = -11; board[22] = -02; board[24] = -08
        var square = 0
        var diceRoll = 0
        
        // 定义一个gameLoop的标签
        gameLoop: while square != finalSquare {
            diceRoll += 1
            if diceRoll == 7 { diceRoll = 1 }
            switch square + diceRoll {
            case finalSquare:
                // 骰子数刚好使玩家移动到最终的方格里，游戏结束。
                // 不合法时跳出该while循环 break gameLoop
                break gameLoop
            case let newSquare where newSquare > finalSquare:
                // 骰子数将会使玩家的移动超出最后的方格，那么这种移动是不合法的，玩家需要重新掷骰子
                // 不合法时跳出该while循环 break gameLoop
                continue gameLoop
            default:
                // 合法移动，做正常的处理
                square += diceRoll
                square += board[square]
            }
        }
        print("Game over!")
    }
    
    // MARK: guard语句
    // 像 if 语句一样，guard 的执行取决于一个表达式的布尔值。
    // 我们可以使用 guard 语句来要求条件必须为真时，以执行 guard 语句后的代码。
    // 不同于 if 语句，一个 guard 语句总是有一个 else 从句，如果条件不为真则执行 else 从句中的代码
    func greet(person: [String: String]) {
        guard let name = person["name"] else {
            return
        }
        print("Hello \(name)!")
        
        guard let location = person["location"] else {
            print("I hope the weather is nice near you.")
            return
        }
        
        print("I hope the weather is nice in \(location).")
    }
//    greet(person: ["name": "John"])
//    // 输出“Hello John!”
//    // 输出“I hope the weather is nice near you.”
//    greet(person: ["name": "Jane", "location": "Cupertino"])
    // 输出“Hello Jane!”
    // 输出“I hope the weather is nice in Cupertino.”

    // MARK: 检测 API 可用性
    func aaaaa() {
        /**
         if #available(平台名称 版本号, ..., *) {
             APIs 可用，语句将执行
         } else {
             APIs 不可用，语句将不执行
         }
         */
        
        if #available(iOS 10, macOS 10.12, *) {
            // 在 iOS 使用 iOS 10 的 API, 在 macOS 使用 macOS 10.12 的 API
        } else {
            // 使用先前版本的 iOS 和 macOS 的 API
        }
    }
    
    // MARK: 函数
    // MARK: 函数标签
    func greet(person: String, from hometown: String) -> String {
        return "Hello \(person)!  Glad you could visit from \(hometown)."
    }
//    print(greet(person: "Bill", from: "Cupertino"))
    
    // MARK: 忽略标签
    func someFunction(_ firstParameterName: Int, secondParameterName: Int) {
         // 在函数体内，firstParameterName 和 secondParameterName 代表参数中的第一个和第二个参数值
    }

    // MARK: 默认参数
    func someFunction(parameterWithoutDefault: Int, parameterWithDefault: Int = 12) {
        // 如果你在调用时候不传第二个参数，parameterWithDefault 会值为 12 传入到函数体中。
    }

    // MARK: 可变参数
    // 一个函数能拥有多个可变参数。可变参数后的第一个行参前必须加上实参标签。实参标签用于区分实参是传递给可变参数，还是后面的行参。
    // 后面的参数标签form必须要有 不然报错
    func arithmeticMean(_ numbers: Double..., form a: Int) -> Double {
        var total: Double = 0
        for number in numbers {
            total += number
        }
        return total / Double(numbers.count)
    }
    // arithmeticMean(1, 2, 3, 4, 5)
    // 返回 3.0, 是这 5 个数的平均数。
    // arithmeticMean(3, 8.25, 18.75)
    // 返回 10.0, 是这 3 个数的平均数。

    // MARK: 输入输出参数：inout
    // 如果你想要一个函数可以修改参数的值，并且想要在这些修改在函数调用结束后仍然存在，那么就应该把这个参数定义为输入输出参数（In-Out Parameters）。
    func swapTwoInts(_ a: inout Int, _ b: inout Int) {
        let temporaryA = a
        a = b
        b = temporaryA
    }
    /*
     var someInt = 3
     var anotherInt = 107
     swapTwoInts(&someInt, &anotherInt)
     print("someInt is now \(someInt), and anotherInt is now \(anotherInt)")
     // 打印“someInt is now 107, and anotherInt is now 3”
     */
    
    // MARK: 函数类型
    func addTwoInts(_ a: Int, _ b: Int) -> Int {
        return a + b
    }
    func multiplyTwoInts(_ a: Int, _ b: Int) -> Int {
        return a * b
    }
    
    // 使用函数类型
//    var mathFunction: (Int, Int) -> Int = addTwoInts
    
    // MARK: 函数类型作为参数类型
    func printMathResult(_ mathFunction: (Int, Int) -> Int, _ a: Int, _ b: Int) {
        print("Result: \(mathFunction(a, b))")
    }

    // MARK: 函数类型作为返回类型
//    func chooseStepFunction(backward: Bool) -> (Int) -> Int {
//        return backward ? stepBackward : stepForward
//    }
}

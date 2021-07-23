//
//  BasedSome.swift
//  SwiftS3season
//
//  Created by mula on 2021/7/22.
//

import UIKit

// MARK: 枚举
enum CompassPoint: String {
    case north
    case south
    case east
    case west
}

enum Planet: Int {
    case mercury = 1, venus, earth, mars, jupiter, saturn, uranus, neptune
}

// MARK: 枚举关联值
enum Barcode {
    case upc(Int, Int, Int, Int)
    case qrCode(String)
}

// MARK: 枚举原始值
enum ASCIIControlCharacter: Character {
    case tab = "\t"
    case lineFeed = "\n"
    case carriageReturn = "\r"
}

// MARK: 递归枚举 两种方式都可以实现递归枚举
enum ArithmeticExpression {
    case number(Int)
    indirect case addition(ArithmeticExpression, ArithmeticExpression)
    indirect case multiplication(ArithmeticExpression, ArithmeticExpression)
}

/*
 indirect enum ArithmeticExpression {
     case number(Int)
     case addition(ArithmeticExpression, ArithmeticExpression)
     case multiplication(ArithmeticExpression, ArithmeticExpression)
 }
 */

class BasedSome: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "swift"
        view.backgroundColor = .gray
        baseDataType();

        // MARK: 枚举关联值使用
        let productBarcode = Barcode.upc(8, 85909, 51226, 3)
        print(productBarcode);
        
        let earthsOrder = Planet.earth.rawValue
        // earthsOrder 值为 3
        print(earthsOrder);

        let sunsetDirection = CompassPoint.west.rawValue
        // sunsetDirection 值为 "west"
        print(sunsetDirection);

        // MARK: 使用原始值创建枚举
        let possiblePlanet = Planet(rawValue: 7)
        print(possiblePlanet ?? .earth)

        // MARK: 使用递归枚举
        let five = ArithmeticExpression.number(5)
        let four = ArithmeticExpression.number(4)
        let sum = ArithmeticExpression.addition(five, four)
        let product = ArithmeticExpression.multiplication(sum, ArithmeticExpression.number(2))
        
        func evaluate(_ expression: ArithmeticExpression) -> Int {
            switch expression {
            case let .number(value):
                return value
            case let .addition(left, right):
                return evaluate(left) + evaluate(right)
            case let .multiplication(left, right):
                return evaluate(left) * evaluate(right)
            }
        }
        
        print(evaluate(product))

    }
    

    // MARK: 基础数据类型
    // MARK: Int 表示整型值；
    // (整数就是没有小数部分的数字，比如 42 和 -23 。整数可以是 有符号（正、负、零）或者 无符号（正、零）。)
    var minValue: UInt8 = UInt8.min  // minValue 为 0，是 UInt8 类型
    let maxValue = UInt8.max  // maxValue 为 255，是 UInt8 类型
    
    /*
    
     在32位平台上，Int 和 Int32 长度相同。
     在64位平台上，Int 和 Int64 长度相同。
     在32位平台上，UInt 和 UInt32 长度相同。
     在64位平台上，UInt 和 UInt64 长度相同。
     
     Int8 - [-128 : 127]
     Int16 - [-32768 : 32767]
     Int32 - [-2147483648 : 2147483647]
     Int64 - [-9223372036854775808 : 9223372036854775807]

     UInt8 - [0 : 255]
     UInt16 - [0 : 65535]
     UInt32 - [0 : 4294967295]
     UInt64 - [0 : 18446744073709551615]

    */
    
    // MARK: Double 和 Float 表示浮点型值；

    // 增加可读性
    let paddedDouble = 000123.456
    let oneMillion = 1_000_000
    let justOverOneMillion = 1_000_000.000_000_1

    /*
     Double 精确度很高，至少有 15 位小数，而 Float 只有 6 位小数
     
     Double 表示64位浮点数。当你需要存储很大或者很高精度的浮点数时请使用此类型。
     Float 表示32位浮点数。精度要求不高的话可以使用此类型。
     
     */
    
    // MARK: Bool 是布尔型值；String 是文本型数据。
    let orangesAreOrange = true

    
    // MARK: 类型别名 给系统类型定义自己的名称
    typealias AudioSample = UInt16
    let maxAmplitudeFound = AudioSample.min

    // MARK: 数值型字面量 进制
    /*
     一个十进制数，没有前缀
     一个二进制数，前缀是 0b
     一个八进制数，前缀是 0o
     一个十六进制数，前缀是 0x
     */
    let decimalInteger = 17
    let binaryInteger = 0b10001       // 二进制的17
    let octalInteger = 0o21           // 八进制的17
    let hexadecimalInteger = 0x11     // 十六进制的1
    
    /*
     十进制数的指数为 e
     1.25e2 表示 1.25 × 10^2，等于 125.0。
     1.25e-2 表示 1.25 × 10^-2，等于 0.0125。
     
     十六进制数的指数为 Fp
     0xFp2 表示 15 × 2^2，等于 60.0。
     0xFp-2 表示 15 × 2^-2，等于 3.75。
     */

    // MARK: 元祖（tuples）把多个值组合成一个复合值。元组内的值可以是任意类型，并不要求是相同类型
    // 当遇到一些相关值的简单分组时，元组是很有用的。元组不适合用来创建复杂的数据结构。如果你的数据结构比较复杂，不要使用元组，用类或结构体去建模
    let http404Error = (404, "Not Found")
    // 定义元祖可以给元素命名
    let http200Status = (statusCode: 200, description: "OK")
    
    // MARK: 可选类型 optionals
    let possibleNumber = "123"
    // convertedNumber 被推测为类型 "Int?"， 或者类型 "optional Int"
    
    
    // MARK: 空合运算符（a ?? b）
    // 将对可选类型 a 进行空判断，如果 a 包含一个值就进行解包，否则就返回一个默认值 b。
    // 表达式 a 必须是 Optional 类型。默认值 b 的类型必须要和 a 存储值的类型保持一致
    /*
     let defaultColorName = "red"
     var userDefinedColorName: String?   //默认值为 nil
     var colorNameToUse = userDefinedColorName ?? defaultColorName
     */

    // MARK: 闭区间运算符（a...b）定义一个包含从 a 到 b（包括 a 和 b）的所有值的区间。a 的值不能超过 b
    /*
     for index in 1...5 {
         print("\(index) * 5 = \(index * 5)")
     }
     */

    // MARK: 半开区间运算符（a..<b） 定义一个从 a 到 b 但不包括 b 的区间。 之所以称为半开区间，是因为该区间包含第一个值而不包括最后的值
    /*
     for name in names[0..<2] {
         print(name)
     }
     */
    
    // MARK: 单侧区间
    // 闭区间操作符有另一个表达形式，可以表达往一侧无限延伸的区间 —— 例如，一个包含了数组从索引 2 到结尾的所有值的区间。在这些情况下，你可以省略掉区间操作符一侧的值。这种区间叫做单侧区间，因为操作符只有一侧有值
    /*
     for name in names[2...] {
         print(name)
     }
     
     for name in names[..<2] {
         print(name)
     }
     
     let range = ...5
     range.contains(7)   // false
     range.contains(4)   // true
     range.contains(-1)  // true

     */
    
    func baseDataType() {
        // MARK: 用 let 来声明常量，用 var 来声明变量
        let x = 0.0, y = 0.0, z = 0.0
        var red, green, blue: Double
        red = 1.0
        green = 2.0
        blue = 3.0
        print(x, y, z)
        print(red, green, blue)

        // MARK: 整数转换
        let twoThousand: UInt16 = 2_000
        let one: UInt8 = 1
        let _: UInt16 = twoThousand + UInt16(one)

        // MARK: 整数和浮点数转换
        let three = 3
        let pointOneFourOneFiveNine = 0.14159
        let pi = Double(three) + pointOneFourOneFiveNine
        // 浮点数到整数的反向转换
        let _ = Int(pi)

        // MARK: 使用元祖
        let (statusCode, statusMessage) = http404Error
        print(statusCode, statusMessage)
        
        print("The status code is \(http200Status.statusCode)")
        
        // MARK: 可选类型使用
        var serverResponseCode: Int? = 404
        // serverResponseCode 包含一个可选的 Int 值 404
        serverResponseCode = nil
        print(serverResponseCode ?? 0)

        // MARK: 可选类型 if 语句以及强制解析
        let convertedNumber = Int(possibleNumber)
        if convertedNumber != nil {
            // 确定可选类型确实包含值之后 可选的名字后面加一个感叹号（!）来获取值
            print("convertedNumber has an integer value of \(convertedNumber!).")
        }
        // 如果 Int(possibleNumber) 返回的可选 Int 包含一个值，创建一个叫做 actualNumber 的新常量并将可选包含的值赋给它。
        if let firstNumber = Int("4"), let secondNumber = Int("42"), firstNumber < secondNumber && secondNumber < 100 {
            print("\(firstNumber) < \(secondNumber) < 100")
        }
        // MARK: 隐式解析可选类型
        let possibleString: String? = "An optional string."
        let forcedString: String = possibleString! // 需要感叹号来获取值
        print(forcedString);
        // 默认强制解析
        let assumedString: String! = "An implicitly unwrapped optional string."
        let implicitString: String = assumedString  // 不需要感叹号
        print(implicitString);
        
        // MARK: 字符串编辑
        let greeting = "Guten Tag!"
        print(greeting.count);
        print(greeting[greeting.startIndex]);
        // G
        //        print(greeting[greeting.endIndex]); // 越界报错
        print(greeting[greeting.index(before: greeting.endIndex)])
        // !
        print(greeting[greeting.index(after: greeting.startIndex)])
        // u
        let index = greeting.index(greeting.startIndex, offsetBy: 7)
        print(greeting[index]);
        // a
        // indices 属性会创建一个包含全部索引的范围（Range）
        for index in greeting.indices {
           print("\(greeting[index]) ", terminator: "")
        }

        // MARK: 字符串插入删除
        var welcome = "hello"
        welcome.insert("!", at: welcome.endIndex)
        // welcome 变量现在等于 "hello!"
        welcome.insert(contentsOf:" there", at: welcome.index(before: welcome.endIndex))
        // welcome 变量现在等于 "hello there!"
        
        welcome.remove(at: welcome.index(before: welcome.endIndex))
        // welcome 现在等于 "hello there"
        
        let range = welcome.index(welcome.endIndex, offsetBy: -6)..<welcome.endIndex
        welcome.removeSubrange(range)
        // welcome 现在等于 "hello"

        let greeting1 = "Hello, world!"
        let index1 = greeting.firstIndex(of: ",") ?? greeting.endIndex
        
        let beginning = greeting[..<index1]
        // beginning 的值为 "Hello"
        
        // 把结果转化为 String 以便长期存储。
        let newString = String(beginning)
        print(greeting1, newString);
        
    }
    
    
}

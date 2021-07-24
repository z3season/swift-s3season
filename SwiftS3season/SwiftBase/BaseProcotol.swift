//
//  BaseProcotol.swift
//  SwiftS3season
//
//  Created by mula on 2021/7/24.
//

import UIKit

// 协议

/**
 语法：

 protocol SomeProtocol {
     // 这里是协议的定义部分
 }

 struct SomeStructure: FirstProtocol, AnotherProtocol {
     // 这里是结构体的定义部分
 }
 
 class SomeClass: SomeSuperClass, FirstProtocol, AnotherProtocol {
     // 这里是类的定义部分
 }
 
 */

// 协议总是用 var 关键字来声明变量属性，在类型声明后加上 { set get } 来表示属性是可读可写的，可读属性则用 { get } 来表示
protocol SomeProtocol {
    var mustBeSettable: Int { get set }
    var doesNotNeedToBeSettable: Int { get }
    // 类型属性 static
    static var someTypeProperty: Int { get set }
    
    // 用扩展添加默认实现 可以不必须实现该方法
    func addSome()
}

extension SomeProtocol {
    func addSome() {
        // 默认实现
    }
}

protocol Togglable {
    // 实现协议中的 mutating 方法时，若是类类型，则不用写 mutating 关键字。而对于结构体和枚举，则必须写 mutating 关键字。
    mutating func toggle()
}

enum OnOffSwitch: Togglable {
    case off, on
    // mutating 关键字不可省略
    mutating func toggle() {
        switch self {
        case .off:
            self = .on
        case .on:
            self = .off
        }
    }
}

protocol TextRepresentable {
    // MARK: 可选的协议
    var textualDescription: String { get }
}

// MARK: 有条件地遵循协议 where关键字
extension Array: TextRepresentable where Element: TextRepresentable {
    var textualDescription: String {
        let itemsAsText = self.map { $0.textualDescription }
        return "[" + itemsAsText.joined(separator: ", ") + "]"
    }
}

// MARK: 类专属的协议
// 你通过添加 AnyObject 关键字到协议的继承列表，就可以限制协议只能被类类型采纳（以及非结构体或者非枚举的类型）。
protocol SomeClassOnlyProtocol: AnyObject {
    // 这里是类专属协议的定义部分
}

// 标记 @objc 特性的协议只能被继承自 Objective-C 类的类或者 @objc 类遵循，其他类以及结构体和枚举均不能遵循这种协议。
@objc protocol CounterDataSource {
    @objc optional func increment(forCount count: Int) -> Int
    @objc optional var fixedIncrement: Int { get }
}

class BaseProcotol: BaseViewController, SomeProtocol {
    
    var mustBeSettable: Int = 0
    var doesNotNeedToBeSettable: Int = 0
    static var someTypeProperty: Int = 1

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
}

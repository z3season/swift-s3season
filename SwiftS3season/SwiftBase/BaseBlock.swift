//
//  BaseBlock.swift
//  SwiftS3season
//
//  Created by mula on 2021/7/23.
//

import UIKit

var completionHandlers: [() -> Void] = []
// MARK: 逃逸闭包 @escaping
func someFunctionWithEscapingClosure(completionHandler: @escaping () -> Void) {
    completionHandlers.append(completionHandler)
}

func someFunctionWithNonescapingClosure(closure: () -> Void) {
    closure()
}

class SomeClass {
    var x = 10
    func doSomething() {
        someFunctionWithEscapingClosure { self.x = 100 }
        someFunctionWithNonescapingClosure { x = 200 }
    }
}

class BaseBlock: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let instance = SomeClass()
        instance.doSomething()
        print(instance.x)
        // 打印出“200”

        completionHandlers.first?()
        print(instance.x)
        // 打印出“100”
        var array = ["1"]
        array.remove(at: 0)
        // 自动闭包 直接使用字符串传参 不需要使用闭包方式
        serve(customer: "123123");
        
        var customersInLine = ["Chris", "Alex", "Ewa", "Barry", "Daniella"]
        serve(customer: customersInLine.remove(at: 0))
        
        
        // 自动闭包 逃逸闭包
        var customerProviders: [() -> String] = []
        func collectCustomerProviders(_ customerProvider: @autoclosure @escaping () -> String) {
            customerProviders.append(customerProvider)
        }
        collectCustomerProviders(customersInLine.remove(at: 0))
        collectCustomerProviders(customersInLine.remove(at: 0))
        
        print("Collected \(customerProviders.count) closures.")
        // 打印“Collected 2 closures.”
        for customerProvider in customerProviders {
            print("Now serving \(customerProvider())!")
        }

    }
    
    // MARK: 自动闭包 @autoclosure
    // 将参数标记为 @autoclosure 来接收一个自动闭包。现在你可以将该函数当作接受 String 类型参数（而非闭包）的函数来调用
    func serve(customer customerProvider: @autoclosure () -> String) {
        print("Now serving \(customerProvider())!")
    }
    
    // MARK: 闭包
    /**
     三种形式
     1，全局函数是一个有名字但不会捕获任何值的闭包
     2，嵌套函数是一个有名字并可以捕获其封闭函数域内值的闭包
     3，闭包表达式是一个利用轻量级语法所写的可以捕获其上下文中变量或常量值的匿名闭包
     */
    
    /*
     闭包表达式
     { (parameters) -> return type in
         statements
     }
     */
    
    /*
     一般使用
     reversedNames = names.sorted(by: { (s1: String, s2: String) -> Bool in
         return s1 > s2
     })
     // 以下闭包功能相同
     // 简写一行
     reversedNames = names.sorted(by: { (s1: String, s2: String) -> Bool in return s1 > s2 } )
     // 根据上下文推断类型
     reversedNames = names.sorted(by: { s1, s2 in return s1 > s2 } )
     // 单表达式闭包的隐式返回
     reversedNames = names.sorted(by: { s1, s2 in s1 > s2 } )
     // 参数名称缩写 Swift 自动为内联闭包提供了参数名称缩写功能，你可以直接通过 $0，$1，$2 来顺序调用闭包的参数，以此类推。
     reversedNames = names.sorted(by: { $0 > $1 } )
     
     // 更简便的方式 运算符方法
     reversedNames = names.sorted(by: >)
     
     // 尾随闭包方式
     reversedNames = names.sorted() { $0 > $1 }
     reversedNames = names.sorted { $0 > $1 }
     
     */
    
    // MARK: 尾随闭包
    /*
     如果你需要将一个很长的闭包表达式作为最后一个参数传递给函数，将这个闭包替换成为尾随闭包的形式很有用。
     尾随闭包是一个书写在函数圆括号之后的闭包表达式，函数支持将其作为最后一个参数调用。
     在使用尾随闭包时，你不用写出它的参数标签：
     
     func someFunctionThatTakesAClosure(closure: () -> Void) {
         // 函数体部分
     }
     ​
     // 以下是不使用尾随闭包进行函数调用
     someFunctionThatTakesAClosure(closure: {
         // 闭包主体部分
     })
     ​
     // 以下是使用尾随闭包进行函数调用
     someFunctionThatTakesAClosure() {
         // 闭包主体部分
     }
     */
}

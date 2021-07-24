//
//  BaseErrorThrows.swift
//  SwiftS3season
//
//  Created by mula on 2021/7/24.
//

import UIKit

enum VendingMachineError: Error {
    case invalidSelection                     //选择无效
    case insufficientFunds(coinsNeeded: Int) //金额不足
    case outOfStock                             //缺货
}

struct Item {
    var price: Int
    var count: Int
}

class VendingMachine {
    var inventory = [
        "Candy Bar": Item(price: 12, count: 7),
        "Chips": Item(price: 10, count: 4),
        "Pretzels": Item(price: 7, count: 11)
    ]
    var coinsDeposited = 0

    // MARK: 抛出异常
    func vend(itemNamed name: String) throws {
        guard let item = inventory[name] else {
            throw VendingMachineError.invalidSelection
        }

        guard item.count > 0 else {
            throw VendingMachineError.outOfStock
        }

        guard item.price <= coinsDeposited else {
            throw VendingMachineError.insufficientFunds(coinsNeeded: item.price - coinsDeposited)
        }

        coinsDeposited -= item.price

        var newItem = item
        newItem.count -= 1
        inventory[name] = newItem

        print("Dispensing \(name)")
    }
}

struct PurchasedSnack {
    let name: String
    init(name: String, vendingMachine: VendingMachine) throws {
        try vendingMachine.vend(itemNamed: name)
        self.name = name
    }
}

class BaseErrorThrows: BaseViewController {

    let favoriteSnacks = [
        "Alice": "Chips",
        "Bob": "Licorice",
        "Eve": "Pretzels",
    ]
    
    func buyFavoriteSnack(person: String, vendingMachine: VendingMachine) throws {
        let snackName = favoriteSnacks[person] ?? "Candy Bar"
        // MARK: 抛出方法内部的异常
        try vendingMachine.vend(itemNamed: snackName)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let vendingMachine = VendingMachine()
        vendingMachine.coinsDeposited = 100
        
        // MARK: 指定清理操作 defer
        // defer 语句将代码的执行延迟到当前的作用域退出之前
        // 注意：即使没有涉及到错误处理的代码，你也可以使用 defer 语句。
        defer {
            print("清理数据")
        }

        // MARK: 处理异常
        do {
            try buyFavoriteSnack(person: "Alice", vendingMachine: vendingMachine)
            print("购买成功\("Alice")")
        } catch VendingMachineError.invalidSelection {
            print("无此商品")
        } catch VendingMachineError.outOfStock {
            print("库存不足.")
        } catch VendingMachineError.insufficientFunds(let coinsNeeded) {
            print("请再投入 \(coinsNeeded) 个硬币.")
        } catch {
            print("异常: \(error).")
        }
        
        // MARK: 处理单个错误类型（只处理VendingMachineError类型）
        func nourish(with item: String) throws {
            do {
                try vendingMachine.vend(itemNamed: item)
            } catch is VendingMachineError {
                print("没有购买成功.")
            }
        }

        // MARK: 不区分VendingMachineError错误类型 异常统一处理
        func eat(item: String) throws {
            do {
                try vendingMachine.vend(itemNamed: item)
            } catch VendingMachineError.invalidSelection, VendingMachineError.insufficientFunds, VendingMachineError.outOfStock {
                print("无此商品、库存不足或者硬币不足")
            }
        }
        
        do {
            try nourish(with: "Chips")
        } catch {
            print("异常: \(error).")
        }

        // MARK: 禁用错误传递 try!
        // 某个 throwing 函数实际上在运行时是不会抛出错误的，在这种情况下，你可以在表达式前面写 try!
//        let photo = try! loadImage(atPath: "./Resources/John Appleseed.jpg")

        // MARK: 错误可选值 （以下1和2作用一样）
        /**
        1，
         let x = try? someThrowingFunction()
         ​
        2，
         let y: Int?
            do {
                y = try someThrowingFunction()
            } catch {
                y = nil
            }
        
         */

    }

    
}

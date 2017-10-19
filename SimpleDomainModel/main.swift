//
//  main.swift
//  SimpleDomainModel
//
//  Created by Ted Neward on 4/6/16.
//  Copyright © 2016 Ted Neward. All rights reserved.
//

import Foundation

print("Hello, World!")

public func testMe() -> String {
  return "I have been tested"
}

open class TestMe {
  open func Please() -> String {
    return "I have been tested"
  }
}

////////////////////////////////////
// Money
//
public struct Money {
    public var amount : Double
    public var currency : String
  
    public func convert(_ to: String) -> Money {
        if to.lowercased() != self.currency.lowercased() {
            switch to.lowercased() {
                case "usd": return self.toUsd()
                case "can": return self.toCan()
                case "gbp": return self.toGbp()
                case "eur": return self.toEur()
                default:    return self;
            }
        }
        return self;
    }
  
    public func add(_ other: Money) -> Money {
        let conv: Money = self.convert(other.currency)
        return Money(amount: conv.amount + other.amount, currency: other.currency)
    }

    public func subtract(_ other: Money) -> Money {
        let conv: Money = self.convert(other.currency)
        return Money(amount: conv.amount - other.amount, currency: other.currency)
    }
    
    private func toGbp() -> Money {
        switch currency.lowercased() {
            case "usd": return Money(amount: self.amount * 0.5, currency: "GBP")
            case "eur": return Money(amount: self.amount * 3, currency: "GBP")
            case "can": return Money(amount: self.amount * 2.5, currency: "GBP")
            default: return self
        }
    }
    
    private func toEur() -> Money {
        switch currency.lowercased() {
            case "usd": return Money(amount: self.amount * 1.5, currency: "EUR")
            case "gbp": return Money(amount: self.amount / 3, currency: "EUR")
            case "can": return Money(amount: self.amount / 2.5 * 3, currency: "EUR")
            default: return self
        }
    }
    
    private func toCan() -> Money {
        switch currency.lowercased() {
            case "usd": return Money(amount: self.amount * 1.25, currency: "CAN")
            case "eur": return Money(amount: self.amount * 2.5 / 3, currency: "CAN")
            case "gbp": return Money(amount: self.amount / 2.5, currency: "CAN")
            default: return self
        }
    }
  
    private func toUsd() -> Money {
        switch currency.lowercased() {
            case "gbp": return Money(amount: self.amount / 0.5, currency: "USD")
            case "eur": return Money(amount: self.amount / 1.5, currency: "USD")
            case "can": return Money(amount: self.amount / 1.25, currency: "USD")
            default: return self
        }
    }
}

////////////////////////////////////
// Job
//
open class Job {
  fileprivate var title : String
  fileprivate var type : JobType

  public enum JobType {
    case Hourly(Double)
    case Salary(Int)
    
    mutating func raise(_ amt: Double) {
        switch self {
            case let .Hourly(rate):
                self = .Hourly(rate + amt)
                break
            case let .Salary(yearly):
                self = .Salary(yearly + Int(amt))
                break
        }
    }
  }
  
  public init(title : String, type : JobType) {
    self.title = title
    self.type = type
  }
  
  open func calculateIncome(_ hours: Int) -> Int {
    switch type {
        case let .Hourly(rate): return Int(Double(hours) * rate)
        case let .Salary(yearly): return yearly
    }
  }
  
  open func raise(_ amt : Double) {
    type.raise(amt)
  }
    
    public func toString() -> String {
        var str = "Title: \(title)\nPay: "
        switch type {
            case let .Hourly(rate):
                str = str + "Hourly (\(rate))"
                break
            case let .Salary(yearly):
                str = str + "Salary (\(yearly))"
                break
        }
        return str
    }
}

////////////////////////////////////
// Person
//
open class Person {
  open var firstName : String = ""
  open var lastName : String = ""
  open var age : Int = 0

  fileprivate var _job : Job? = nil
  open var job : Job? {
    get { return self._job }
    set(value) {
        if self.age >= 16 {
            self._job = value
        }
    }
  }
  
  fileprivate var _spouse : Person? = nil
  open var spouse : Person? {
    get { return self._spouse }
    set(value) {
        if self.age >= 18 {
            self._spouse = value
        }
    }
  }
  
  public init(firstName : String, lastName: String, age : Int) {
    self.firstName = firstName
    self.lastName = lastName
    self.age = age
  }
  
  open func toString() -> String {
    var jobStr = "nil"
    var spouseStr = "nil"
    if job != nil {
        jobStr = (job?.toString())!
    }
    if spouse != nil {
        spouseStr = (spouse?.firstName)!
    }
    return "[Person: firstName:\(firstName) lastName:\(lastName) age:\(age) job:\(jobStr) spouse:\(spouseStr)]"
  }
}

////////////////////////////////////
// Family
//
open class Family {
  fileprivate var members : [Person] = []
  
  public init(spouse1: Person, spouse2: Person) {
    spouse1.spouse = spouse2
    spouse2.spouse = spouse1
    members.append(spouse1)
    members.append(spouse2)
  }
  
  open func haveChild(_ child: Person) -> Bool {
    for member in members {
        if member.age >= 21 {
            members.append(child)
            return true
        }
    }
    return false
  }
  
  open func householdIncome() -> Int {
    var income = 0
    for member in members {
        if member.job != nil {
            income = income + (member.job?.calculateIncome(2000))!
        }
    }
    return income
  }
}






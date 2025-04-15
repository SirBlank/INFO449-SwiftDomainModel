struct DomainModel {
    var text = "Hello, World!"
        // Leave this here; this value is also tested in the tests,
        // and serves to make sure that everything is working correctly
        // in the testing harness and framework.
}

////////////////////////////////////
// Money
//
public struct Money {
    let amount : Int
    let currency : String
    
    private let acceptedCurrencies = ["USD", "GBP", "EUR", "CAN"]
    private let exchangeRate = ["USD": 1,
                        "GBP": 0.5,
                        "EUR": 1.5,
                        "CAN": 1.25]
    
    init(amount: Int, currency: String) {
        guard acceptedCurrencies.contains(currency) else {
            fatalError("Error: Unknown currency")
        }
        
        self.amount = amount
        self.currency = currency
        
    }
    
    func convert(_ newCurrency: String) -> Money {
        guard let currRate = exchangeRate[currency], let newRate = exchangeRate[newCurrency] else {
            fatalError("Error: Unknown currency")
        }
        
        let amountInUSD = Double(self.amount) / currRate
        let convertedAmount = amountInUSD * newRate
        return Money(amount: Int(convertedAmount), currency: newCurrency)
    }
    
    func add(_ addMoney: Money) -> Money {
        let convertedCurrMoney = convert(addMoney.currency)
        let newAmount = convertedCurrMoney.amount + addMoney.amount
        return Money(amount: newAmount, currency: addMoney.currency)
    }
    
    func subtract(_ subMoney: Money) -> Money {
        let convertedCurrMoney = convert(subMoney.currency)
        let newAmount = convertedCurrMoney.amount - subMoney.amount
        return Money(amount: newAmount, currency: subMoney.currency)
    }
    
    
}

////////////////////////////////////
// Job
//
public class Job {
    let title : String
    var type : JobType
    public enum JobType {
        case Hourly(Double)
        case Salary(UInt)
    }
    
    init(title: String, type: JobType) {
        self.title = title
        self.type = type
    }
    
    func calculateIncome(_ hours: Int) -> Int {
        switch type {
        case .Hourly(let double):
            return Int(double) * hours
        case .Salary(let uInt):
            return Int(uInt)
        }
    }
    
    func raise(byAmount: Double) {
        switch type {
        case .Hourly(let double):
            if byAmount < 0 {
                print("Raises should be a positive number! Salary is unchanged!")
            } else {
                let newSalary = double + byAmount
                type = .Hourly(newSalary)
            }
        case .Salary(let uInt):
            if byAmount < 0 {
                print("Raises should be a positive number! Salary is unchanged!")
            } else {
                let newSalary = Double(uInt) + byAmount
                type = .Salary(UInt(newSalary))
            }
        }
    }
    
    func raise(byPercent: Double) {
        switch type {
        case .Hourly(let double):
            if byPercent < 0 {
                print("Raises should be a positive percentage! Salary is unchanged!")
            } else {
                let newSalary = double * (1 + byPercent)
                type = .Hourly(newSalary)
            }
        case .Salary(let uInt):
            if byPercent < 0 {
                print("Raises should be a positive percentage! Salary is unchanged!")
            } else {
                let newSalary = Double(uInt) * (1 + byPercent)
                type = .Salary(UInt(newSalary))
            }
        }
    }
    
    func convert() {
        switch type {
        case .Hourly(let double):
            let salary = 2000*double
            type = .Salary(UInt((salary / 1000).rounded() * 1000))
        case .Salary(_):
            print("This job is already a salaried position.")
        }
    }
}

////////////////////////////////////
// Person
//
public class Person {
    let firstName : String?
    let lastName : String?
    let age : Int
    var job : Job? {
        didSet {
            if age <= 16 {
                job = nil
            }
        }
    }
    var spouse : Person? {
        didSet {
            if age <= 16 {
                spouse = nil
            }
        }
    }
    
    init(firstName: String? = nil, lastName: String? = nil, age: Int, job: Job? = nil, spouse: Person? = nil) {
        guard firstName != nil || lastName != nil else {
            fatalError("Person name must contain at least a first name or last name")
        }
        self.firstName = firstName
        self.lastName = lastName
        self.age = age
        self.job = job
        self.spouse = spouse
    }
    
    func toString() -> String {
        return "[Person: firstName:\(firstName ?? "") lastName:\(lastName ?? "") age:\(age) job:\(String(describing: job)) spouse:\(String(describing: spouse))]"
    }
}

////////////////////////////////////
// Family
//
public class Family {
    var members : [Person]
    
    init(spouse1 : Person, spouse2 : Person) {
        guard spouse1.spouse == nil, spouse2.spouse == nil else {
            fatalError("One or both spouses are already married")
        }
        
        spouse1.spouse = spouse2
        spouse2.spouse = spouse1
        self.members = [spouse1, spouse2]
    }
    
    func haveChild(_ child : Person) -> Bool {
        guard members[0].age >= 21 || members[1].age >= 21 else {
            return false
        }
        members.append(child)
        return true
    }
    
    func householdIncome() -> Int {
        var sum = 0.0
        for member in members {
            switch member.job?.type {
            case .Hourly(let amount):
                sum += amount * 2000.0
            case .Salary(let amount):
                sum += Double(amount)
            case nil:
                sum += 0
            }
        }
        return Int(sum)
    }
}

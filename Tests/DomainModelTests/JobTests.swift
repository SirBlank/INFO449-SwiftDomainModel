import XCTest
@testable import DomainModel

class JobTests: XCTestCase {
  
    func testCreateSalaryJob() {
        let job = Job(title: "Guest Lecturer", type: Job.JobType.Salary(1000))
        XCTAssert(job.calculateIncome(50) == 1000)
        XCTAssert(job.calculateIncome(100) == 1000)
        // Salary jobs pay the same no matter how many hours you work
    }

    func testCreateHourlyJob() {
        let job = Job(title: "Janitor", type: Job.JobType.Hourly(15.0))
        XCTAssert(job.calculateIncome(10) == 150)
        XCTAssert(job.calculateIncome(20) == 300)
    }

    func testSalariedRaise() {
        let job = Job(title: "Guest Lecturer", type: Job.JobType.Salary(1000))
        XCTAssert(job.calculateIncome(50) == 1000)

        job.raise(byAmount: 1000)
        XCTAssert(job.calculateIncome(50) == 2000)

        job.raise(byPercent: 0.1)
        XCTAssert(job.calculateIncome(50) == 2200)
    }

    func testHourlyRaise() {
        let job = Job(title: "Janitor", type: Job.JobType.Hourly(15.0))
        XCTAssert(job.calculateIncome(10) == 150)

        job.raise(byAmount: 1.0)
        XCTAssert(job.calculateIncome(10) == 160)

        job.raise(byPercent: 1.0) // Nice raise, bruh
        XCTAssert(job.calculateIncome(10) == 320)
    }
    
    //  --- MY TESTS ---
    func testNegativeHourlyRaise() {
        let job = Job(title: "Janitor", type: Job.JobType.Hourly(15.0))
        job.raise(byAmount: -1.0)
        XCTAssert(job.calculateIncome(1) == 15)
    }
    
    func testNegativeSalariedRaise() {
        let job = Job(title: "Guest Lecturer", type: Job.JobType.Salary(1000))
        job.raise(byAmount: -1000)
        XCTAssert(job.calculateIncome(50) == 1000)
    }
    
    func testConvertHourly() {
        let job = Job(title: "Janitor", type: Job.JobType.Hourly(16.5))
        job.convert()
        XCTAssert(job.calculateIncome(1) == 33000)
    }
    
    func testConvertSalaried() {
        let job = Job(title: "Guest Lecturer", type: Job.JobType.Salary(1000))
        job.convert()
        XCTAssert(job.calculateIncome(1) == 1000)
    }
  
    static var allTests = [
        ("testCreateSalaryJob", testCreateSalaryJob),
        ("testCreateHourlyJob", testCreateHourlyJob),
        ("testSalariedRaise", testSalariedRaise),
        ("testHourlyRaise", testHourlyRaise),
        
        ("testNegativeHourlyRaise", testNegativeHourlyRaise),
        ("testNegativeSalariedRaise", testNegativeSalariedRaise),
        ("testConvertHourly", testConvertHourly),
        ("testConvertSalaried", testConvertSalaried),   
    ]
}

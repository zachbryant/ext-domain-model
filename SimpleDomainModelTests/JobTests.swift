//
//  JobTests.swift
//  SimpleDomainModel
//
//  Created by Ted Neward on 4/6/16.
//  Copyright © 2016 Ted Neward. All rights reserved.
//

import XCTest


class JobTests: XCTestCase {
  
  func testCreateSalaryJob() {
    let job = Job(title: "Guest Lecturer", type: Job.JobType.Salary(1000))
    XCTAssert(job.calculateIncome(50) == 1000)
  }

  func testCreateHourlyJob() {
    let job = Job(title: "Janitor", type: Job.JobType.Hourly(15.0))
    XCTAssert(job.calculateIncome(10) == 150)
    XCTAssert(job.description == "Janitor @ 30000.0/yr")
  }
  
  func testSalariedRaise() {
    let job = Job(title: "Guest Lecturer", type: Job.JobType.Salary(1000))
    XCTAssert(job.calculateIncome(50) == 1000)
    XCTAssert(job.description == "Guest Lecturer @ 1000.0/yr")
    job.raise(1000)
    XCTAssert(job.calculateIncome(50) == 2000)
    XCTAssert(job.description == "Guest Lecturer @ 2000.0/yr")
  }
  
  func testHourlyRaise() {
    let job = Job(title: "Janitor", type: Job.JobType.Hourly(15.0))
    XCTAssert(job.calculateIncome(10) == 150)
    
    job.raise(1.0)
    XCTAssert(job.calculateIncome(10) == 160)
    XCTAssert(job.description == "Janitor @ 32000.0/yr")
  }
  
}

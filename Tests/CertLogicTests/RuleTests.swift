//
//  RuleTests.swift
//  
//
//  Created by Thomas Kuleßa on 08.09.22.
//

@testable import CertLogic
import SwiftyJSON
import XCTest

class RuleTests: XCTestCase {
    private var sut: Rule!

    override func setUpWithError() throws {
        configureSut()
    }

    private func configureSut(
        type: String = "Invalidation",
        certificateType: String = "Vaccination"
    ) {
        sut = .init(
            identifier: "",
            type: type,
            version: "",
            schemaVersion: "",
            engine: "",
            engineVersion: "",
            certificateType: certificateType,
            description: [],
            validFrom: "",
            validTo: "",
            affectedString: [],
            logic: .null,
            countryCode: ""
        )
    }

    override func tearDownWithError() throws {
        sut = nil
    }

    func testRuleType_invalid() {
        // Given
        configureSut(type: "CPlusPlus")

        // When
        let ruleType = sut.ruleType

        // Then
        XCTAssertEqual(ruleType, .acceptence)
    }

    func testRuleType_2G() {
        // Given
        configureSut(type: "TwoG")

        // When
        let ruleType = sut.ruleType

        // Then
        XCTAssertEqual(ruleType, ._2G)
    }

    func testRuleType_2GPlus() {
        // Given
        configureSut(type: "TwoGPlus")

        // When
        let ruleType = sut.ruleType

        // Then
        XCTAssertEqual(ruleType, ._2GPlus)
    }

    func testRuleType_3G() {
        // Given
        configureSut(type: "ThreeG")

        // When
        let ruleType = sut.ruleType

        // Then
        XCTAssertEqual(ruleType, ._3G)
    }
    
    func testRuleType_3GPlus() {
        // Given
        configureSut(type: "ThreeGPlus")

        // When
        let ruleType = sut.ruleType

        // Then
        XCTAssertEqual(ruleType, ._3GPlus)
    }
    
    func testRuleType_ImpfstatusBZweis() {
        // Given
        configureSut(type: "ImpfstatusBZwei")

        // When
        let ruleType = sut.ruleType

        // Then
        XCTAssertEqual(ruleType, .impfstatusBZwei)
    }
    
    func testRuleType_ImpfstatusCZwei() {
        // Given
        configureSut(type: "ImpfstatusCZwei")

        // When
        let ruleType = sut.ruleType

        // Then
        XCTAssertEqual(ruleType, .impfstatusCZwei)
    }
    
    func testRuleType_ImpfstatusEZwei() {
        // Given
        configureSut(type: "ImpfstatusEZwei")

        // When
        let ruleType = sut.ruleType

        // Then
        XCTAssertEqual(ruleType, .impfstatusEZwei)
    }

    func testRuleType_mask() {
        // Given
        configureSut(type: "Mask")

        // When
        let ruleType = sut.ruleType

        // Then
        XCTAssertEqual(ruleType, .mask)
    }

    func testCertificateFullType_invalid() {
        // Given
        configureSut(certificateType: "")

        // When
        let certificateFullType = sut.certificateFullType

        // Then
        XCTAssertEqual(certificateFullType, .general)
    }

    func testCertificateFullType_test() {
        // Given
        configureSut(certificateType: "Test")

        // When
        let certificateFullType = sut.certificateFullType

        // Then
        XCTAssertEqual(certificateFullType, .test)
    }
}

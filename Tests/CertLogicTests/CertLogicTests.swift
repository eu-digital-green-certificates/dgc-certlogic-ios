    import XCTest
    @testable import CertLogic

    final class CertLogicTests: XCTestCase {
        func testExample() {

          let jsonString =
          """
          {
           "Identifier":"GR-CZ-0001",
           "Version":"1.0.0",
           "SchemaVersion":"1.0.0",
           "Engine":"CERTLOGIC",
           "EngineVersion":"2.0.1",
           "Type":"Test",
           "CertificateType":"CERTLOGIC",
           "CountryCode":"UA",
           "Description":[{"lang":"en", "desc":"The Field “Doses” MUST contain number 2 OR 2/2."}],
           "ValidFrom":"2021-05-27T07:46:40Z",
           "ValidTo":"2021-06-01T07:46:40Z",
           "AffectedFields":["dt","nm"],
           "Logic": "{
                     "and": [
                     {">=":[{"var":"dt", "23.12.2012"}]},
                     {">=":[{"var":"nm", "ABC"}]}]
            }"
          }
          """
          let rule = CertLogicEngine.getRule(from: jsonString)
          print("rules: \(rule)")
//            XCTAssertEqual(CertLogic().text, "Hello, World!")
        }
    }

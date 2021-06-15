    import XCTest
    @testable import CertLogic

    final class CertLogicTests: XCTestCase {
        func testExample() {

          let external =
          """
          {
              "validationClock": "2021-06-14T17:07:36.622",
              "valueSets": {
              },
              "countryCode": "ua",
              "exp": "2021-06-14T17:07:36.622",
              "iat": "2021-06-14T17:07:36.622"
          }
        """
          
          let payload =
          """
          {
              "v": [
                {
                  "dn": 1,
                  "ma": "ORG-100001699",
                  "vp": "J07BX03",
                  "dt": "2021-06-10",
                  "co": "UA",
                  "ci": "URN:UVCI:V1:DE:3RCVMTLAI70VB8D0L5N2K0VXNJ",
                  "mp": "EU/1/20/1507",
                  "is": "Issuer Certifcate",
                  "sd": 2,
                  "tg": "840539006"
                }
              ],
              "nam": {
                "fnt": "SARAPULOV",
                "gnt": "ALEX"
              },
              "ver": "1.0.0",
              "dob": "1990-01-17"
            }
          """
          
          let jsonString =
          """
          {
            "Identifier": "GR-CZ-0001",
            "Version": "1.0.0",
            "SchemaVersion": "1.0.0",
            "EngineVersion": "2.0.1",
            "Type": "Test",
            "CertificateType": "CERTLOGIC",
            "CountryCode": "ua",
            "Description": [
              {
                "lang": "en",
                "desc": "The Field “Doses” MUST contain number 2 OR 2/2."
              }
            ],
            "ValidFrom": "2021-05-27T07:46:40Z",
            "ValidTo": "2021-06-01T07:46:40Z",
            "AffectedFields": [
              "dt",
              "nm"
            ],
            "Logic": "{\\\"and\\\":[{\\\">=\\\":[{\\\"var\\\":\\\"dt\\\"},\\\"23.12.2012\\\"]},{\\\">=\\\":[{\\\"var\\\":\\\"nm\\\"},\\\"ABC\\\"]}]}"
          }
          """
          if let rule = CertLogicEngine.getRule(from: jsonString), let externalParameter = CertLogicEngine.getExternalParameter(from: external) {
            let engine = CertLogicEngine(rules: [rule])
            let result = engine.validate(schema: "1.0.0", external: externalParameter, payload: payload)
            print("rules: \(rule) \n externalParameter: \(externalParameter) \n result: \(result)")

          } else
          { XCTestError.self }
//            XCTAssertEqual(CertLogic().text, "Hello, World!")
        }
    }

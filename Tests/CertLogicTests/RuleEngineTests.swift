//
//  File.swift
//  
//
//  Created by Steffen on 07.07.21.
//

import Foundation
import XCTest
import SwiftyJSON
@testable import CertLogic
    
final class RuleEngineTests: XCTestCase {
    
    let euDgcSchemaV1 = """
    {
      "$schema": "https://json-schema.org/draft/2020-12/schema",
      "$id": "https://id.uvci.eu/DGC.combined-schema.json",
      "title": "EU DGC",
      "description": "EU Digital Green Certificate",
      "$comment": "Schema version 1.0.0",
      "required": [
        "ver",
        "nam",
        "dob"
      ],
      "type": "object",
      "properties": {
        "ver": {
          "title": "Schema version",
          "description": "Version of the schema, according to Semantic versioning (ISO, https://semver.org/ version 2.0.0 or newer)",
          "type": "string",
          "pattern": "^\\\\d+.\\\\d+.\\\\d+$",
          "examples": [
            "1.0.0"
          ]
        },
        "nam": {
          "description": "Surname(s), given name(s) - in that order",
          "$ref": "#/$defs/person_name"
        },
        "dob": {
          "title": "Date of birth",
          "description": "Date of Birth of the person addressed in the DGC. ISO 8601 date format restricted to range 1900-2099",
          "type": "string",
          "format": "date",
          "pattern": "^(19|20)\\\\d\\\\d(-\\\\d\\\\d){0,2}((T)(\\\\d{2}):(\\\\d{2}):(\\\\d{2}))?$",
          "examples": [
            "1979-04-14",
            "1979-04",
            "1979",
            "1979-04-14T00:00:00"
          ]
        },
        "v": {
          "description": "Vaccination Group",
          "type": "array",
          "items": {
            "$ref": "#/$defs/vaccination_entry"
          },
          "minItems": 1
        },
        "t": {
          "description": "Test Group",
          "type": ["null", "array"],
          "items": {
            "$ref": "#/$defs/test_entry"
          },
          "minItems": 1
        },
        "r": {
          "description": "Recovery Group",
          "type": ["null", "array"],
          "items": {
            "$ref": "#/$defs/recovery_entry"
          },
          "minItems": 1
        }
      },
      "$defs": {
        "dose_posint": {
          "description": "Dose Number / Total doses in Series: positive integer, range: [1,9]",
          "type": "integer",
          "minimum": 1,
          "maximum": 9
        },
        "country_vt": {
          "description": "Country of Vaccination / Test, ISO 3166 where possible",
          "type": "string",
          "pattern": "[A-Z]{1,10}"
        },
        "issuer": {
          "description": "Certificate Issuer",
          "type": "string",
          "maxLength": 50
        },
        "person_name": {
          "description": "Person name: Surname(s), given name(s) - in that order",
          "required": [
            "fnt"
          ],
          "type": "object",
          "properties": {
            "fn": {
              "title": "Family name",
              "description": "The family or primary name(s) of the person addressed in the certificate",
              "type": "string",
              "maxLength": 50,
              "examples": [
                "d'Červenková Panklová"
              ]
            },
            "fnt": {
              "title": "Standardised family name",
              "description": "The family name(s) of the person transliterated",
              "type": "string",
              "maxLength": 50,
              "examples": [
                "DCERVENKOVA<PANKLOVA"
              ]
            },
            "gn": {
              "title": "Given name",
              "description": "The given name(s) of the person addressed in the certificate",
              "type": "string",
              "maxLength": 50,
              "examples": [
                "Jiřina-Maria Alena"
              ]
            },
            "gnt": {
              "title": "Standardised given name",
              "description": "The given name(s) of the person transliterated",
              "type": "string",
              "maxLength": 50,
              "examples": [
                "JIRINA<MARIA<ALENA"
              ]
            }
          }
        },
        "certificate_id": {
          "description": "Certificate Identifier, format as per UVCI: Annex 2 in  https://ec.europa.eu/health/sites/health/files/ehealth/docs/vaccination-proof_interoperability-guidelines_en.pdf",
          "type": "string",
          "maxLength": 50
        },
        "vaccination_entry": {
          "description": "Vaccination Entry",
          "required": [
            "tg",
            "vp",
            "mp",
            "ma",
            "dn",
            "sd",
            "dt",
            "co",
            "is",
            "ci"
          ],
          "type": "object",
          "properties": {
            "tg": {
              "description": "disease or agent targeted",
              "$ref": "#/$defs/disease-agent-targeted"
            },
            "vp": {
              "description": "vaccine or prophylaxis",
              "$ref": "#/$defs/vaccine-prophylaxis"
            },
            "mp": {
              "description": "vaccine medicinal product",
              "$ref": "#/$defs/vaccine-medicinal-product"
            },
            "ma": {
              "description": "Marketing Authorization Holder - if no MAH present, then manufacturer",
              "$ref": "#/$defs/vaccine-mah-manf"
            },
            "dn": {
              "description": "Dose Number",
              "$ref": "#/$defs/dose_posint"
            },
            "sd": {
              "description": "Total Series of Doses",
              "$ref": "#/$defs/dose_posint"
            },
            "dt": {
              "description": "Date of Vaccination",
              "type": "string",
              "format": "date-time",
              "$comment": "SemanticSG: constrain to specific date range?"
            },
            "co": {
              "description": "Country of Vaccination",
              "$ref": "#/$defs/country_vt"
            },
            "is": {
              "description": "Certificate Issuer",
              "$ref": "#/$defs/issuer"
            },
            "ci": {
              "description": "Unique Certificate Identifier: UVCI",
              "$ref": "#/$defs/certificate_id"
            }
          }
        },
        "test_entry": {
          "description": "Test Entry",
          "required": [
            "tg",
            "tt",
            "sc",
            "tr",
            "tc",
            "co",
            "is",
            "ci"
          ],
          "type": "object",
          "properties": {
            "tg": {
              "$ref": "#/$defs/disease-agent-targeted"
            },
            "tt": {
              "description": "Type of Test",
              "type": "string"
            },
            "nm": {
              "description": "NAA Test Name",
              "type": "string"
            },
            "ma": {
              "description": "RAT Test name and manufacturer",
              "$ref": "#/$defs/test-manf"
            },
            "sc": {
              "description": "Date/Time of Sample Collection",
              "type": "string",
              "format": "date-time"
            },
            "dr": {
              "description": "Date/Time of Test Result",
              "type": "string",
              "format": "date-time"
            },
            "tr": {
              "description": "Test Result",
              "$ref": "#/$defs/test-result"
            },
            "tc": {
              "description": "Testing Centre",
              "type": "string",
              "maxLength": 50
            },
            "co": {
              "description": "Country of Test",
              "$ref": "#/$defs/country_vt"
            },
            "is": {
              "description": "Certificate Issuer",
              "$ref": "#/$defs/issuer"
            },
            "ci": {
              "description": "Unique Certificate Identifier, UVCI",
              "$ref": "#/$defs/certificate_id"
            }
          }
        },
        "recovery_entry": {
          "description": "Recovery Entry",
          "required": [
            "tg",
            "fr",
            "co",
            "is",
            "df",
            "du",
            "ci"
          ],
          "type": "object",
          "properties": {
            "tg": {
              "$ref": "#/$defs/disease-agent-targeted"
            },
            "fr": {
              "description": "ISO 8601 Date of First Positive Test Result",
              "type": "string",
              "format": "date"
            },
            "co": {
              "description": "Country of Test",
              "$ref": "#/$defs/country_vt"
            },
            "is": {
              "description": "Certificate Issuer",
              "$ref": "#/$defs/issuer"
            },
            "df": {
              "description": "ISO 8601 Date: Certificate Valid From",
              "type": "string",
              "format": "date-time"
            },
            "du": {
              "description": "Certificate Valid Until",
              "type": "string",
              "format": "date-time"
            },
            "ci": {
              "description": "Unique Certificate Identifier, UVCI",
              "$ref": "#/$defs/certificate_id"
            }
          }
        },
        "disease-agent-targeted": {
          "description": "EU eHealthNetwork: Value Sets for Digital Green Certificates. version 1.0, 2021-04-16, section 2.1",
          "type": "string",
          "valueset-uri": "valuesets/disease-agent-targeted.json"
        },
        "vaccine-prophylaxis": {
          "description": "EU eHealthNetwork: Value Sets for Digital Green Certificates. version 1.0, 2021-04-16, section 2.2",
          "type": "string",
          "valueset-uri": "valuesets/vaccine-prophylaxis.json"
        },
        "vaccine-medicinal-product": {
          "description": "EU eHealthNetwork: Value Sets for Digital Green Certificates. version 1.0, 2021-04-16, section 2.3",
          "type": "string",
          "valueset-uri": "valuesets/vaccine-medicinal-product.json"
        },
        "vaccine-mah-manf": {
          "description": "EU eHealthNetwork: Value Sets for Digital Green Certificates. version 1.0, 2021-04-16, section 2.4",
          "type": "string",
          "valueset-uri": "valuesets/vaccine-mah-manf.json"
        },
        "test-manf": {
          "description": "EU eHealthNetwork: Value Sets for Digital Green Certificates. version 1.0, 2021-04-16, section 2.8",
          "type": "string",
          "valueset-uri": "valuesets/test-manf.json"
        },
        "test-result": {
          "description": "EU eHealthNetwork: Value Sets for Digital Green Certificates. version 1.0, 2021-04-16, section 2.9",
          "type": "string",
          "valueset-uri": "valuesets/test-results.json"
        }
      }
    }
    """
    
    func testRuleVersioning()
    {
        let filter = FilterParameter(validationClock: Date.init(), countryCode: "DE", certificationType: CertificateType.vaccination, region: nil)
        
        let external = ExternalParameter(validationClock: Date.init(), valueSets: [:], exp:Date.distantFuture , iat: Date.distantPast, issuerCountryCode: "AT")
        
        
        let rule1 = Rule(identifier: "VR-DE-0001", type: "Acceptance", version: "1.0.0", schemaVersion: "1.0.0", engine: "CERTLOGIC", engineVersion: "1.0.0", certificateType: "Vaccination", description: [Description(lang: "en", desc: "Hello")], validFrom: "2020-06-01T00:00:00Z", validTo: "2030-06-01T00:00:00Z", affectedString: ["v.0.ma"], logic: JSON("""
                            {">":["1","1"]}
                        """), countryCode: "DE")
        
        let rule2 = Rule(identifier: "VR-DE-0001", type: "Acceptance", version: "1.0.1", schemaVersion: "1.0.0", engine: "CERTLOGIC", engineVersion: "1.0.0", certificateType: "Vaccination", description: [Description(lang: "en", desc: "Hello")], validFrom: "2020-06-01T00:00:00Z", validTo: "2030-06-01T00:00:00Z", affectedString: ["v.0.ma"], logic: JSON("""
                            {"==":["1","1"]}
                        """), countryCode: "DE")
        
        let engine = CertLogicEngine(schema: euDgcSchemaV1, rules: [rule1,rule2])
        
        let result = engine.validate(filter: filter, external: external, payload: """
                                                                        {"ver":"1.0.0"}
                                                                  """)
        
        XCTAssertTrue(result[0].result == .passed)
        XCTAssertTrue(result.count==1)
    }
    
    func testRuleVersioningNegative()
    {
        let filter = FilterParameter(validationClock: Date.init(), countryCode: "DE", certificationType: CertificateType.vaccination, region: nil)
        
        let external = ExternalParameter(validationClock: Date.init(), valueSets: [:], exp:Date.distantFuture , iat: Date.distantPast, issuerCountryCode: "AT")
        
        
        let rule1 = Rule(identifier: "VR-DE-0001", type: "Acceptance", version: "1.0.0", schemaVersion: "1.0.0", engine: "CERTLOGIC", engineVersion: "1.0.0", certificateType: "Vaccination", description: [Description(lang: "en", desc: "Hello")], validFrom: "2020-06-01T00:00:00Z", validTo: "2030-06-01T00:00:00Z", affectedString: ["v.0.ma"], logic: JSON("""
                            {"==":["1","1"]}
                        """), countryCode: "DE")
        
        let rule2 = Rule(identifier: "VR-DE-0001", type: "Acceptance", version: "1.0.1", schemaVersion: "1.0.0", engine: "CERTLOGIC", engineVersion: "1.0.0", certificateType: "Vaccination", description: [Description(lang: "en", desc: "Hello")], validFrom: "2020-06-01T00:00:00Z", validTo: "2030-06-01T00:00:00Z", affectedString: ["v.0.ma"], logic: JSON("""
                            {">":["1","1"]}
                        """), countryCode: "DE")
        
        let engine = CertLogicEngine(schema: euDgcSchemaV1, rules: [rule1,rule2])
        
        let result = engine.validate(filter: filter,external: external, payload: """
                                                                        {"ver":"1.0.0"}
                                                                  """)
        
        XCTAssertTrue(result[0].result == .fail)
        XCTAssertTrue(result.count==1)
    }
    
    func testRuleVersioningWithMultipleVersions()
    {
        let filter = FilterParameter(validationClock: Date.init(), countryCode: "DE", certificationType: CertificateType.vaccination, region: nil)
        
        let external = ExternalParameter(validationClock: Date.init(), valueSets: [:], exp:Date.distantFuture , iat: Date.distantPast, issuerCountryCode: "AT")
        
        
        let rule1 = Rule(identifier: "VR-DE-0001", type: "Acceptance", version: "1.0.0", schemaVersion: "1.0.0", engine: "CERTLOGIC", engineVersion: "1.0.0", certificateType: "Vaccination", description: [Description(lang: "en", desc: "Hello")], validFrom: "2020-06-01T00:00:00Z", validTo: "2030-06-01T00:00:00Z", affectedString: ["v.0.ma"], logic: JSON("""
                            {">":["1","1"]}
                        """), countryCode: "DE")
        
        let rule2 = Rule(identifier: "VR-DE-0001", type: "Acceptance", version: "1.0.1", schemaVersion: "1.0.0", engine: "CERTLOGIC", engineVersion: "1.0.0", certificateType: "Vaccination", description: [Description(lang: "en", desc: "Hello")], validFrom: "2020-06-01T00:00:00Z", validTo: "2030-06-01T00:00:00Z", affectedString: ["v.0.ma"], logic: JSON("""
                            {"==":["1","1"]}
                        """), countryCode: "DE")
        
        let rule3 = Rule(identifier: "VR-DE-0002", type: "Acceptance", version: "2.0.1", schemaVersion: "1.0.0", engine: "CERTLOGIC", engineVersion: "1.0.0", certificateType: "Vaccination", description: [Description(lang: "en", desc: "Hello")], validFrom: "2020-06-01T00:00:00Z", validTo: "2030-06-01T00:00:00Z", affectedString: ["v.0.ma"], logic: JSON("""
                            {"==":["1","1"]}
                        """), countryCode: "DE")
        
        let rule4 = Rule(identifier: "VR-DE-0003", type: "Acceptance", version: "0.0.1", schemaVersion: "1.0.0", engine: "CERTLOGIC", engineVersion: "1.0.0", certificateType: "Vaccination", description: [Description(lang: "en", desc: "Hello")], validFrom: "2020-06-01T00:00:00Z", validTo: "2030-06-01T00:00:00Z", affectedString: ["v.0.ma"], logic: JSON("""
                            {">":["1","1"]}
                        """), countryCode: "DE")
        
        let rule5 = Rule(identifier: "VR-DE-0003", type: "Acceptance", version: "3.0.1", schemaVersion: "1.0.0", engine: "CERTLOGIC", engineVersion: "1.0.0", certificateType: "Vaccination", description: [Description(lang: "en", desc: "Hello")], validFrom: "2020-06-01T00:00:00Z", validTo: "2030-06-01T00:00:00Z", affectedString: ["v.0.ma"], logic: JSON("""
                            {"==":["1","1"]}
                        """), countryCode: "DE")
        
        let engine = CertLogicEngine(schema: euDgcSchemaV1, rules: [rule1,rule2])
        
        let result = engine.validate(filter: filter,external: external, payload: """
                                                                        {"ver":"1.0.0"}
                                                                  """)
        
        XCTAssertTrue(result[0].result == .passed)
        XCTAssertTrue(result.count==1)
    }
    
    func testRuleWrongEngine()
    {
        let filter = FilterParameter(validationClock: Date.init(), countryCode: "DE", certificationType: CertificateType.vaccination, region: nil)
        
        let external = ExternalParameter(validationClock: Date.init(), valueSets: [:], exp:Date.distantFuture , iat: Date.distantPast, issuerCountryCode: "AT")
        
        
        let rule1 = Rule(identifier: "VR-DE-0001", type: "Acceptance", version: "1.0.0", schemaVersion: "1.0.0", engine: "MYENGINE", engineVersion: "1.0.0", certificateType: "Vaccination", description: [Description(lang: "en", desc: "Hello")], validFrom: "2020-06-01T00:00:00Z", validTo: "2030-06-01T00:00:00Z", affectedString: ["v.0.ma"], logic: JSON("""
                            {">":["1","1"]}
                        """), countryCode: "DE")
        
        let engine = CertLogicEngine(schema: euDgcSchemaV1, rules: [rule1])
        
        let result = engine.validate(filter: filter,external: external, payload: """
                                                                        {"ver":"1.0.0"}
                                                                  """)
        
        XCTAssertTrue(result[0].result == .open)
        XCTAssertTrue(result.count==1)
    }
    
    func testRulengineVersion()
    {
        let filter = FilterParameter(validationClock: Date.init(), countryCode: "DE", certificationType: CertificateType.vaccination, region: nil)
        
        let external = ExternalParameter(validationClock: Date.init(), valueSets: [:], exp:Date.distantFuture , iat: Date.distantPast, issuerCountryCode: "AT")
        
        
        let rule1 = Rule(identifier: "VR-DE-0001", type: "Acceptance", version: "1.0.0", schemaVersion: "1.0.0", engine: "CERTLOGIC", engineVersion: "0.7.5", certificateType: "Vaccination", description: [Description(lang: "en", desc: "Hello")], validFrom: "2020-06-01T00:00:00Z", validTo: "2030-06-01T00:00:00Z", affectedString: ["v.0.ma"], logic: JSON("""
                            {"==":["1","1"]}
                        """), countryCode: "DE")
        
        
        let rule2 = Rule(identifier: "VR-DE-0002", type: "Acceptance", version: "1.0.0", schemaVersion: "1.0.0", engine: "CERTLOGIC", engineVersion: "1.0.1", certificateType: "Vaccination", description: [Description(lang: "en", desc: "Hello")], validFrom: "2020-06-01T00:00:00Z", validTo: "2030-06-01T00:00:00Z", affectedString: ["v.0.ma"], logic: JSON("""
                            {"==":["1","1"]}
                        """), countryCode: "DE")
        
        let engine = CertLogicEngine(schema: euDgcSchemaV1, rules: [rule1, rule2])
        
        let result = engine.validate(filter: filter,external: external, payload: """
                                                                        {"ver":"1.0.0"}
                                                                  """)
        
        XCTAssertTrue(result[0].result == .passed)
        XCTAssertTrue(result[1].result == .open)
        XCTAssertTrue(result.count==2)
    }
    
    func testRuleSchemaVersioning()
    {
        let filter = FilterParameter(validationClock: Date.init(), countryCode: "DE", certificationType: CertificateType.vaccination, region: nil)
        
        let external = ExternalParameter(validationClock: Date.init(), valueSets: [:], exp:Date.distantFuture , iat: Date.distantPast, issuerCountryCode: "AT")
        
        
        let rule1 = Rule(identifier: "VR-DE-0001", type: "Acceptance", version: "1.0.0", schemaVersion: "1.4.0", engine: "CERTLOGIC", engineVersion: "1.0.0", certificateType: "Vaccination", description: [Description(lang: "en", desc: "Hello")], validFrom: "2020-06-01T00:00:00Z", validTo: "2030-06-01T00:00:00Z", affectedString: ["v.0.ma"], logic: JSON("""
                            {"==":["1","1"]}
                        """), countryCode: "DE")
        
        let rule2 = Rule(identifier: "VR-DE-0002", type: "Acceptance", version: "1.0.0", schemaVersion: "1.3.0", engine: "CERTLOGIC", engineVersion: "1.0.0", certificateType: "Vaccination", description: [Description(lang: "en", desc: "Hello")], validFrom: "2020-06-01T00:00:00Z", validTo: "2030-06-01T00:00:00Z", affectedString: ["v.0.ma"], logic: JSON("""
                            {"==":["1","1"]}
                        """), countryCode: "DE")
        
        let rule3 = Rule(identifier: "VR-DE-0003", type: "Acceptance", version: "1.0.0", schemaVersion: "1.1.0", engine: "CERTLOGIC", engineVersion: "1.0.0", certificateType: "Vaccination", description: [Description(lang: "en", desc: "Hello")], validFrom: "2020-06-01T00:00:00Z", validTo: "2030-06-01T00:00:00Z", affectedString: ["v.0.ma"], logic: JSON("""
                            {"==":["1","1"]}
                        """), countryCode: "DE")
        
        let engine = CertLogicEngine(schema: euDgcSchemaV1, rules: [rule1,rule2,rule3])
        
        let result = engine.validate(filter: filter,external: external, payload: """
                                                                        {"ver":"1.3.0"}
                                                                  """)
        
        result.forEach { result in
            if(result.rule?.identifier == "VR-DE-0001")
            {
                XCTAssertTrue(result.result == .open)
            }
            if(result.rule?.identifier == "VR-DE-0002")
            {
                XCTAssertTrue(result.result == .passed)
            }
            if(result.rule?.identifier == "VR-DE-0003")
            {
                XCTAssertTrue(result.result == .passed)
            }
        }
    }
    
    func testWrongEngineVersion()
    {
        let filter = FilterParameter(validationClock: Date.init(), countryCode: "DE", certificationType: CertificateType.vaccination, region: nil)
        
        let external = ExternalParameter(validationClock: Date.init(), valueSets: [:], exp:Date.distantFuture , iat: Date.distantPast, issuerCountryCode: "AT")
        
        
        let rule1 = Rule(identifier: "VR-DE-0001", type: "Acceptance", version: "1.0.0", schemaVersion: "1.0.0", engine: "MYENGINE", engineVersion: "8.0.0", certificateType: "Vaccination", description: [Description(lang: "en", desc: "Hello")], validFrom: "2020-06-01T00:00:00Z", validTo: "2030-06-01T00:00:00Z", affectedString: ["v.0.ma"], logic: JSON("""
                            {">":["1","1"]}
                        """), countryCode: "DE")
        
        let engine = CertLogicEngine(schema: euDgcSchemaV1, rules: [rule1])
        
        let result = engine.validate(filter: filter, external: external, payload: """
                                                                        {"ver":"1.0.0"}
                                                                  """)
        
        XCTAssertTrue(result[0].result == .open)
        XCTAssertTrue(result.count==1)
    }
    
    func testRuleWrongSchema()
    {
        let filter = FilterParameter(validationClock: Date.init(), countryCode: "DE", certificationType: CertificateType.vaccination, region: nil)
        
        let external = ExternalParameter(validationClock: Date.init(), valueSets: [:], exp:Date.distantFuture , iat: Date.distantPast, issuerCountryCode: "AT")
        
        
        let rule1 = Rule(identifier: "VR-DE-0001", type: "Acceptance", version: "1.0.0", schemaVersion: "8.0.0", engine: "MYENGINE", engineVersion: "1.0.0", certificateType: "Vaccination", description: [Description(lang: "en", desc: "Hello")], validFrom: "2020-06-01T00:00:00Z", validTo: "2030-06-01T00:00:00Z", affectedString: ["v.0.ma"], logic: JSON("""
                            {">":["1","1"]}
                        """), countryCode: "DE")
        
        let engine = CertLogicEngine(schema: euDgcSchemaV1, rules: [rule1])
        
        let result = engine.validate(filter: filter,external: external, payload: """
                                                                        {"ver":"1.0.0"}
                                                                  """)
        
        XCTAssertTrue(result[0].result == .open)
        XCTAssertTrue(result.count==1)
    }
    
    func testRuleLogicError()
    {
        let filter = FilterParameter(validationClock: Date.init(), countryCode: "DE", certificationType: CertificateType.vaccination, region: nil)
        
        let external = ExternalParameter(validationClock: Date.init(), valueSets: [:], exp:Date.distantFuture , iat: Date.distantPast, issuerCountryCode: "AT")
        
        
        let rule1 = Rule(identifier: "VR-DE-0001", type: "Acceptance", version: "1.0.0", schemaVersion: "1.0.0", engine: "CERTLOGIC", engineVersion: "1.0.0", certificateType: "Vaccination", description: [Description(lang: "en", desc: "Hello")], validFrom: "2020-06-01T00:00:00Z", validTo: "2030-06-01T00:00:00Z", affectedString: ["v.0.ma"], logic: JSON("""
                            {">":["1"}
                        """), countryCode: "DE")
        
        let engine = CertLogicEngine(schema: euDgcSchemaV1, rules: [rule1])
        
        let result = engine.validate(filter: filter, external: external, payload: """
                                                                        {"ver":"1.0.0"}
                                                                  """)
        
        XCTAssertTrue(result[0].result == .open)
        XCTAssertTrue(result.count==1)
    }
    
    func testSimpleRuleSuccessFullExecution()
    {
        let filter = FilterParameter(validationClock: Date.init(), countryCode: "DE", certificationType: CertificateType.vaccination, region: nil)
        
        let external = ExternalParameter(validationClock: Date.init(), valueSets: [:], exp:Date.distantFuture , iat: Date.distantPast, issuerCountryCode: "AT")
        
        
        let rule1 = Rule(identifier: "VR-DE-0001", type: "Acceptance", version: "1.0.0", schemaVersion: "1.0.0", engine: "CERTLOGIC", engineVersion: "1.0.0", certificateType: "Vaccination", description: [Description(lang: "en", desc: "Hello")], validFrom: "2020-06-01T00:00:00Z", validTo: "2030-06-01T00:00:00Z", affectedString: ["v.0.ma"], logic: JSON("""
                            {"==":[{"var":"payload.v.0.ma"},"123"]}
                        """), countryCode: "DE")
                
        let engine = CertLogicEngine(schema: euDgcSchemaV1, rules: [rule1])
        
        let result = engine.validate(filter: filter,external: external, payload: """
                                                                        {"ver":"1.0.0","v":[{"ma":"123"}]}
                                                                  """)
        
        XCTAssertTrue(result[0].result == .passed)
        XCTAssertTrue(result.count==1)
    }
    
    func testMixedStates()
    {
        let filter = FilterParameter(validationClock: Date.init(), countryCode: "DE", certificationType: CertificateType.vaccination, region: nil)
        
        let external = ExternalParameter(validationClock: Date.init(), valueSets: [:], exp:Date.distantFuture , iat: Date.distantPast, issuerCountryCode: "AT")
        
        
        let rule1 = Rule(identifier: "VR-DE-0001", type: "Acceptance", version: "1.0.0", schemaVersion: "1.0.0", engine: "CERTLOGIC", engineVersion: "1.0.0", certificateType: "Vaccination", description: [Description(lang: "en", desc: "Hello")], validFrom: "2020-06-01T00:00:00Z", validTo: "2030-06-01T00:00:00Z", affectedString: ["v.0.ma"], logic: JSON("""
                            {">":[{"var":"payload.v.0.ma"},"123"]}
                        """), countryCode: "DE")
        
        let rule2 = Rule(identifier: "VR-DE-0002", type: "Acceptance", version: "1.0.0", schemaVersion: "8.0.0", engine: "MYENGINE", engineVersion: "1.0.0", certificateType: "Vaccination", description: [Description(lang: "en", desc: "Hello")], validFrom: "2020-06-01T00:00:00Z", validTo: "2030-06-01T00:00:00Z", affectedString: ["v.0.ma"], logic: JSON("""
                            {">":[{"var":"payload.v.0.ma"},"123"]}
                        """), countryCode: "DE")
        
        let rule3 = Rule(identifier: "VR-DE-0003", type: "Acceptance", version: "1.0.0", schemaVersion: "1.0.0", engine: "CERTLOGIC", engineVersion: "1.0.0", certificateType: "Vaccination", description: [Description(lang: "en", desc: "Hello")], validFrom: "2020-06-01T00:00:00Z", validTo: "2030-06-01T00:00:00Z", affectedString: ["v.0.ma"], logic: JSON("""
                            {"==":[{"var":"payload.v.0.ma"},"123"]}
                        """), countryCode: "DE")
                
        let engine = CertLogicEngine(schema: euDgcSchemaV1, rules: [rule1,rule2,rule3])
        
        let result = engine.validate(filter: filter, external: external, payload: """
                                                                        {"ver":"1.0.0","v":[{"ma":"123"}]}
                                                                  """)
        
        result.forEach { result in
            if(result.rule?.identifier == "VR-DE-0001")
            {
                XCTAssertTrue(result.result == .fail)
            }
            if(result.rule?.identifier == "VR-DE-0002")
            {
                XCTAssertTrue(result.result == .open)
            }
            if(result.rule?.identifier == "VR-DE-0003")
            {
                XCTAssertTrue(result.result == .passed)
            }
        }
    }
    
    func testSimpleFailedExecution()
    {
        let filter = FilterParameter(validationClock: Date.init(), countryCode: "DE", certificationType: CertificateType.vaccination, region: nil)
        
        let external = ExternalParameter(validationClock: Date.init(), valueSets: [:], exp:Date.distantFuture , iat: Date.distantPast, issuerCountryCode: "AT")
        
        
        let rule1 = Rule(identifier: "VR-DE-0001", type: "Acceptance", version: "1.0.0", schemaVersion: "1.0.0", engine: "CERTLOGIC", engineVersion: "1.0.0", certificateType: "Vaccination", description: [Description(lang: "en", desc: "Hello")], validFrom: "2020-06-01T00:00:00Z", validTo: "2030-06-01T00:00:00Z", affectedString: ["v.0.ma"], logic: JSON("""
                            {">":[{"var":"payload.v.0.ma"},"123"]}
                        """), countryCode: "DE")
                
        let engine = CertLogicEngine(schema: euDgcSchemaV1, rules: [rule1])
        
        let result = engine.validate(filter: filter,external: external, payload: """
                                                                        {"ver":"1.0.0","v":[{"ma":"123"}]}
                                                                  """)
        
        XCTAssertTrue(result[0].result == .fail)
        XCTAssertTrue(result.count==1)
    }
    
    func testSimpleExternalExecution()
    {
        let filter = FilterParameter(validationClock: Date.init(), countryCode: "DE", certificationType: CertificateType.vaccination, region: nil)
        
        let external = ExternalParameter(validationClock: Date.init(), valueSets: [:], exp:Date.distantFuture , iat: Date.distantPast, issuerCountryCode: "AT", kid: "abc123")
        
        
        let rule1 = Rule(identifier: "VR-DE-0001", type: "Acceptance", version: "1.0.0", schemaVersion: "1.0.0", engine: "CERTLOGIC", engineVersion: "1.0.0", certificateType: "Vaccination", description: [Description(lang: "en", desc: "Hello")], validFrom: "2020-06-01T00:00:00Z", validTo: "2030-06-01T00:00:00Z", affectedString: ["v.0.ma"], logic: JSON("""
                            {"==":[{"var":"external.kid"},"abc123"]}
                        """), countryCode: "DE")
                
        let engine = CertLogicEngine(schema: euDgcSchemaV1, rules: [rule1])
        
        let result = engine.validate(filter: filter,external: external, payload: """
                                                                        {"ver":"1.0.0","v":[{"ma":"123"}]}
                                                                  """)
        
        XCTAssertTrue(result[0].result == .passed)
        XCTAssertTrue(result.count==1)
    }
    
    func testSimpleRuleExecutionWithWrongType()
    {
        let filter = FilterParameter(validationClock: Date.init(), countryCode: "DE", certificationType: CertificateType.vaccination, region: nil)
        
        let external = ExternalParameter(validationClock: Date.init(), valueSets: [:], exp:Date.distantFuture , iat: Date.distantPast, issuerCountryCode: "AT")
        
        
        let rule1 = Rule(identifier: "VR-DE-0001", type: "Acceptance", version: "1.0.0", schemaVersion: "1.0.0", engine: "CERTLOGIC", engineVersion: "1.0.0", certificateType: "Recovery", description: [Description(lang: "en", desc: "Hello")], validFrom: "2020-06-01T00:00:00Z", validTo: "2030-06-01T00:00:00Z", affectedString: ["v.0.ma"], logic: JSON("""
                            {"==":[{"var":"payload.v.0.ma"},"123"]}
                        """), countryCode: "DE")
                
        let engine = CertLogicEngine(schema: euDgcSchemaV1, rules: [rule1])
        
        let result = engine.validate(filter: filter,external: external, payload: """
                                                                        {"ver":"1.0.0","v":[{"ma":"123"}]}
                                                                  """)
        
        XCTAssertTrue(result.count == 0)
    }
    
    func testSimpleRuleExecutionWithGeneralType()
    {
        let filter = FilterParameter(validationClock: Date.init(), countryCode: "DE", certificationType: CertificateType.vaccination, region: nil)
        
        let external = ExternalParameter(validationClock: Date.init(), valueSets: [:], exp:Date.distantFuture , iat: Date.distantPast, issuerCountryCode: "AT")
        
        
        let rule1 = Rule(identifier: "GR-DE-0001", type: "Acceptance", version: "1.0.0", schemaVersion: "1.0.0", engine: "CERTLOGIC", engineVersion: "1.0.0", certificateType: "General", description: [Description(lang: "en", desc: "Hello")], validFrom: "2020-06-01T00:00:00Z", validTo: "2030-06-01T00:00:00Z", affectedString: ["v.0.ma"], logic: JSON("""
                            {"==":[{"var":"payload.v.0.ma"},"123"]}
                        """), countryCode: "DE")
                
        let engine = CertLogicEngine(schema: euDgcSchemaV1, rules: [rule1])
        
        let result = engine.validate(filter: filter,external: external, payload: """
                                                                        {"ver":"1.0.0","v":[{"ma":"123"}]}
                                                                  """)
        
        XCTAssertTrue(result[0].result == .passed)
        XCTAssertTrue(result.count==1)
    }
    
    func testRuleExecutionWithGeneralTypeAndVaccination()
    {
        let filter = FilterParameter(validationClock: Date.init(), countryCode: "DE", certificationType: CertificateType.vaccination, region: nil)
        
        let external = ExternalParameter(validationClock: Date.init(), valueSets: [:], exp:Date.distantFuture , iat: Date.distantPast, issuerCountryCode: "AT")
        
        
        let rule1 = Rule(identifier: "GR-DE-0001", type: "Acceptance", version: "1.0.0", schemaVersion: "1.0.0", engine: "CERTLOGIC", engineVersion: "1.0.0", certificateType: "General", description: [Description(lang: "en", desc: "Hello")], validFrom: "2020-06-01T00:00:00Z", validTo: "2030-06-01T00:00:00Z", affectedString: ["v.0.ma"], logic: JSON("""
                            {"==":[{"var":"payload.v.0.ma"},"123"]}
                        """), countryCode: "DE")
        
        let rule2 = Rule(identifier: "VR-DE-0001", type: "Acceptance", version: "1.0.0", schemaVersion: "1.0.0", engine: "CERTLOGIC", engineVersion: "1.0.0", certificateType: "Vaccination", description: [Description(lang: "en", desc: "Hello")], validFrom: "2020-06-01T00:00:00Z", validTo: "2030-06-01T00:00:00Z", affectedString: ["v.0.ma"], logic: JSON("""
                            {"==":[{"var":"payload.v.0.ma"},"123"]}
                        """), countryCode: "DE")
                
        let engine = CertLogicEngine(schema: euDgcSchemaV1, rules: [rule1,rule2])
        
        let result = engine.validate(filter: filter,external: external, payload: """
                                                                        {"ver":"1.0.0","v":[{"ma":"123"}]}
                                                                  """)
        
        XCTAssertTrue(result[0].result == .passed)
        XCTAssertTrue(result[1].result == .passed)
        XCTAssertTrue(result.count==2)
    }
    
    func testRuleExpired()
    {
        let filter = FilterParameter(validationClock: Date.init(), countryCode: "DE", certificationType: CertificateType.vaccination, region: nil)
        
        let external = ExternalParameter(validationClock: Date.init(), valueSets: [:], exp:Date.distantPast , iat: Date.distantPast, issuerCountryCode: "AT")
        
        
        let rule1 = Rule(identifier: "GR-DE-0001", type: "Acceptance", version: "1.0.0", schemaVersion: "1.0.0", engine: "CERTLOGIC", engineVersion: "1.0.0", certificateType: "General", description: [Description(lang: "en", desc: "Hello")], validFrom: "1990-06-01T00:00:00Z", validTo: "1991-06-01T00:00:00Z", affectedString: ["v.0.ma"], logic: JSON("""
                            {"==":[{"var":"payload.v.0.ma"},"123"]}
                        """), countryCode: "DE")
        
        let rule2 = Rule(identifier: "VR-DE-0001", type: "Acceptance", version: "1.0.0", schemaVersion: "1.0.0", engine: "CERTLOGIC", engineVersion: "1.0.0", certificateType: "Vaccination", description: [Description(lang: "en", desc: "Hello")], validFrom: "1991-06-01T00:00:00Z", validTo: "1990-06-01T00:00:00Z", affectedString: ["v.0.ma"], logic: JSON("""
                            {"==":[{"var":"payload.v.0.ma"},"123"]}
                        """), countryCode: "DE")
                
        let engine = CertLogicEngine(schema: euDgcSchemaV1, rules: [rule1,rule2])
        
        let result = engine.validate(filter: filter,external: external, payload: """
                                                                        {"ver":"1.0.0","v":[{"ma":"123"}]}
                                                                  """)
        
        XCTAssertTrue(result.count == 0)
    }
    
    func testRulePartiallyExpired()
    {
        let filter = FilterParameter(validationClock: Date.init(), countryCode: "DE", certificationType: CertificateType.vaccination, region: nil)
        
        let external = ExternalParameter(validationClock: Date(), valueSets: [:], exp:Date.distantFuture, iat: Date.distantPast, issuerCountryCode: "AT")
        
        
        let rule1 = Rule(identifier: "GR-DE-0001", type: "Acceptance", version: "1.0.0", schemaVersion: "1.0.0", engine: "CERTLOGIC", engineVersion: "1.0.0", certificateType: "General", description: [Description(lang: "en", desc: "Hello")], validFrom: "1990-06-01T00:00:00Z", validTo: "1991-06-01T00:00:00Z", affectedString: ["v.0.ma"], logic: JSON("""
                            {"==":[{"var":"payload.v.0.ma"},"123"]}
                        """), countryCode: "DE")
        
        let rule2 = Rule(identifier: "VR-DE-0001", type: "Acceptance", version: "1.0.0", schemaVersion: "1.0.0", engine: "CERTLOGIC", engineVersion: "1.0.0", certificateType: "Vaccination", description: [Description(lang: "en", desc: "Hello")], validFrom: "1991-06-01T00:00:00Z", validTo: "2030-06-01T00:00:00Z", affectedString: ["v.0.ma"], logic: JSON("""
                            {"==":[{"var":"payload.v.0.ma"},"123"]}
                        """), countryCode: "DE")
                
        let engine = CertLogicEngine(schema: euDgcSchemaV1, rules: [rule1,rule2])
        
        let result = engine.validate(filter: filter,external: external, payload: """
                                                                        {"ver":"1.0.0","v":[{"ma":"123"}]}
                                                                  """)
        
        XCTAssertTrue(result[0].result == .passed)
        XCTAssertTrue(result.count==1)
    }
    
    func testAcceptanceAndInvalidation()
    {
        let filter = FilterParameter(validationClock: Date.init(), countryCode: "DE", certificationType: CertificateType.vaccination, region: nil)
        
        let external = ExternalParameter(validationClock: Date(), valueSets: [:], exp:Date.distantFuture, iat: Date.distantPast, issuerCountryCode: "AT")
        
        
        let rule1 = Rule(identifier: "GR-DE-0001", type: "Acceptance", version: "1.0.0", schemaVersion: "1.0.0", engine: "CERTLOGIC", engineVersion: "1.0.0", certificateType: "General", description: [Description(lang: "en", desc: "Hello")], validFrom: "1990-06-01T00:00:00Z", validTo: "1991-06-01T00:00:00Z", affectedString: ["v.0.ma"], logic: JSON("""
                            {"==":[{"var":"payload.v.0.ma"},"123"]}
                        """), countryCode: "DE")
        
        let rule2 = Rule(identifier: "IR-AT-0001", type: "Invalidation", version: "1.0.0", schemaVersion: "1.0.0", engine: "CERTLOGIC", engineVersion: "1.0.0", certificateType: "Vaccination", description: [Description(lang: "en", desc: "Hello")], validFrom: "1991-06-01T00:00:00Z", validTo: "2030-06-01T00:00:00Z", affectedString: ["v.0.ma"], logic: JSON("""
                            {"==":[{"var":"payload.v.0.ma"},"123"]}
                        """), countryCode: "AT")
                
        let engine = CertLogicEngine(schema: euDgcSchemaV1, rules: [rule1,rule2])
        
        let result = engine.validate(filter: filter,external: external, payload: """
                                                                        {"ver":"1.0.0","v":[{"ma":"123"}]}
                                                                  """)
        
        XCTAssertTrue(result[0].result == .passed)
        XCTAssertTrue(result.count==1)
    }
    
    func testAcceptanceAndInvalidationFail()
    {
        let filter = FilterParameter(validationClock: Date.init(), countryCode: "DE", certificationType: CertificateType.vaccination, region: nil)
        
        let external = ExternalParameter(validationClock: Date(), valueSets: [:], exp:Date.distantFuture, iat: Date.distantPast, issuerCountryCode: "AT")
        
        
        let rule1 = Rule(identifier: "GR-DE-0001", type: "Acceptance", version: "1.0.0", schemaVersion: "1.0.0", engine: "CERTLOGIC", engineVersion: "1.0.0", certificateType: "General", description: [Description(lang: "en", desc: "Hello")], validFrom: "1990-06-01T00:00:00Z", validTo: "2030-06-01T00:00:00Z", affectedString: ["v.0.ma"], logic: JSON("""
                            {"==":[{"var":"payload.v.0.ma"},"123"]}
                        """), countryCode: "DE")
        
        let rule2 = Rule(identifier: "IR-AT-0001", type: "Invalidation", version: "1.0.0", schemaVersion: "1.0.0", engine: "CERTLOGIC", engineVersion: "1.0.0", certificateType: "Vaccination", description: [Description(lang: "en", desc: "Hello")], validFrom: "1991-06-01T00:00:00Z", validTo: "2030-06-01T00:00:00Z", affectedString: ["v.0.ma"], logic: JSON("""
                            {">":[{"var":"payload.v.0.ma"},"123"]}
                        """), countryCode: "AT")
                
        let engine = CertLogicEngine(schema: euDgcSchemaV1, rules: [rule1,rule2])
        
        let result = engine.validate(filter: filter,external: external, payload: """
                                                                        {"ver":"1.0.0","v":[{"ma":"123"}]}
                                                                  """)
        XCTAssertTrue(result[0].result == .passed)
        XCTAssertTrue(result[1].result == .fail)
    }
    
    func testAcceptanceAndInvalidationWithWrongType()
    {
        let filter = FilterParameter(validationClock: Date.init(), countryCode: "DE", certificationType: CertificateType.vaccination, region: nil)
        
        let external = ExternalParameter(validationClock: Date(), valueSets: [:], exp:Date.distantFuture, iat: Date.distantPast, issuerCountryCode: "AT")
        
        
        let rule1 = Rule(identifier: "GR-DE-0001", type: "Acceptance", version: "1.0.0", schemaVersion: "1.0.0", engine: "CERTLOGIC", engineVersion: "1.0.0", certificateType: "General", description: [Description(lang: "en", desc: "Hello")], validFrom: "1990-06-01T00:00:00Z", validTo: "2030-06-01T00:00:00Z", affectedString: ["v.0.ma"], logic: JSON("""
                            {"==":[{"var":"payload.v.0.ma"},"123"]}
                        """), countryCode: "DE")
        
        let rule2 = Rule(identifier: "IR-AT-0001", type: "Invalidation", version: "1.0.0", schemaVersion: "1.0.0", engine: "CERTLOGIC", engineVersion: "1.0.0", certificateType: "Recovery", description: [Description(lang: "en", desc: "Hello")], validFrom: "1991-06-01T00:00:00Z", validTo: "2030-06-01T00:00:00Z", affectedString: ["v.0.ma"], logic: JSON("""
                            {">":[{"var":"payload.v.0.ma"},"123"]}
                        """), countryCode: "AT")
                
        let engine = CertLogicEngine(schema: euDgcSchemaV1, rules: [rule1,rule2])
        
        let result = engine.validate(filter: filter,external: external, payload: """
                                                                        {"ver":"1.0.0","v":[{"ma":"123"}]}
                                                                  """)
        XCTAssertTrue(result[0].result == .passed)
        XCTAssertTrue(result.count==1)
    }
    
    func testWithRegion()
    {
        let filter = FilterParameter(validationClock: Date.init(), countryCode: "DE", certificationType: CertificateType.vaccination, region: "10")
        
        let external = ExternalParameter(validationClock: Date(), valueSets: [:], exp:Date.distantFuture, iat: Date.distantPast, issuerCountryCode: "AT")
        
        
        let rule1 = Rule(identifier: "GR-DE-0001", type: "Acceptance", version: "1.0.0", schemaVersion: "1.0.0", engine: "CERTLOGIC", engineVersion: "1.0.0", certificateType: "General", description: [Description(lang: "en", desc: "Hello")], validFrom: "1990-06-01T00:00:00Z", validTo: "2030-06-01T00:00:00Z", affectedString: ["v.0.ma"], logic: JSON("""
                            {">":[{"var":"payload.v.0.ma"},"123"]}
                        """), countryCode: "DE")
        
        let rule2 = Rule(identifier: "VR-DE-0001", type: "Acceptance", version: "1.0.0", schemaVersion: "1.0.0", engine: "CERTLOGIC", engineVersion: "1.0.0", certificateType: "Vaccination", description: [Description(lang: "en", desc: "Hello")], validFrom: "1991-06-01T00:00:00Z", validTo: "2030-06-01T00:00:00Z", affectedString: ["v.0.ma"], logic: JSON("""
                            {"==":[{"var":"payload.v.0.ma"},"123"]}
                        """), countryCode: "DE",region: "10")
                
        let engine = CertLogicEngine(schema: euDgcSchemaV1, rules: [rule1,rule2])
        
        let result = engine.validate(filter: filter,external: external, payload: """
                                                                        {"ver":"1.0.0","v":[{"ma":"123"}]}
                                                                  """)
        
        XCTAssertTrue(result[0].result == .passed)
        XCTAssertTrue(result.count==1)
    }
    
    func testWithRegionAndInvalidation()
    {
        let filter = FilterParameter(validationClock: Date.init(), countryCode: "DE", certificationType: CertificateType.vaccination, region: "10")
        
        let external = ExternalParameter(validationClock: Date(), valueSets: [:], exp:Date.distantFuture, iat: Date.distantPast, issuerCountryCode: "AT")
        
        
        let rule1 = Rule(identifier: "IR-DE-0001", type: "Invalidation", version: "1.0.0", schemaVersion: "1.0.0", engine: "CERTLOGIC", engineVersion: "1.0.0", certificateType: "General", description: [Description(lang: "en", desc: "Hello")], validFrom: "1990-06-01T00:00:00Z", validTo: "2030-06-01T00:00:00Z", affectedString: ["v.0.ma"], logic: JSON("""
                            {">":[{"var":"payload.v.0.ma"},"123"]}
                        """), countryCode: "AT")
        
        let rule2 = Rule(identifier: "VR-DE-0001", type: "Acceptance", version: "1.0.0", schemaVersion: "1.0.0", engine: "CERTLOGIC", engineVersion: "1.0.0", certificateType: "Vaccination", description: [Description(lang: "en", desc: "Hello")], validFrom: "1991-06-01T00:00:00Z", validTo: "2030-06-01T00:00:00Z", affectedString: ["v.0.ma"], logic: JSON("""
                            {"==":[{"var":"payload.v.0.ma"},"123"]}
                        """), countryCode: "DE",region: "10")
                
        let engine = CertLogicEngine(schema: euDgcSchemaV1, rules: [rule1,rule2])
        
        let result = engine.validate(filter: filter, external: external, payload: """
                                                                        {"ver":"1.0.0","v":[{"ma":"123"}]}
                                                                  """)
        
        if(result.count < 2)
        {
            XCTFail()
            return
        }
        
        XCTAssertTrue(result[0].result == .fail)
        XCTAssertTrue(result[1].result == .passed)
    }
    
}


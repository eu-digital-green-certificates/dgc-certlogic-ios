import XCTest
@testable import CertLogic
    
final class CertLogicTests: XCTestCase {
  func testExample() {
    // swiftlint:disable line_length
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
    
        let external =
          """
          {
              "validationClock": "2021-06-14T17:07:36.622",
              "valueSets": {
              },
              "countryCode": "ua",
              "exp": "2021-07-14T17:07:36.622",
              "iat": "2021-05-14T17:07:36.622"
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
        
        let rulesString =
          """
          [
            {
              "Identifier": "GR-CZ-0001",
              "Version": "1.0.0",
              "SchemaVersion": "1.0.0",
              "Engine": "CERTLOGIC",
              "EngineVersion": "2.0.1",
              "Type": "Acceptance",
              "CertificateType": "Test",
              "Country": "ua",
              "Description": [
                {
                  "lang": "en",
                  "desc": "The Field “Doses” MUST contain number 2 OR 2/2."
                }
              ],
              "ValidFrom": "2021-05-27T00:00:00Z",
              "ValidTo": "2021-08-01T00:00:00Z",
              "AffectedFields": [
                "dt",
                "nm"
              ],
              "Logic": {"and":[{">=":[{"var":"dt"},"23.12.2012"]},{">=":[{"var":"nm"},"ABC"]}]}
          },
          {
              "Identifier": "GR-CZ-0001",
              "Version": "1.0.0",
              "SchemaVersion": "1.0.0",
              "Engine": "CERTLOGIC",
              "EngineVersion": "2.0.1",
              "Type": "Acceptance",
              "CertificateType": "General",
              "Country": "ua",
              "Description": [
                {
                  "lang": "en",
                  "desc": "The Field “Doses” MUST contain number 2 OR 2/2."
                }
              ],
              "ValidFrom": "2021-05-27T00:00:00Z",
              "ValidTo": "2021-08-01T00:00:00Z",
              "AffectedFields": [
                "dt",
                "nm"
              ],
              "Logic": {"and":[{">=":[{"var":"dt"},"23.12.2012"]},{">=":[{"var":"nm"},"ABC"]}]}
          },
          {
              "Identifier": "GR-CZ-0001",
              "Version": "1.1.0",
              "SchemaVersion": "1.0.0",
              "Engine": "CERTLOGIC",
              "EngineVersion": "2.0.1",
              "Type": "Acceptance",
              "CertificateType": "General",
              "Country": "ua",
              "Description": [
                {
                  "lang": "en",
                  "desc": "The Field “Doses” MUST contain number 2 OR 2/2."
                }
              ],
              "ValidFrom": "2021-05-27T00:00:00Z",
              "ValidTo": "2021-08-01T00:00:00Z",
              "AffectedFields": [
                "dt",
                "nm"
              ],
              "Logic": {"and":[{">=":[{"var":"dt"},"23.12.2012"]},{">=":[{"var":"nm"},"ABC"]}]}
          },{
              "Identifier": "GR-UA-0002",
              "Version": "1.0.0",
              "SchemaVersion": "1.0.0",
              "Engine": "CERTLOGIC",
              "EngineVersion": "2.0.1",
              "Type": "Acceptance",
              "CertificateType": "Test",
              "Country": "ua",
              "Description": [
                {
                  "lang": "en",
                  "desc": "The Field “Doses” MUST contain number 2 OR 2/2."
                }
              ],
              "ValidFrom": "2021-05-27T00:00:00Z",
              "ValidTo": "2021-08-01T0T00:00:00Z",
              "AffectedFields": [
                "dt",
                "nm"
              ],
              "Logic": {"and":[{">=":[{"var":"dt"},"23.12.2012"]},{">=":[{"var":"nm"},"ABC"]}]}
          },
            {
              "Identifier": "GR-UA-0003",
              "Version": "1.0.0",
              "SchemaVersion": "1.0.0",
              "Engine": "CERTLOGIC",
              "EngineVersion": "2.0.1",
              "Type": "Acceptance",
              "CertificateType": "Test",
              "Country": "ua",
              "Description": [
                {
                  "lang": "en",
                  "desc": "The Field “Doses” MUST contain number 2 OR 2/2."
                }
              ],
          "ValidFrom": "2021-05-01T00:00:00Z",
          "ValidTo": "2030-06-01T00:00:00Z",
              "AffectedFields": [
                "dt",
                "nm"
              ],
              "Logic": {"and":[{">=":[{"var":"dt"},"23.12.2012"]},{">=":[{"var":"nm"},"ABC"]}]}
          },
            {
              "Identifier": "GR-UA-0004",
              "Version": "1.0.0",
              "SchemaVersion": "1.0.0",
              "Engine": "CERTLOGIC",
              "EngineVersion": "2.0.1",
              "Type": "Invalidation",
              "CertificateType": "Test",
              "Country": "ua",
              "Description": [
                {
                  "lang": "en",
                  "desc": "The Field “Doses” MUST contain number 2 OR 2/2."
                }
              ],
          "ValidFrom": "2021-05-01T00:00:00Z",
          "ValidTo": "2030-06-01T00:00:00Z",
              "AffectedFields": [
                "dt",
                "nm"
              ],
              "Logic": {"and":[{">=":[{"var":"dt"},"23.12.2012"]},{">=":[{"var":"nm"},"ABC"]}]}
          }
          ]
          """
        
    let valueSetString =
    """
    {
      "valueSetId": "vaccines-covid-19-names",
      "valueSetDate": "2021-04-27",
      "valueSetValues": {
        "EU/1/20/1528": {
          "display": "Comirnaty",
          "lang": "en",
          "active": true,
          "system": "https://ec.europa.eu/health/documents/community-register/html/",
          "version": ""
        },
        "EU/1/20/1507": {
          "display": "COVID-19 Vaccine Moderna",
          "lang": "en",
          "active": true,
          "system": "https://ec.europa.eu/health/documents/community-register/html/",
          "version": ""
        },
        "EU/1/21/1529": {
          "display": "Vaxzevria",
          "lang": "en",
          "active": true,
          "system": "https://ec.europa.eu/health/documents/community-register/html/",
          "version": ""
        },
        "EU/1/20/1525": {
          "display": "COVID-19 Vaccine Janssen",
          "lang": "en",
          "active": true,
          "system": "https://ec.europa.eu/health/documents/community-register/html/",
          "version": ""
        },
        "CVnCoV": {
          "display": "CVnCoV",
          "lang": "en",
          "active": true,
          "system": "http://ec.europa.eu/temp/vaccineproductname",
          "version": "1.0"
        },
        "Sputnik-V": {
          "display": "Sputnik-V",
          "lang": "en",
          "active": true,
          "system": "http://ec.europa.eu/temp/vaccineproductname",
          "version": "1.0"
        },
        "Convidecia": {
          "display": "Convidecia",
          "lang": "en",
          "active": true,
          "system": "http://ec.europa.eu/temp/vaccineproductname",
          "version": "1.0"
        },
        "EpiVacCorona": {
          "display": "EpiVacCorona",
          "lang": "en",
          "active": true,
          "system": "http://ec.europa.eu/temp/vaccineproductname",
          "version": "1.0"
        },
        "BBIBP-CorV": {
          "display": "BBIBP-CorV",
          "lang": "en",
          "active": true,
          "system": "http://ec.europa.eu/temp/vaccineproductname",
          "version": "1.0"
        },
        "Inactivated-SARS-CoV-2-Vero-Cell": {
          "display": "Inactivated SARS-CoV-2 (Vero Cell)",
          "lang": "en",
          "active": true,
          "system": "http://ec.europa.eu/temp/vaccineproductname",
          "version": "1.0"
        },
        "CoronaVac": {
          "display": "CoronaVac",
          "lang": "en",
          "active": true,
          "system": "http://ec.europa.eu/temp/vaccineproductname",
          "version": "1.0"
        },
        "Covaxin": {
          "display": "Covaxin (also known as BBV152 A, B, C)",
          "lang": "en",
          "active": true,
          "system": "http://ec.europa.eu/temp/vaccineproductname",
          "version": "1.0"
        }
      }
    }
    """
    
        // "Logic": "{\\\"and\\\":[{\\\">=\\\":[{\\\"var\\\":\\\"dt\\\"},\\\"23.12.2012\\\"]},{\\\">=\\\":[{\\\"var\\\":\\\"nm\\\"},\\\"ABC\\\"]}]}"
        
        
    if let externalParameter: ExternalParameter = CertLogicEngine.getItem(from: external) {
          let rules: [Rule] = CertLogicEngine.getItems(from: rulesString)
          let valueSet: ValueSet? = CertLogicEngine.getItem(from: valueSetString)
          let engine = CertLogicEngine(schema: euDgcSchemaV1, rules: rules)
          let result = engine.validate(external: externalParameter, payload: payload)
          print("rules: \(rules) \n externalParameter: \(externalParameter) \n result: \(result)")
          
        } else
        { XCTestError.self }
        //            XCTAssertEqual(CertLogic().text, "Hello, World!")
    }
}
    
    

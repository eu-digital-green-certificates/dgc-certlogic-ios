# How-To

We explain how to implement business/validation/verification rules on top of the [Digital COVID Certificate](https://ec.europa.eu/info/live-work-travel-eu/coronavirus-response/safe-covid-19-vaccines-europeans/eu-digital-covid-certificate_en).
From now on, we'll drop the adjectives, and stick to _“Rule”_.


## Concepts

A **rule** in the context of the DCC consists of a logical expression, and some meta data.
The logical expression operates on a specific data structure, and should produce a value`true` or `false`.
Rules are executed by a _CertLogicEngine_.
A `true` result of a rule's execution/evaluation indicates that the rule _“passes”_, while a `false` is grounds for denying fit-for-travel status.

The data structure a rule operates on can be rendered in JSON format as follows:

```json
{
  "payload": <the DCC JSON payload>,
  "external": {
    "valueSets": <the “compressed” value sets>,
    // ...<all other (extra) external parameters>
  }
}
```

The DCC payload JSON _must_ conform to the [DCC JSON Schema](https://github.com/ehn-dcc-development/ehn-dcc-schema/blob/main/DCC.combined-schema.json) (currently at version/release **1.3.0**), as well as to the [technical specification](https://ec.europa.eu/health/sites/default/files/ehealth/docs/covid-certificate_json_specification_en.pdf) for it.

The “compressed” value sets are derived from the [eHN value sets repo](https://github.com/ehn-dcc-development/ehn-dcc-valuesets).
The (extra) external parameters may consist of data like the validation clock.

## Models using in CertLogic:
* Rule
* Description
* External Parameter
* Filter Parameter
* Validation Result
* ValueSet


## Rule

Rule model contains information about rule and can be sended to CertLogic to validate rule

    public enum RuleType: String {
      case acceptence = "Acceptance" - Acceptance Rule Type
      case invalidation = "Invalidation" - Invalidation Rule Type
    }

    public enum CertificateType: String { 
      case general = "General" - Genera Certificate
      case vaccination = "Vaccination" - Vaccination Certificate
      case recovery = "Recovery" - Recovery Certificate
      case test = "Test" - Test Certificate
    }
    
    CertificateType used to convert String to Specific format
    
      public class Rule: Codable {
        public var identifier: String - Rule identifier
        public var type: String - Type of Rule can be Acceptance or Invalidation
        public var version: String - Version of Rule
        public var schemaVersion: String - Schema version using in the rule
        public var engine: String - Engine name now it's only "CertLogic" (not using now)
        public var engineVersion: String - Engine version (not using now)
        public var certificateType: String - Certification Type one of: "General", "Vaccination", "Recovery", "Test"
        public var description: [Description] - Description of rule used for error info
        public var validFrom: String - Valid from in String format received from server
        public var validTo: String - Valid to in String format received from server
        public var affectedString: [String] - Affected sctrings used for get error info
        public var logic: JSON - Rule logic - passed to JSONLogic validator
        public var countryCode: String - Rule country code Example IT - Italy
        public var region: String? - Rule country region code RO - Roma region in Italy
        public var hash: String? - Hash value for rule, received from server
        public var ruleType: RuleType - Rule type in specific format converted from String
        public var certificateFullType: CertificateType - Certificate Type in specific format converted from String
        public var validFromDate: Date - Valid From in Date format converted from String
        public var validToDate: Date - Valid To in Date format converted from String
        public var versionInt: Int - Version of Rule in Int format
      }

## Description

Description contains information about rule error for specific country 

    public class Description: Codable {
      public var lang: String - Language code, example "EN"
      public var desc: String - Description of rule error, example: "Vaccine must contains 2/2 doses"
    }

## External Parameter

External Parameter - used for send to CertLogic Engine information about user certificate, current date and time and list of ValueSets
 
      public class ExternalParameter: Codable {
        public var validationClock: Date - Current Date and Time in iso format
        public var valueSets: Dictionary<String, [String]> - List of ValueSets
        public var issuerCountryCode: String - Issuer Country code from HCert
        public var exp: Date - exp Date from HCert
        public var iat: Date - iat Date from HCert
        public var kid: String? - kid string from HCert (not used now)
      }
  
## Filter Parameter

Filter Parameter - used for send to CertLogic Engine information we used to filter rules

    public class FilterParameter {
      public var validationClock: Date - current time
      public var countryCode: String - Country code from list of Country's, example "IT", "AT", "DE", "BE"
      public var region: String? - Region of Country
      public var certificationType: CertificateType = .general - Certification Type from HCert
    }

## Value Set

    public class ValueSetItem: Codable {
      public var display: String
      public var lang: String
      public var active: Bool
      public var system: String
      public var version: String
    }

## Validation Result

ValidationResult - result of CertLogicEngine works. ValidationResult contains information about rule result, can be three different types:
* fail - Rule failed, this rule not valid and user can't be traveled in this country
* passed - Rule passed, user can travel in this country
* open - Rule can't be validated, invalid version, scheme, engine of rule. 

      public enum Result: Int {
        case fail = 0 - Fail Status
        case passed - Passed Status
        case open - Open Status
      }

      public class ValidationResult {
        
        public var rule: Rule? - Rule we validate
        public var result: Result = .open - Result of validation
        public var validationErrors: [Error]? - List of localized errors we get from Rule validation or from CertLogic
      }

## CertLogicEngine Usage

Before start using CertLogicEngine you need:
* Set the Rules, to make this use func updateRules, in parameters you need send array of Rule models. This is array of All rules for all counties.
                
                .updateRules(rules: [Rule])
    
  This function always delete all previous rules and set the rusles from new array with Rule objects.
                
* Create new Filter Parameter
  example:
  
              let certType = getCertificationType(type: hCert.type)
              let countryCode = hCert.ruleCountryCode
              FilterParameter(validationClock: Date(),
                                  countryCode: countryCode,
                            certificationType: certType)
* Create new External Parameter

  Before create External Parameter you need create ValueSets Dictionary

          
          var valueSets = [CertLogic.ValueSet]()
          
          public func getValueSetsForExternalParameters() -> Dictionary<String, [String]> {
            var returnValue = Dictionary<String, [String]>()
            valueSets.forEach { valueSet in
              if let keys: [String] = Array(valueSet.valueSetValues.keys) as? [String] {
                returnValue[valueSet.valueSetId] = keys
              }
            }
            return returnValue
          }

After that you can create Externa Parameter

            ExternalParameter(validationClock: Date(),
                                   valueSets: valueSets,
                                   exp: hCert.exp,
                                   iat: hCert.iat,
                                   issuerCountryCode: hCert.issCode,
                                   kid: hCert.kidStr)

* Only after creating all of this objects you can use CertLogicEngine to validate certificate with rules you loaded before.

        let result = CertLogicEngine().validate(filter: filterParameter, external: externalParameters,
                                                                payload: hCert.body.description)

Result of .validate function it's array of validation result models:  [ValidationResult]. This array contains .fail, .open, .passed results. If you need you can filter them and get only list of .fail or .open resuls.

## Testing a rule

Any rule should come with automated tests that exercise it.
Such tests corroborate the rule writer's intention, but can also be used to check the validity of the execution of the same rule by different rules engines.
That's particularly helpful with implementors of verifier apps having free choice in what rules engine to use.

**TODO**  bring up-to-date with other repo

To test this functionality you can run the script `run-tests.sh`, which tests all rule sets present against their (respective) tests.

    $ ./run-tests.sh




<h1 align="center">
   EU Digital COVID Certificate - Certlogic iOS
</h1>

<p align="center">
  <a href="/../../commits/" title="Last Commit">
    <img src="https://img.shields.io/github/last-commit/eu-digital-green-certificates/dgc-certlogic-ios?style=flat">
  </a>
  <a href="/../../issues" title="Open Issues">
    <img src="https://img.shields.io/github/issues/eu-digital-green-certificates/dgc-certlogic-ios?style=flat">
  </a>
  <a href="./LICENSE" title="License">
    <img src="https://img.shields.io/badge/License-Apache%202.0-green.svg?style=flat">
  </a>
</p>

<p align="center">
  <a href="#about">About</a> •
  <a href="#development">Development</a> •
  <a href="#documentation">Documentation</a> •
  <a href="#support-and-feedback">Support</a> •
  <a href="#how-to-contribute">Contribute</a> •
  <a href="#contributors">Contributors</a> •
  <a href="#licensing">Licensing</a>
  <a href="#assumptions">Assumptions</a>
  <a href="#testing & status">Testing & Status</a>
</p>

## About

This repository contains the source code of the EU Digital COVID Certificate Certlogic for iOS. 

The [Digital COVID Certificate (DCC)](https://ec.europa.eu/info/live-work-travel-eu/coronavirus-response/safe-covid-19-vaccines-europeans/eu-digital-covid-certificate_en) allows to determine whether a person is deemed fit-for-travel into a country-of-arrival (CoA) based on their vaccination, test, and recovery status.
To make such determinations, business (or validation, or verification) rules have to be implemented in verifier and wallet apps.

This module allows integrating the certlogic in iOS apps.

This repository contains a framework to implement in verifier apps (and backends) using a _CertLogicEngine_.
It [explains how to do that](./documentation/how-to.md) in a way that makes these rules interchangeable across implementors.
The advantage of this approach is that it ultimately allows citizens to check their fit-for-travel status into an intended CoA _ahead_ of travel, against the actual rules.

This can be achieved by adhering to a common, and testable and verifiable way of defining, and executing rules.
The interchangeable rules are uploaded to, and can be downloaded from the EU Digital COVID Certificate Gateway (DGCG) - more info can be found [here](./documentation/gateway.md).

An example of a rule can be found [here](./documentation/example.adoc).

This work is a result of work done by the EU Taskforce Business Rules, and described in [this document](https://ec.europa.eu/health/sites/default/files/ehealth/docs/eu-dcc_validation-rules_en.pdf).
The (JSON Schema) technical specification for the EU DCC can be found [here](https://ec.europa.eu/health/sites/default/files/ehealth/docs/covid-certificate_json_specification_en.pdf).

## Development

### Prerequisites

This library automaticaly added in dependencies and downloading by XCode Swift Package Manager

* [JsonLogic](https://github.com/eu-digital-green-certificates/json-logic-swift)
* [SwiftyJSON](https://github.com/SwiftyJSON/SwiftyJSON)

#### Using Swift Package Manager

if you use Swift Package Manager add the following in dependencies:

        dependencies: [
        .package(
            url: "https://github.com/eu-digital-green-certificates/dgc-certlogic-ios", from: "1.0.0"
        )
    ]
  
if you want to use CertLogic as XCode project please use script for generate certlogic.xcodeproj and add this project directly

    generate-xcodeproj.sh
  

## Assumptions

Various code in this repo assumes that you've cloned the following two repos right next to where this repo's cloned:

* [ehn-dcc-schema](https://github.com/ehn-dcc-development/ehn-dcc-schema)
* [ehn-dcc-valuesets](https://github.com/ehn-dcc-development/ehn-dcc-valuesets)
* ([dgc-testdata](https://github.com/ehn-dcc-development/dgc-testdata))

## Testing & Status

- If you found any problems, please create an [Issue](/../../issues).
- Current status: Work-In-Progress.

## Documentation

* [Documentation](./documentation/README.md).
* [JsonLogic](https://github.com/eu-digital-green-certificates/json-logic-swift): documentation and code relating to JsonLogic.
* [SwiftyJSON](https://github.com/SwiftyJSON/SwiftyJSON): documentation and code relating to SwiftyJSON library.

## Support and feedback

The following channels are available for discussions, feedback, and support requests:

| Type                     | Channel                                                |
| ------------------------ | ------------------------------------------------------ |
| **Issues**    | <a href="/../../issues" title="Open Issues"><img src="https://img.shields.io/github/issues/eu-digital-green-certificates/dgc-certlogic-ios?style=flat"></a>  |
| **Other requests**    | <a href="mailto:opensource@telekom.de" title="Email DGC Team"><img src="https://img.shields.io/badge/email-DGC%20team-green?logo=mail.ru&style=flat-square&logoColor=white"></a>   |

## How to contribute  

Contribution and feedback is encouraged and always welcome. For more information about how to contribute, the project structure, 
as well as additional contribution information, see our [Contribution Guidelines](./CONTRIBUTING.md). By participating in this 
project, you agree to abide by its [Code of Conduct](./CODE_OF_CONDUCT.md) at all times.

## Contributors  

Our commitment to open source means that we are enabling - in fact encouraging - all interested parties to contribute and become part of its developer community.

## Licensing

Copyright (C) 2021 T-Systems International GmbH and all other contributors

Licensed under the **Apache License, Version 2.0** (the "License"); you may not use this file except in compliance with the License.

You may obtain a copy of the License at https://www.apache.org/licenses/LICENSE-2.0.

Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" 
BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the [LICENSE](./LICENSE) for the specific 
language governing permissions and limitations under the License.

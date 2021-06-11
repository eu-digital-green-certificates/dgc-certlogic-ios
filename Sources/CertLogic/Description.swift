//
//  Description.swift
//  
//
//  Created by Alexandr Chernyy on 08.06.2021.
//

import Foundation

// MARK: Description type

class Description: Codable {
  
  var lang: String
  var desc: String
  
  enum CodingKeys: String, CodingKey {
    case lang = "lang", desc = "desc"
  }
  
  init(lang: String, desc: String) {
    self.lang = lang
    self.desc = desc
  }
  
  required init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    lang = try container.decode(String.self, forKey: .lang)
    desc = try container.decode(String.self, forKey: .desc)
  }
  
}

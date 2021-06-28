//
//  Description.swift
//  
//
//  Created by Alexandr Chernyy on 08.06.2021.
//

import Foundation

// MARK: Description type

public class Description: Codable {
  
  public var lang: String
  public var desc: String
  
  enum CodingKeys: String, CodingKey {
    case lang = "lang", desc = "desc"
  }
  
  public init(lang: String, desc: String) {
    self.lang = lang
    self.desc = desc
  }
  
  required public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    lang = try container.decode(String.self, forKey: .lang)
    desc = try container.decode(String.self, forKey: .desc)
  }
  
}

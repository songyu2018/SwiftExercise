// To parse the JSON, add this file to your project and do:
//
//   let flickrPhotoDetail = try? newJSONDecoder().decode(FlickrPhotoDetail.self, from: jsonData)

import Foundation

struct FlickrPhotoDetail: Codable {
  let photo: Photo?
  let stat: String?
  
  enum CodingKeys: String, CodingKey {
    case photo = "photo"
    case stat = "stat"
  }
}

struct Photo: Codable {
  let id: String?
  let secret: String?
  let server: String?
  let farm: Int?
  let dateuploaded: String?
  let isfavorite: Int?
  let license: String?
  let safetyLevel: String?
  let rotation: Int?
  let originalsecret: String?
  let originalformat: String?
  let owner: Owner?
  let title: Comments?
  let description: Comments?
  let visibility: Visibility?
  let dates: Dates?
  let views: String?
  let editability: Editability?
  let publiceditability: Editability?
  let usage: Usage?
  let comments: Comments?
  let notes: Notes?
  let people: People?
  let tags: Tags?
  let urls: Urls?
  let media: String?
  
  enum CodingKeys: String, CodingKey {
    case id = "id"
    case secret = "secret"
    case server = "server"
    case farm = "farm"
    case dateuploaded = "dateuploaded"
    case isfavorite = "isfavorite"
    case license = "license"
    case safetyLevel = "safety_level"
    case rotation = "rotation"
    case originalsecret = "originalsecret"
    case originalformat = "originalformat"
    case owner = "owner"
    case title = "title"
    case description = "description"
    case visibility = "visibility"
    case dates = "dates"
    case views = "views"
    case editability = "editability"
    case publiceditability = "publiceditability"
    case usage = "usage"
    case comments = "comments"
    case notes = "notes"
    case people = "people"
    case tags = "tags"
    case urls = "urls"
    case media = "media"
  }
}

struct Comments: Codable {
  let content: String?
  
  enum CodingKeys: String, CodingKey {
    case content = "_content"
  }
}

struct Dates: Codable {
  let posted: String?
  let taken: String?
  let takengranularity: String?
  let takenunknown: String?
  let lastupdate: String?
  
  enum CodingKeys: String, CodingKey {
    case posted = "posted"
    case taken = "taken"
    case takengranularity = "takengranularity"
    case takenunknown = "takenunknown"
    case lastupdate = "lastupdate"
  }
}

struct Editability: Codable {
  let cancomment: Int?
  let canaddmeta: Int?
  
  enum CodingKeys: String, CodingKey {
    case cancomment = "cancomment"
    case canaddmeta = "canaddmeta"
  }
}

struct Notes: Codable {
  let note: [JSONAny]?
  
  enum CodingKeys: String, CodingKey {
    case note = "note"
  }
}

struct Owner: Codable {
  let nsid: Nsid?
  let username: Rname?
  let realname: String?
  let location: String?
  let iconserver: String?
  let iconfarm: Int?
  let pathAlias: String?
  
  enum CodingKeys: String, CodingKey {
    case nsid = "nsid"
    case username = "username"
    case realname = "realname"
    case location = "location"
    case iconserver = "iconserver"
    case iconfarm = "iconfarm"
    case pathAlias = "path_alias"
  }
}

enum Nsid: String, Codable {
  case the57809060N07 = "57809060@N07"
}

enum Rname: String, Codable {
  case kidNoir = "kid.noir"
}

struct People: Codable {
  let haspeople: Int?
  
  enum CodingKeys: String, CodingKey {
    case haspeople = "haspeople"
  }
}

struct Tags: Codable {
  let tag: [Tag]?
  
  enum CodingKeys: String, CodingKey {
    case tag = "tag"
  }
}

struct Tag: Codable {
  let id: String?
  let author: Nsid?
  let authorname: Rname?
  let raw: String?
  let content: String?
  let machineTag: Bool?
  
  enum CodingKeys: String, CodingKey {
    case id = "id"
    case author = "author"
    case authorname = "authorname"
    case raw = "raw"
    case content = "_content"
    case machineTag = "machine_tag"
  }
}

struct Urls: Codable {
  let url: [URLElement]?
  
  enum CodingKeys: String, CodingKey {
    case url = "url"
  }
}

struct URLElement: Codable {
  let type: String?
  let content: String?
  
  enum CodingKeys: String, CodingKey {
    case type = "type"
    case content = "_content"
  }
}

struct Usage: Codable {
  let candownload: Int?
  let canblog: Int?
  let canprint: Int?
  let canshare: Int?
  
  enum CodingKeys: String, CodingKey {
    case candownload = "candownload"
    case canblog = "canblog"
    case canprint = "canprint"
    case canshare = "canshare"
  }
}

struct Visibility: Codable {
  let ispublic: Int?
  let isfriend: Int?
  let isfamily: Int?
  
  enum CodingKeys: String, CodingKey {
    case ispublic = "ispublic"
    case isfriend = "isfriend"
    case isfamily = "isfamily"
  }
}

// MARK: Encode/decode helpers

class JSONNull: Codable, Hashable {
  
  public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
    return true
  }
  
  public var hashValue: Int {
    return 0
  }
  
  public init() {}
  
  public required init(from decoder: Decoder) throws {
    let container = try decoder.singleValueContainer()
    if !container.decodeNil() {
      throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
    }
  }
  
  public func encode(to encoder: Encoder) throws {
    var container = encoder.singleValueContainer()
    try container.encodeNil()
  }
}

class JSONCodingKey: CodingKey {
  let key: String
  
  required init?(intValue: Int) {
    return nil
  }
  
  required init?(stringValue: String) {
    key = stringValue
  }
  
  var intValue: Int? {
    return nil
  }
  
  var stringValue: String {
    return key
  }
}

class JSONAny: Codable {
  let value: Any
  
  static func decodingError(forCodingPath codingPath: [CodingKey]) -> DecodingError {
    let context = DecodingError.Context(codingPath: codingPath, debugDescription: "Cannot decode JSONAny")
    return DecodingError.typeMismatch(JSONAny.self, context)
  }
  
  static func encodingError(forValue value: Any, codingPath: [CodingKey]) -> EncodingError {
    let context = EncodingError.Context(codingPath: codingPath, debugDescription: "Cannot encode JSONAny")
    return EncodingError.invalidValue(value, context)
  }
  
  static func decode(from container: SingleValueDecodingContainer) throws -> Any {
    if let value = try? container.decode(Bool.self) {
      return value
    }
    if let value = try? container.decode(Int64.self) {
      return value
    }
    if let value = try? container.decode(Double.self) {
      return value
    }
    if let value = try? container.decode(String.self) {
      return value
    }
    if container.decodeNil() {
      return JSONNull()
    }
    throw decodingError(forCodingPath: container.codingPath)
  }
  
  static func decode(from container: inout UnkeyedDecodingContainer) throws -> Any {
    if let value = try? container.decode(Bool.self) {
      return value
    }
    if let value = try? container.decode(Int64.self) {
      return value
    }
    if let value = try? container.decode(Double.self) {
      return value
    }
    if let value = try? container.decode(String.self) {
      return value
    }
    if let value = try? container.decodeNil() {
      if value {
        return JSONNull()
      }
    }
    if var container = try? container.nestedUnkeyedContainer() {
      return try decodeArray(from: &container)
    }
    if var container = try? container.nestedContainer(keyedBy: JSONCodingKey.self) {
      return try decodeDictionary(from: &container)
    }
    throw decodingError(forCodingPath: container.codingPath)
  }
  
  static func decode(from container: inout KeyedDecodingContainer<JSONCodingKey>, forKey key: JSONCodingKey) throws -> Any {
    if let value = try? container.decode(Bool.self, forKey: key) {
      return value
    }
    if let value = try? container.decode(Int64.self, forKey: key) {
      return value
    }
    if let value = try? container.decode(Double.self, forKey: key) {
      return value
    }
    if let value = try? container.decode(String.self, forKey: key) {
      return value
    }
    if let value = try? container.decodeNil(forKey: key) {
      if value {
        return JSONNull()
      }
    }
    if var container = try? container.nestedUnkeyedContainer(forKey: key) {
      return try decodeArray(from: &container)
    }
    if var container = try? container.nestedContainer(keyedBy: JSONCodingKey.self, forKey: key) {
      return try decodeDictionary(from: &container)
    }
    throw decodingError(forCodingPath: container.codingPath)
  }
  
  static func decodeArray(from container: inout UnkeyedDecodingContainer) throws -> [Any] {
    var arr: [Any] = []
    while !container.isAtEnd {
      let value = try decode(from: &container)
      arr.append(value)
    }
    return arr
  }
  
  static func decodeDictionary(from container: inout KeyedDecodingContainer<JSONCodingKey>) throws -> [String: Any] {
    var dict = [String: Any]()
    for key in container.allKeys {
      let value = try decode(from: &container, forKey: key)
      dict[key.stringValue] = value
    }
    return dict
  }
  
  static func encode(to container: inout UnkeyedEncodingContainer, array: [Any]) throws {
    for value in array {
      if let value = value as? Bool {
        try container.encode(value)
      } else if let value = value as? Int64 {
        try container.encode(value)
      } else if let value = value as? Double {
        try container.encode(value)
      } else if let value = value as? String {
        try container.encode(value)
      } else if value is JSONNull {
        try container.encodeNil()
      } else if let value = value as? [Any] {
        var container = container.nestedUnkeyedContainer()
        try encode(to: &container, array: value)
      } else if let value = value as? [String: Any] {
        var container = container.nestedContainer(keyedBy: JSONCodingKey.self)
        try encode(to: &container, dictionary: value)
      } else {
        throw encodingError(forValue: value, codingPath: container.codingPath)
      }
    }
  }
  
  static func encode(to container: inout KeyedEncodingContainer<JSONCodingKey>, dictionary: [String: Any]) throws {
    for (key, value) in dictionary {
      let key = JSONCodingKey(stringValue: key)!
      if let value = value as? Bool {
        try container.encode(value, forKey: key)
      } else if let value = value as? Int64 {
        try container.encode(value, forKey: key)
      } else if let value = value as? Double {
        try container.encode(value, forKey: key)
      } else if let value = value as? String {
        try container.encode(value, forKey: key)
      } else if value is JSONNull {
        try container.encodeNil(forKey: key)
      } else if let value = value as? [Any] {
        var container = container.nestedUnkeyedContainer(forKey: key)
        try encode(to: &container, array: value)
      } else if let value = value as? [String: Any] {
        var container = container.nestedContainer(keyedBy: JSONCodingKey.self, forKey: key)
        try encode(to: &container, dictionary: value)
      } else {
        throw encodingError(forValue: value, codingPath: container.codingPath)
      }
    }
  }
  
  static func encode(to container: inout SingleValueEncodingContainer, value: Any) throws {
    if let value = value as? Bool {
      try container.encode(value)
    } else if let value = value as? Int64 {
      try container.encode(value)
    } else if let value = value as? Double {
      try container.encode(value)
    } else if let value = value as? String {
      try container.encode(value)
    } else if value is JSONNull {
      try container.encodeNil()
    } else {
      throw encodingError(forValue: value, codingPath: container.codingPath)
    }
  }
  
  public required init(from decoder: Decoder) throws {
    if var arrayContainer = try? decoder.unkeyedContainer() {
      self.value = try JSONAny.decodeArray(from: &arrayContainer)
    } else if var container = try? decoder.container(keyedBy: JSONCodingKey.self) {
      self.value = try JSONAny.decodeDictionary(from: &container)
    } else {
      let container = try decoder.singleValueContainer()
      self.value = try JSONAny.decode(from: container)
    }
  }
  
  public func encode(to encoder: Encoder) throws {
    if let arr = self.value as? [Any] {
      var container = encoder.unkeyedContainer()
      try JSONAny.encode(to: &container, array: arr)
    } else if let dict = self.value as? [String: Any] {
      var container = encoder.container(keyedBy: JSONCodingKey.self)
      try JSONAny.encode(to: &container, dictionary: dict)
    } else {
      var container = encoder.singleValueContainer()
      try JSONAny.encode(to: &container, value: self.value)
    }
  }
}

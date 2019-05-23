import Foundation

class VendorManager {
  static let shared = VendorManager()


  func parsePhotoList(response: [String: AnyObject]) -> [GenericPhoto]? {
    switch vendor {
    case .Flickr:
      let parser = FlickerParser()
      return parser.parseList(response: response)
    default:
      return [GenericPhoto]()
    }
  }
  
  func parseDetail(response : [String: AnyObject]) -> GenericPhotoDetailInfo? {
    switch vendor {
    case .Flickr:
      let parser = FlickerParser()
      return parser.parseDetail(response: response)
    default:
      return nil
    }
  }
}


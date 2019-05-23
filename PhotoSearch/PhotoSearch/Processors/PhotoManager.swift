import UIKit
import Utilities
// https://www.flickr.com/services/api/explore/?method=flickr.photos.search
let apiKey = "1af249b0331dff153977c0cd33dc1844"
let vendor : PhotoManager.Vendor = .Flickr
let imageConcurrentQueue = DispatchQueue(label: "imageLoadingQueue", attributes: .concurrent)

class PhotoManager : NetworkFacilities, Serializable {
  static let shared = PhotoManager(dataTaskState: .active)
  
  var dataTaskState: DataTaskState
  
  required init(dataTaskState: DataTaskState) {
    self.dataTaskState = .active
  }
  
  enum Vendor {
    case Flickr
    case Instagram
    case Picasa
    case Google
  }
  
  enum Error: Swift.Error {
    case unknownAPIResponse
    case generic
  }
  
  func searchPhoto(for searchTerm: String, completion: @escaping (Result<PhotoSearchResults>) -> Void) {
    guard let searchURL = photoSearchURL(for: searchTerm) else {
      completion(Result.error(Error.unknownAPIResponse))
      return
    }
    
    
    self.dataTask(method: .GET, sURL: searchURL.absoluteString, headers: nil, body: nil) { (success, dictResponse) in
      //print(dictResponse)
      if let resultsDictionary : [String: AnyObject] = dictResponse["__RESPONSE__"] as? [String : AnyObject]{
        
        let searchResults = PhotoSearchResults(searchTerm: searchTerm, searchResults: VendorManager.shared.parsePhotoList(response: resultsDictionary))
        DispatchQueue.main.async {
          completion(Result.results(searchResults))
        }
        
      } else {
        completion(Result.error(Error.unknownAPIResponse))
      }
    }
  }
  
  private func photoSearchURL(for searchTerm:String) -> URL? {
    guard let escapedTerm = searchTerm.addingPercentEncoding(withAllowedCharacters: CharacterSet.alphanumerics) else {
      return nil
    }
    
    var URLString : String;
    switch vendor {
    case .Flickr:
      URLString = "https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=\(apiKey)&text=\(escapedTerm)&per_page=100&format=json&nojsoncallback=1"
    default:
      URLString = "";
    }
    
    return URL(string:URLString)
  }
  
  
}

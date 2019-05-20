import UIKit
import Utilities
// https://www.flickr.com/services/api/explore/?method=flickr.photos.search
let apiKey = "441eeb156693db224d05620562b823c1"
let vandor : PhotoManager.Vandor = .Flickr
let imageConcurrentQueue = DispatchQueue(label: "imageLoadingQueue", attributes: .concurrent)

class PhotoManager : NetworkFacilities, Serizable {
  static let shared = PhotoManager(dataTaskState: .active)
  
  var dataTaskState: DataTaskState
  
  required init(dataTaskState: DataTaskState) {
    self.dataTaskState = .active
  }
  
  enum Vandor {
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
        
        let photos : [GenericPhoto]?
        switch vandor {
        case .Flickr:
          let parser = FlickerParser()
          photos = parser.parseList(response: resultsDictionary)
        default:
          photos = [GenericPhoto]()
        }
        
        let searchResults = PhotoSearchResults(searchTerm: searchTerm, searchResults: photos)
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
    switch vandor {
    case .Flickr:
      URLString = "https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=\(apiKey)&text=\(escapedTerm)&per_page=100&format=json&nojsoncallback=1"
    default:
      URLString = "";
    }
    
    return URL(string:URLString)
  }
  
  public func photoDetailsURL(phontoID : String) -> String {
    var URLString : String;
    switch vandor {
    case .Flickr:
      URLString = "https://api.flickr.com/services/rest/?method=flickr.photos.getinfo&api_key=\(apiKey)&photo_id=\(phontoID)&format=json&nojsoncallback=1"
    default:
      URLString = "";
    }
    
    return URLString
  }
}

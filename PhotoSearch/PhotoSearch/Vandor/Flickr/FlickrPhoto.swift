import UIKit

class FlickrPhoto: Equatable, GenericPhoto {
  var thumbnail: UIImage?
  var largeImage: UIImage?
  var photoID: String
  let farm: Int
  let server: String
  let secret: String
  
  init (photoID: String, farm: Int, server: String, secret: String) {
    self.photoID = photoID
    self.farm = farm
    self.server = server
    self.secret = secret
  }
  
  func imageURL(_ size: String = "m") -> URL? {
    if let url =  URL(string: "https://farm\(farm).staticflickr.com/\(server)/\(photoID)_\(secret)_\(size).jpg") {
      return url
    }
    return nil
  }
  
  func photoDetailsURL() -> String {
    let URLString = "https://api.flickr.com/services/rest/?method=flickr.photos.getinfo&api_key=\(apiKey)&photo_id=\(self.photoID)&format=json&nojsoncallback=1"
    
    return URLString
  }
  
  static func ==(lhs: FlickrPhoto, rhs: FlickrPhoto) -> Bool {
    return lhs.photoID == rhs.photoID
  }
}

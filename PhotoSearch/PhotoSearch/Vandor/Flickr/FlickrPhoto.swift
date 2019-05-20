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
  
  enum Error: Swift.Error {
    case invalidURL
    case noData
  }
  
  func loadLargeImage(_ completion: @escaping (Result<GenericPhoto>) -> Void) {
    guard let loadURL = imageURL("b") else {
      DispatchQueue.main.async {
        completion(Result.error(Error.invalidURL))
      }
      return
    }
    
    let loadRequest = URLRequest(url:loadURL)
    
    URLSession.shared.dataTask(with: loadRequest) { (data, response, error) in
      if let error = error {
        DispatchQueue.main.async {
          completion(Result.error(error))
        }
        return
      }
      
      guard let data = data else {
        DispatchQueue.main.async {
          completion(Result.error(Error.noData))
        }
        return
      }
      
      let returnedImage = UIImage(data: data)
      self.largeImage = returnedImage
      DispatchQueue.main.async {
        completion(Result.results(self))
      }
    }.resume()
  }
  
  func sizeToFillWidth(of size:CGSize) -> CGSize {
    guard let thumbnail = thumbnail else {
      return size
    }
    
    let imageSize = thumbnail.size
    var returnSize = size
    
    let aspectRatio = imageSize.width / imageSize.height
    
    returnSize.height = returnSize.width / aspectRatio
    
    if returnSize.height > size.height {
      returnSize.height = size.height
      returnSize.width = size.height * aspectRatio
    }
    
    return returnSize
  }
  
  static func ==(lhs: FlickrPhoto, rhs: FlickrPhoto) -> Bool {
    return lhs.photoID == rhs.photoID
  }
}

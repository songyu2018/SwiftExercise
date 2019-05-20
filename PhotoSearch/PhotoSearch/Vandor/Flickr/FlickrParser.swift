import UIKit


class FlickerParser: Parser {
  func parseList(response : [String: AnyObject]) -> [GenericPhoto]? {
    do {
      guard
        let stat = response["stat"] as? String, stat == "ok"
        else {
          return nil
      }
      
      guard
        let photosContainer = response["photos"] as? [String: AnyObject],
        let photosReceived = photosContainer["photo"] as? [[String: AnyObject]]
        else {
          return nil
      }
      
      let Photos: [GenericPhoto] = photosReceived.compactMap { photoObject in
        guard
          let photoID = photoObject["id"] as? String,
          let farm = photoObject["farm"] as? Int ,
          let server = photoObject["server"] as? String ,
          let secret = photoObject["secret"] as? String
          else {
            return nil
        }
        
        let flickrPhoto = FlickrPhoto(photoID: photoID, farm: farm, server: server, secret: secret)
        
        return flickrPhoto
        
      }
      
      return Photos
      
    }
  }
  
  func parseDetail(response : [String: AnyObject]) -> GenericPhotoDetailInfo? {
    do {
      guard
        let stat = response["stat"] as? String, stat == "ok"
        else {
          return nil
      }
      
      guard
        let photoContainer = response["photo"] as? [String: AnyObject],
        var ownInfo = photoContainer["owner"] as? [String: AnyObject],
        var dateInfo = photoContainer["dates"] as? [String: AnyObject]
        else {
          return nil
      }
      
      
      
      let photographer = ownInfo["username"] as? String
      let date = dateInfo["taken"] as? String
      var location = photoContainer["location"] as? String
      if location == nil || location == "" {
        location = "Unknown"
      }
      let likes = photoContainer["views"] as? String
      let filter = "Unknown"
      
      let photoDetails = GenericPhotoDetailInfo(name: photographer! ,photographer: photographer, date: date, locaiton: location, likes: likes, filter: filter)
      
      
      
      return photoDetails
      
    }
    
    
    
    
    do {
      let data = try JSONSerialization.data(withJSONObject: response, options: .prettyPrinted)
      let model = try JSONDecoder().decode(FlickrPhotoDetail.self, from: data)
      print(model)
    } catch { print(error) }
    
  }
}


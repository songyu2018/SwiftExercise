import Foundation


struct GenericPhotoDetailInfo : MyCodable {
  var name: String
  let photographer : String?
  let date : String?
  let locaiton : String?
  let likes : String?
  let filter : String?
}

import Foundation

protocol Parser {
  func parseList(response : [String: AnyObject]) -> [GenericPhoto]?
  func parseDetail(response : [String: AnyObject]) -> GenericPhotoDetailInfo?
}

import UIKit

protocol GenericPhoto {
  var photoID: String {get set}
  var thumbnail: UIImage? {get set}
  func imageURL(_ size: String) -> URL?
  func loadLargeImage(_ completion: @escaping (Result<GenericPhoto>) -> Void)
}


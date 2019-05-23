import UIKit


class SinglePhotoViewController: UIViewController {
  
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var uiPhotographer: UILabel!
    @IBOutlet weak var uiDate: UILabel!
    @IBOutlet weak var uiLocation: UILabel!
    @IBOutlet weak var uiLikes: UILabel!
    @IBOutlet weak var uiFilter: UILabel!
    
    
  public var photo : GenericPhoto? {
    didSet {
      DispatchQueue.global().async {
        let data = try? Data(contentsOf: (self.photo?.imageURL("b"))!)
        DispatchQueue.main.async {
          self.imageView.image = UIImage(data: data!)
        }
      }
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    guard let _ = self.photo else {
       return
    }
    
    
    PhotoManager.shared.dataTask(method: .GET, sURL: (photo?.photoDetailsURL())!, headers: nil, body: nil) { (success, dictResponse) in
      //print(dictResponse)
      
      if let resultsDictionary : [String: AnyObject] = dictResponse["__RESPONSE__"] as? [String : AnyObject]{
      
        //print(resultsDictionary)
        
        guard let photoDetails : GenericPhotoDetailInfo = VendorManager.shared.parseDetail(response: resultsDictionary) else {
          return
        }
        
        self.uiPhotographer.text = photoDetails.photographer
        self.uiDate.text = photoDetails.date
        self.uiLocation.text = photoDetails.locaiton
        self.uiLikes.text = photoDetails.likes
        self.uiFilter.text = photoDetails.filter
        
        // Demenstration purpose only.
        PhotoManager.shared.save(obj: photoDetails)
        
      }
    }
    
  }
  
}

import UIKit

final class PhotosViewController: UICollectionViewController {
  // MARK: - Properties
  private let reuseIdentifier = "PhotoCell"
  private let sectionInsets = UIEdgeInsets(top: 50.0, left: 20.0, bottom: 50.0, right: 20.0)
  private var searches: [PhotoSearchResults] = []
  private let itemsPerRow: CGFloat = 3
  
  
  // Force the view to re-layout after screen rotation.
  override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
    super.viewWillTransition(to: size, with: coordinator)
    
    self.collectionView?.collectionViewLayout.invalidateLayout()
  }
  
  
}

// MARK: - Private
private extension PhotosViewController {
  func photo(for indexPath: IndexPath) -> GenericPhoto? {
    return searches[indexPath.section].searchResults?[indexPath.row]
  }
}

// MARK: - Text Field Delegate
extension PhotosViewController : UITextFieldDelegate {
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    
    let activityIndicator = UIActivityIndicatorView(style: .gray)
    textField.addSubview(activityIndicator)
    activityIndicator.frame = textField.bounds
    activityIndicator.startAnimating()
    
    PhotoManager.shared.searchPhoto(for: textField.text!) { searchResults in
      activityIndicator.removeFromSuperview()
      
      switch searchResults {
      case .error(let error) :
        print("Error Searching: \(error)")
      case .results(let results):
        print("Found \(results.searchResults?.count ?? 0) matching \(results.searchTerm)")
        self.searches.insert(results, at: 0)
        
        
        self.collectionView?.reloadData()
      }
    }
    
    textField.text = nil
    textField.resignFirstResponder()
    return true
  }
}

// MARK: - UICollectionViewDataSource
extension PhotosViewController {
  
  override func numberOfSections(in collectionView: UICollectionView) -> Int {
    return searches.count
  }
  
  
  override func collectionView(_ collectionView: UICollectionView,
                               numberOfItemsInSection section: Int) -> Int {
    return searches[section].searchResults?.count ?? 0
  }
  
  
  override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier,
                                                  for: indexPath) as! PhotoCell
   
    var cellPhoto = photo(for: indexPath)
    cell.backgroundColor = .white
    
    
    // Get the thumbnail image.
    if let thumbnail = cellPhoto?.thumbnail {
      cell.imageView.image = thumbnail
    } else {
      if let url = cellPhoto?.imageURL("m") {
        imageConcurrentQueue.async {
          let imageData = try? Data(contentsOf: url as URL)
          
          if let image = UIImage(data: imageData!) {
            cellPhoto?.thumbnail = image
            DispatchQueue.main.async {
              cell.imageView.image = image
            }
          }
        }
      }
    }
    
    return cell
  }
}


// MARK: - Collection View Flow Layout Delegate
extension PhotosViewController : UICollectionViewDelegateFlowLayout {

  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      sizeForItemAt indexPath: IndexPath) -> CGSize {
    
    let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
    let availableWidth = view.frame.width - paddingSpace
    let widthPerItem = availableWidth / itemsPerRow
    
    return CGSize(width: widthPerItem, height: widthPerItem)
  }
  
  
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      insetForSectionAt section: Int) -> UIEdgeInsets {
    return sectionInsets
  }
  
  
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return sectionInsets.left
  }
  
  
  // Delegate method.
  override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    let controller = storyboard.instantiateViewController(withIdentifier: "SinglePhotoViewController") as! SinglePhotoViewController
    controller.photo = photo(for: indexPath)
    
    self.navigationController?.pushViewController(controller, animated: true)
    
  }
}



import XCTest

@testable import PhotoSearch
class PhotoSearchTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testListLoading() {
      PhotoManager.shared.searchPhoto(for: "trees") { searchResults in
        switch searchResults {
        case .error :
          XCTFail()
        case .results(let results):
          XCTAssertLessThan(results.searchResults!.count, 0)
        }
        
      }
    }
  
  
  func testSave() {
    let obj = GenericPhotoDetailInfo(name: "photo", photographer: "Yu", date: "2019-05-06", locaiton: "Regina", likes: "5", filter: "1")
    XCTAssertTrue(PhotoManager.shared.save(obj: obj))
    
  }
  
  func testRestore() {
    let obj : GenericPhotoDetailInfo? = PhotoManager.shared.restore(saveName: "photo")
    
    if let obj = obj {
      XCTAssertEqual(obj.name, "photo")
      UserDefaults.standard.removeObject(forKey: "photo")
    }
  }
  
  func testPhotoDetailLoading() {
    
  }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}

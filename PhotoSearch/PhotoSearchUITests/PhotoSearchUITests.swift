import XCTest

class PhotoSearchUITests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
      
      
      let app = XCUIApplication()
      app.navigationBars["PhotoSearch.PhotosView"].textFields["Search"].tap()
      app.otherElements.containing(.navigationBar, identifier:"PhotoSearch.PhotosView").children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .collectionView).element.swipeUp()
      app.collectionViews.children(matching: .cell).element(boundBy: 7).children(matching: .other).element.swipeDown()
      
        // Use recording to get started writing UI tests.
              // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

}

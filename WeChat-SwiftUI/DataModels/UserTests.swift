import XCTest
@testable import WeChat_SwiftUI

final class UserTests: XCTestCase {
  func testEquatable() {
    XCTAssertEqual(User.template, User.template)
    XCTAssertNotEqual(User.template, User.template2)
  }

  func testDescription() {
    XCTAssertNotEqual("", User.template.debugDescription)
  }

  func testJsonParsing() {
    let json = """
      {
      "id": "4d0914d5-b04c-43f1-b37f-b2bb8d177951",
      "avatar": "https://cdn.nba.com/headshots/nba/latest/260x190/2544.png",
      "name": "LeBron James",
      "wechat_id": "lebron_james",
      "gender": "male",
      "region": "USA",
      "whats_up": "Hello, I'm LeBron James!"
      }
      """

    let user: User? = tryDecode(json)

    XCTAssertEqual("4d0914d5-b04c-43f1-b37f-b2bb8d177951", user?.id)
    XCTAssertEqual("https://cdn.nba.com/headshots/nba/latest/260x190/2544.png", user?.avatar)
    XCTAssertEqual("LeBron James", user?.name)
    XCTAssertEqual("lebron_james", user?.wechatId)
    XCTAssertEqual(.male, user?.gender)
    XCTAssertEqual("USA", user?.region)
    XCTAssertEqual("Hello, I'm LeBron James!", user?.whatsUp)
  }
}

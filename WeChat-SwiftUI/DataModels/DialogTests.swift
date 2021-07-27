import XCTest
@testable import WeChat_SwiftUI

final class DialogTests: XCTestCase {
  func test_equatable() {
    XCTAssertEqual(Dialog.template1, Dialog.template1)
    XCTAssertNotEqual(Dialog.template1, Dialog.template2)
  }

  func test_description() {
    XCTAssertNotEqual("", Dialog.template1.debugDescription)
  }

  func test_jsonParsing() {
    let json = """
      {
        "id": "55b6cda0-f563-4eb8-88f9-28ff22a53cf7",
        "name": "SwiftUI",
        "members": [
          {
            "id": "112ec2a2-68d3-4949-9ce9-82ec80db9c60",
            "avatar": "https://cdn.nba.com/headshots/nba/latest/260x190/1629630.png",
            "name": "Ja Morant",
            "joinTime": "2021-07-14T09:54:22Z"
          },
          {
            "id": "4d0914d5-b04c-43f1-b37f-b2bb8d177951",
            "avatar": "https://cdn.nba.com/headshots/nba/latest/260x190/2544.png",
            "name": "LeBron James",
              "joinTime": "2021-07-14T09:54:22Z"
          }
        ],
        "messages": [
          {
            "id": "d6a696da-2c7a-4d27-87e3-6f63fd3e597f",
            "text": "hello world",
            "sender": {
              "id": "112ec2a2-68d3-4949-9ce9-82ec80db9c60",
              "avatar": "https://cdn.nba.com/headshots/nba/latest/260x190/1629630.png",
              "name": "Ja Morant"
            },
            "createTime": "2021-07-14T09:54:22Z"
          }
        ],
        "lastMessageText": "hello world",
        "lastMessageTime": "2021-07-14T09:54:22Z",
        "createTime": "2021-07-14T09:54:22Z"
      }
      """

    let dialog: Dialog? = tryDecode(json)

    XCTAssertEqual(dialog?.id, "55b6cda0-f563-4eb8-88f9-28ff22a53cf7")
    XCTAssertEqual(dialog?.name, "SwiftUI")
    XCTAssertEqual(dialog?.members.count, 2)
    XCTAssertEqual(dialog?.messages.count, 1)
    XCTAssertEqual(dialog?.lastMessageText, "hello world")
    XCTAssertEqual(dialog?.lastMessageTime, ISO8601DateFormatter().date(from: "2021-07-14T09:54:22Z"))
    XCTAssertEqual(dialog?.createTime, ISO8601DateFormatter().date(from: "2021-07-14T09:54:22Z"))
  }
}
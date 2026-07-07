import XCTest
@testable import RecitalReel

@MainActor
final class RecitalReelTests: XCTestCase {
    var store: Store!

    override func setUp() {
        super.setUp()
        store = Store()
        store.items = []
        store.save()
    }

    func testAddItem() {
        let item = Performance(venue: "Test", note: "Note")
        store.add(item)
        XCTAssertEqual(store.items.count, 1)
    }

    func testAddInsertsAtFront() {
        store.add(Performance(venue: "First", note: ""))
        store.add(Performance(venue: "Second", note: ""))
        XCTAssertEqual(store.items.first?.venue, "Second")
    }

    func testDeleteItem() {
        let item = Performance(venue: "ToDelete", note: "")
        store.add(item)
        store.delete(item)
        XCTAssertTrue(store.items.isEmpty)
    }

    func testDeleteAtOffsets() {
        store.add(Performance(venue: "A", note: ""))
        store.add(Performance(venue: "B", note: ""))
        store.delete(at: IndexSet(integer: 0))
        XCTAssertEqual(store.items.count, 1)
    }

    func testFreeLimitAllowsAdding() {
        for i in 0..<Store.freeLimit {
            store.add(Performance(venue: "Item \(i)", note: ""))
        }
        XCTAssertEqual(store.items.count, Store.freeLimit)
        XCTAssertFalse(store.canAddMore)
    }

    func testCanAddMoreWhenUnderLimit() {
        store.add(Performance(venue: "One", note: ""))
        XCTAssertTrue(store.canAddMore)
    }

    func testProBypassesLimit() {
        store.isPro = true
        for i in 0..<(Store.freeLimit + 5) {
            store.add(Performance(venue: "Item \(i)", note: ""))
        }
        XCTAssertTrue(store.canAddMore)
    }

    func testUpdateItem() {
        var item = Performance(venue: "Original", note: "")
        store.add(item)
        item.venue = "Updated"
        store.update(item)
        XCTAssertEqual(store.items.first?.venue, "Updated")
    }
}

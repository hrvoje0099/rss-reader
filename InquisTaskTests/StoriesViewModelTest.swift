//
//  StoriesViewModelTest.swift
//  InquisTaskTests
//
//  Created by Hrvoje Vuković on 16.12.2021..
//

import XCTest
@testable import InquisTask

class StoriesViewModelTest: XCTestCase {

    var storiesViewModel: StoriesViewModel!
    
    override func setUp() {
        super.setUp()
        
        let repository = Repository()
        let feedURL = "https://www.index.hr/rss/sport"
        storiesViewModel = StoriesViewModel(repository, feedURL)
    }
    
    override func tearDown() {
        storiesViewModel = nil
        super.tearDown()
    }

    func testStoriesViewModelInit() {
        let storiesViewModelMirror = Mirror(reflecting: storiesViewModel as Any)
        XCTAssertNotNil(storiesViewModelMirror)
    }
    
    func testFeedStoriesCount() {
        XCTAssertEqual(storiesViewModel.feedStoriesCount, 0)
    }
    
    func testGetStories() {
        let getStoriesMirror = Mirror(reflecting: storiesViewModel.getStories())
        XCTAssertNotNil(getStoriesMirror)
    }
    
    func testGetStoryCreatedDate() {
        XCTAssertEqual(storiesViewModel.getStoryCreatedDate(at: IndexPath(row: 0, section: 0)), "")
    }
    
    func testGetStoryTitle() {
        XCTAssertEqual(storiesViewModel.getStoryTitle(at: IndexPath(row: 0, section: 0)), "")
    }
    
    func testGetStoryLink() {
        XCTAssertEqual(storiesViewModel.getStoryTitle(at: IndexPath(row: 0, section: 0)), "")
    }
    
    func testGetTitle() {
        XCTAssertEqual(storiesViewModel.getTitle(), "")
    }
}

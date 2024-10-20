////
////  PlaceFilteringTests.swift
////  NeighborhoodTests
////
////  Created by Laurent Lefebvre on 10/20/24.
////
//
//import XCTest
//@testable import Neighborhood
//
//class PlaceFilteringTests: XCTestCase {
//
//    var places: [Place]!
//    var placeListView: PlaceListView!
//
//    override func setUp() {
//        super.setUp()
//        // Set up some sample data
//        places = [
//            Place(id: "1", name: "Everyday Cafe", address: "123 Main St", stars: 4, reviews: 35, price: "$$", description: "Cozy cafe with outdoor seating", imageURL: nil),
//            Place(id: "2", name: "Sunset Diner", address: "456 Broadway", stars: 5, reviews: 50, price: "$$$", description: "Classic diner with great views", imageURL: nil),
//            Place(id: "3", name: "Mountain View Restaurant", address: "789 Hilltop Rd", stars: 3, reviews: 40, price: "$", description: "Hilltop restaurant with mountain views", imageURL: nil),
//            Place(id: "4", name: "Everyday Coffee House", address: "101 Maple Ave", stars: 4, reviews: 25, price: "$", description: "Quiet coffee house", imageURL: nil)
//        ]
//        
//        // Initialize PlaceListView with the sample places
//        placeListView = PlaceListView()
//        placeListView.places = places
//    }
//
//    override func tearDown() {
//        places = nil
//        placeListView = nil
//        super.tearDown()
//    }
//
//    func testFilteringPlacesWithExactMatch() {
//        // Set the search query to an exact match
//        placeListView.query = "Everyday Cafe"
//        
//        // Verify the filtered results
//        let filtered = placeListView.filteredPlaces
//        XCTAssertEqual(filtered.count, 1)
//        XCTAssertEqual(filtered.first?.name, "Everyday Cafe")
//    }
//
//    func testFilteringPlacesWithPartialMatch() {
//        // Set the search query to a partial match
//        placeListView.query = "Everyday"
//        
//        // Verify the filtered results
//        let filtered = placeListView.filteredPlaces
//        XCTAssertEqual(filtered.count, 2)
//        XCTAssertTrue(filtered.contains { $0.name == "Everyday Cafe" })
//        XCTAssertTrue(filtered.contains { $0.name == "Everyday Coffee House" })
//    }
//
//    func testFilteringPlacesWithNoMatch() {
//        // Set the search query to something that doesn't match
//        placeListView.query = "Ocean"
//        
//        // Verify the filtered results
//        let filtered = placeListView.filteredPlaces
//        XCTAssertEqual(filtered.count, 0)
//    }
//
//    func testFilteringPlacesIsCaseInsensitive() {
//        // Set the search query with different casing
//        placeListView.query = "everyday cafe"
//        
//        // Verify the filtered results
//        let filtered = placeListView.filteredPlaces
//        XCTAssertEqual(filtered.count, 1)
//        XCTAssertEqual(filtered.first?.name, "Everyday Cafe")
//    }
//}


import XCTest
@testable import Neighborhood

class PlaceFilteringTests: XCTestCase {

    var places: [Place]!

    override func setUp() {
        super.setUp()
        // Set up some sample data
        places = [
            Place(id: "1", name: "Everyday Cafe", address: "123 Main St", stars: 4, reviews: 35, price: "$$", description: "Cozy cafe with outdoor seating", imageURL: nil),
            Place(id: "2", name: "Sunset Diner", address: "456 Broadway", stars: 5, reviews: 50, price: "$$$", description: "Classic diner with great views", imageURL: nil),
            Place(id: "3", name: "Mountain View Restaurant", address: "789 Hilltop Rd", stars: 3, reviews: 40, price: "$", description: "Hilltop restaurant with mountain views", imageURL: nil),
            Place(id: "4", name: "Everyday Coffee House", address: "101 Maple Ave", stars: 4, reviews: 25, price: "$", description: "Quiet coffee house", imageURL: nil)
        ]
    }

    override func tearDown() {
        places = nil
        super.tearDown()
    }

    func testFilteringPlacesWithExactMatch() {
        let filtered = PlaceFilter.filterPlaces(places, query: "Everyday Cafe")
        XCTAssertEqual(filtered.count, 1)
        XCTAssertEqual(filtered.first?.name, "Everyday Cafe")
    }

    func testFilteringPlacesWithPartialMatch() {
        let filtered = PlaceFilter.filterPlaces(places, query: "Everyday")
        XCTAssertEqual(filtered.count, 2)
        XCTAssertTrue(filtered.contains { $0.name == "Everyday Cafe" })
        XCTAssertTrue(filtered.contains { $0.name == "Everyday Coffee House" })
    }

    func testFilteringPlacesWithNoMatch() {
        let filtered = PlaceFilter.filterPlaces(places, query: "Ocean")
        XCTAssertEqual(filtered.count, 0)
    }

    func testFilteringPlacesIsCaseInsensitive() {
        let filtered = PlaceFilter.filterPlaces(places, query: "everyday cafe")
        XCTAssertEqual(filtered.count, 1)
        XCTAssertEqual(filtered.first?.name, "Everyday Cafe")
    }
}

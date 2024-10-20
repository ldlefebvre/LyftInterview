import Foundation

/// A place in the neighborhood.
struct Place: Codable, Identifiable {
    var id: String
    var name: String
    var address: String
    var stars: Int
    var reviews: Int
    var price: String
    var description: String
    var imageURL: URL?
}

/// Sample place data.
extension Place {
    static var examplePlace: Place = Place(
        id: "place1",
        name: "Everyday Cafe",
        address: "123 Main St",
        stars: 4,
        reviews: 35,
        price: "$$",
        description: "Cozy cafe with outdoor seating",
        imageURL: URL(string: "https://example.com/image1.jpg")
    )
    
    static var examplePlace2: Place = Place(
        id: "place2",
        name: "Sunset Diner",
        address: "456 Broadway",
        stars: 5,
        reviews: 50,
        price: "$$$",
        description: "Classic diner with great views",
        imageURL: URL(string: "https://example.com/image2.jpg")
    )
    
    static var examplePlaces: [Place] = [.examplePlace, .examplePlace2]
}

/// Response from places API.
struct PlaceResult: Codable {
    var places: [Place]
}

/// Response from images API.
struct ImageResult: Codable {
    var image: URL
    
    enum CodingKeys: String, CodingKey {
      case image = "img"
    }
}

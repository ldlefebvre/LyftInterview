import Foundation

struct PlaceFetcher {
    /// Fetches and returns a list of `Place`s with their `imageURL` property set.
    static func loadPlacesWithImages() async throws -> [Place] {
        // Define the URL for fetching places
        let placesURL = URL(string: "https://api.byteboard.dev/data/places")!
        
        do {
            // Perform the GET request to fetch places
            let (placesData, _) = try await URLSession.shared.data(from: placesURL)
            
            // Decode the fetched places data into a PlaceResult struct
            let placesResult = try JSONDecoder().decode(PlaceResult.self, from: placesData)
            
            // Initialize an empty array to store places with their images
            var placesWithImages: [Place] = []
            
            // Create a group to handle concurrent image fetching
            await withTaskGroup(of: Place?.self) { group in
                for place in placesResult.places {
                    group.addTask {
                        let imageURL = URL(string: "https://api.byteboard.dev/data/img/\(place.id)")!
                        do {
                            let (imageData, _) = try await URLSession.shared.data(from: imageURL)
                            let imageResult = try JSONDecoder().decode(ImageResult.self, from: imageData)
                            // Return the place with the image URL
                            return Place(id: place.id, name: place.name, address: place.address, stars: place.stars, reviews: place.reviews, price: place.price, description: place.description, imageURL: imageResult.image)
                        } catch {
                            print("Error fetching image for place \(place.id): \(error.localizedDescription)")
                            // Return the place without an image if the image fetch fails
                            return place
                        }
                    }
                }
                
                // Collect all results from the task group
                for await placeWithImage in group {
                    if let placeWithImage = placeWithImage {
                        placesWithImages.append(placeWithImage)
                    }
                }
            }
            
            // Return the places with their respective images
            return placesWithImages
            
        } catch {
            // Handle errors fetching places data
            print("Error fetching places: \(error.localizedDescription)")
            throw error // Optionally, return an empty array or cached data if available
        }
    }
}

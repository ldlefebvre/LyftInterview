import SwiftUI

/// Displays a list of places in the neighborhood.
struct PlaceListView: View {
    @State var places: [Place] = []
    @State var query: String = ""
    
    var body: some View {
        //Could further Add a LazyVStack and debounce mechanism if required (wondering if it's outside the scope of the 3 Tasks to implement it but would be fairly straight forward of replacing the list with a scrollview, lazyvstack and foreach. Then add a .onChange(of: query) to catch a debounce mechanism)
        List(filteredPlaces) { place in
            NavigationLink(destination: PlaceDetailsView(place: place)) {
                PlaceListItemView(place: place)
            }
        }
        .navigationTitle("Neighborhood")
        .searchable(text: $query, prompt: "Filter")
        .task {
            do {
                places = try await PlaceFetcher.loadPlacesWithImages()
            } catch {
                places = []
            }
        }
    }
    
    /// Returns a list of places by taking `places` and filtering based on the search query.
//    var filteredPlaces: [Place] {
//        if query.isEmpty {
//            return places
//        } else {
//            return places.filter { place in
//                // Perform case-insensitive filtering by checking if the query is in the place's name or address
//                matchesPrefix(place: place) ||
//                matchesPartialString(place: place) ||
//                matchesFuzzy(place: place)
//            }
//        }
//    }
    /// Filters the places based on the query using the extracted PlaceFilter logic.
    var filteredPlaces: [Place] {
        return PlaceFilter.filterPlaces(places, query: query)
    }

//    /// Checks if the query matches the **start** of the place name or address (Prefix Matching).
//    private func matchesPrefix(place: Place) -> Bool {
//        let lowercasedQuery = query.lowercased()
//        return place.name.lowercased().hasPrefix(lowercasedQuery) ||
//               place.address.lowercased().hasPrefix(lowercasedQuery)
//    }
//
//    /// Checks if the query appears **anywhere** in the place name or address (Partial String Matching).
//    private func matchesPartialString(place: Place) -> Bool {
//        let lowercasedQuery = query.lowercased()
//        return place.name.lowercased().contains(lowercasedQuery) ||
//               place.address.lowercased().contains(lowercasedQuery)
//    }
//
//    /// Implements a basic form of **fuzzy matching** by checking if the query is similar to the place name or address
//    /// (allowing minor variations or character mismatches).
//    private func matchesFuzzy(place: Place) -> Bool {
//        let lowercasedQuery = query.lowercased()
//        return basicFuzzyMatch(string: place.name.lowercased(), query: lowercasedQuery) ||
//               basicFuzzyMatch(string: place.address.lowercased(), query: lowercasedQuery)
//    }
//
//    /// A basic fuzzy matching function that allows for a small number of character mismatches
//    /// between the query and the string.
//    private func basicFuzzyMatch(string: String, query: String) -> Bool {
//        let stringChars = Array(string)
//        let queryChars = Array(query)
//
//        // Allow up to 2 mismatches between the query and the string
//        let allowedMismatches = 2
//        var mismatchCount = 0
//
//        var stringIndex = 0
//        var queryIndex = 0
//
//        while stringIndex < stringChars.count && queryIndex < queryChars.count {
//            if stringChars[stringIndex] != queryChars[queryIndex] {
//                mismatchCount += 1
//                if mismatchCount > allowedMismatches {
//                    return false
//                }
//            }
//            queryIndex += 1
//            stringIndex += 1
//        }
//
//        // Return true if the remaining characters don't exceed allowed mismatches
//        return mismatchCount <= allowedMismatches
//    }
}

struct PlaceListView_Previews: PreviewProvider {
    static var previews: some View {
        PlaceListView()
    }
}

struct PlaceFilter {
    static func filterPlaces(_ places: [Place], query: String) -> [Place] {
        if query.isEmpty {
            return places
        } else {
            let lowercasedQuery = query.lowercased()
            
            // First, prioritize exact matches on name or address
            let exactMatches = places.filter { place in
                place.name.lowercased() == lowercasedQuery || place.address.lowercased() == lowercasedQuery
            }
            
            // If any exact matches are found, return those
            if !exactMatches.isEmpty {
                return exactMatches
            }
            
            // Otherwise, fall back to partial and fuzzy matching
            return places.filter { place in
                matchesPrefix(place: place, query: query) ||
                matchesPartialString(place: place, query: query) ||
                matchesFuzzy(place: place, query: query)
            }
        }
    }

    private static func matchesPrefix(place: Place, query: String) -> Bool {
        let lowercasedQuery = query.lowercased()
        return place.name.lowercased().hasPrefix(lowercasedQuery) ||
               place.address.lowercased().hasPrefix(lowercasedQuery)
    }

    private static func matchesPartialString(place: Place, query: String) -> Bool {
        let lowercasedQuery = query.lowercased()
        return place.name.lowercased().contains(lowercasedQuery) ||
               place.address.lowercased().contains(lowercasedQuery)
    }

    private static func matchesFuzzy(place: Place, query: String) -> Bool {
        let lowercasedQuery = query.lowercased()
        return basicFuzzyMatch(string: place.name.lowercased(), query: lowercasedQuery) ||
               basicFuzzyMatch(string: place.address.lowercased(), query: lowercasedQuery)
    }

    private static func basicFuzzyMatch(string: String, query: String) -> Bool {
        let stringChars = Array(string)
        let queryChars = Array(query)

        let allowedMismatches = 2
        var mismatchCount = 0

        var stringIndex = 0
        var queryIndex = 0

        while stringIndex < stringChars.count && queryIndex < queryChars.count {
            if stringChars[stringIndex] != queryChars[queryIndex] {
                mismatchCount += 1
                if mismatchCount > allowedMismatches {
                    return false
                }
            }
            queryIndex += 1
            stringIndex += 1
        }

        return mismatchCount <= allowedMismatches
    }
}


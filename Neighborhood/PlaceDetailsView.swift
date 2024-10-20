
import SwiftUI

/// Displays detailed information about a place.
struct PlaceDetailsView: View {
    var place: Place

    // Dismiss environment to handle back navigation
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    // Image should go all the way up, ignoring the safe area
                    if let imageURL = place.imageURL {
                        AsyncImage(url: imageURL) { image in
                            image.resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(maxWidth: .infinity, maxHeight: 300)
                                .clipped() // Ensure the image fits without overflowing
                                .ignoresSafeArea(edges: .top)
                        } placeholder: {
                            Rectangle()
                                .fill(Color.gray.opacity(0.3))
                                .frame(height: 300)
                                .ignoresSafeArea(edges: .top)
                        }
                    }
                    
                    // Main content: Place details
                    VStack(alignment: .leading, spacing: 8) {
                        // Place's name
                        Text(place.name)
                            .font(.title2)
                            .fontWeight(.bold)
                        
                        // Place's address
                        Text(place.address)
                            .font(.subheadline)
                            .foregroundColor(.gray)
                        
                        // Star rating, reviews, and price (all in one line)
                        HStack {
                            StarsView(stars: place.stars)
                            Text("(\(place.reviews))")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                            Text(place.price) // Price level added here
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                        
                        // Description
                        Text(place.description)
                            .font(.body)
                            .foregroundColor(.secondary)
                    }
                    .padding()
                }
                .frame(maxWidth: .infinity) // Ensure content fits the screen width
            }
            
            // Custom back button on top of the image
            backButton
                .padding(.leading)
                .padding(.top, 60) // Adjust the position of the button
        }
        .ignoresSafeArea()
        .navigationBarHidden(true)
    }
    
    // Custom back button styled as a white circle with a border
    var backButton: some View {
        Button(action: {
            dismiss() // Go back to the previous screen
        }) {
            ZStack {
                Circle()
                    .fill(Color.white)
                    .frame(width: 40, height: 40)
                    .shadow(radius: 3)
                Circle()
                    .stroke(Color.gray, lineWidth: 1)
                    .frame(width: 40, height: 40)
                Image(systemName: "chevron.backward")
                    .foregroundColor(.black)
            }
        }
    }
}

struct PlaceDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            PlaceDetailsView(place: .examplePlace)
        }
    }
}

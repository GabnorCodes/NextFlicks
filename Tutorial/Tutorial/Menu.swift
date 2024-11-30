import SwiftUI

struct MovieData: Identifiable {
    let id = UUID() // Automatically generates a unique ID for each movie
    let title: String
    let posterPath: String?

    var posterURL: URL? {
        guard let posterPath = posterPath else { return nil }
        return URL(string: "https://image.tmdb.org/t/p/w500/\(posterPath)")
    }
}


struct Menu: View {
    @State private var isPressed = false
    var recommendedMovies: [MovieData] // Change from [String] to [MovieData]
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                ZStack {
                    // Background color
                    Color(red: 75/255, green: 57/255, blue: 239/255).edgesIgnoringSafeArea(.all)
                    
                    VStack {
                        Spacer()
                            .frame(height: geometry.size.height * 0.25)
                        
                        // Main content area with the RoundedRectangle
                        RoundedRectangle(cornerRadius: 0)
                            .frame(width: geometry.size.width, height: geometry.size.height * 6 / 7)
                            .foregroundColor(Color(red: 4/255, green: 39/255, blue: 57/255))
                    }
                    
                    VStack {
                        // Header text
                        VStack(alignment: .leading, spacing: 6) {
                            Text("Welcome back Alexander!")
                                .font(.system(size: geometry.size.width * 0.095, weight: .bold))
                                .foregroundColor(.white)
                                .padding(.horizontal, 13)
                            
                            Text("We'll find you something to watch...")
                                .font(.system(size: geometry.size.width * 0.05, weight: .semibold, design: .rounded))
                                .foregroundColor(Color.white.opacity(0.7))
                                .padding(.horizontal, 13)
                        }
                        
                        Spacer()
                    }
                    
                    VStack {
                        // Scrollable Movie Poster Row
                        FeedScroller(rowName: "Recommended Movies", contentType: "Movie", contentItems: recommendedMovies) // Update here
                            .padding(.top, 240)
                    }
                    
                    // Floating button at the bottom
                    VStack {
                        Spacer()
                        
                        Button(action: {
                            // Button action here
                        }) {
                            HStack {
                                ZStack {
                                    Circle()
                                        .fill(Color(red: 14/255, green: 39/255, blue: 75/255))
                                        .frame(width: 60, height: 60)
                                        .padding(.bottom, 5)
                                    
                                    Circle()
                                        .fill(Color(red: 67/255, green: 64/255, blue: 226/255))
                                        .frame(width: 50, height: 50)
                                        .padding(.bottom, 5)
                                    
                                    Image(systemName: "movieclapper")
                                        .font(.system(size: 24))
                                        .foregroundColor(.white)
                                        .padding(.bottom, 5)
                                }
                                
                                Text("Find me a movie!")
                                    .font(.system(size: geometry.size.width * 0.07, weight: .bold, design: .rounded))
                                    .foregroundColor(.white)
                            }
                            .frame(width: geometry.size.width * 0.80, height: geometry.size.height * 1 / 7)
                            .background(Color(red: 31/255, green: 11/255, blue: 154/255))
                            .cornerRadius(10)
                            .scaleEffect(isPressed ? 0.95 : 1.0)
                            .shadow(radius: 5)
                            .animation(.easeInOut(duration: 0.2), value: isPressed)
                        }
                        .simultaneousGesture(
                            DragGesture(minimumDistance: 0)
                                .onChanged({ _ in
                                    isPressed = true
                                })
                                .onEnded({ _ in
                                    isPressed = false
                                })
                        )
                        .padding(.bottom, geometry.size.height * 6 / 7 - 60)
                        .padding(.trailing, geometry.size.width * 1 / 9)
                    }
                }
            }
        }
    }
}

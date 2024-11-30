import SwiftUI

struct FeedScroller: View {
    let rowName: String
    let contentType: String
    let contentItems: [MovieData] // Updated to MovieData type

    var body: some View {
        VStack(alignment: .leading) {
            Text(rowName)
                .font(.headline)
                .padding(.leading)

            ScrollView(.horizontal) {
                HStack(spacing: 10) {
                    ForEach(contentItems) { movie in
                        VStack {
                            if let posterURL = movie.posterURL {
                                AsyncImage(url: posterURL) { image in
                                    image
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 100, height: 150)
                                } placeholder: {
                                    ProgressView()
                                }
                            } else {
                                Text("No poster available")
                                    .frame(width: 100, height: 150)
                                    .background(Color.gray.opacity(0.3))
                                    .cornerRadius(5)
                            }
                            Text(movie.title)
                                .font(.caption)
                                .multilineTextAlignment(.center)
                        }
                    }
                }
                .padding(.horizontal)
            }
        }
    }
}

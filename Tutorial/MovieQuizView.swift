//
//  MovieQuizView.swift
//  NextFlicks
//
//  Created by Gabe Jimenez on 10/28/24.
//


import SwiftUI

struct MovieQuizView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel: ChatGPTService
    @State private var currentMovieIndex: Int = 0
    @State private var favoriteMovies: [String] = ["", "", ""]  // Array to store favorite movies
    var onComplete: ([String]) -> Void
    
    var body: some View {
        VStack {
            if viewModel.seenMovieCount < viewModel.totalMoviesToRate {
                Text("Rate the movie:")
                Text(viewModel.quizMovies[currentMovieIndex])
                    .font(.largeTitle)
                    .padding()
                
                HStack {
                    Button("Like") {
                        viewModel.recordMovieResponse(movie: viewModel.quizMovies[currentMovieIndex], liked: true)
                        nextMovie()
                    }
                    Button("Dislike") {
                        viewModel.recordMovieResponse(movie: viewModel.quizMovies[currentMovieIndex], liked: false)
                        nextMovie()
                    }
                    Button("Haven't Seen") {
                        nextMovie()
                    }
                }
            } else {
                Text("Enter your favorite movies:")
                ForEach(0..<3, id: \.self) { index in
                    TextField("Favorite Movie \(index + 1)", text: $favoriteMovies[index])
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                }
                
                Button("Generate Recommendations") {
                    viewModel.requestOpenAIRecommendations(
                        likedMovies: viewModel.likedMovies,
                        dislikedMovies: viewModel.dislikedMovies,
                        favoriteMovies: favoriteMovies
                    ) { recommendations in
                        // Handle the recommendations (e.g., pass them to ContentView)
                        print("Generated Recommendations: \(recommendations)") // For testing
                        presentationMode.wrappedValue.dismiss() // Dismiss the quiz view
                    }
                }
                
                Text("Recommendations:")
                ForEach(viewModel.recommendations, id: \.self) { recommendation in
                    Text(recommendation)
                }
            }
        }
        .padding()
    }
    
    private func nextMovie() {
        if currentMovieIndex < viewModel.quizMovies.count - 1 {
            currentMovieIndex += 1
        }
    }
}

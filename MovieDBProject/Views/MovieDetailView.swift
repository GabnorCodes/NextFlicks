//
//  MovieDetailView.swift
//  MovieDBProject
//
//  Created by Gabe Jimenez on 11/12/24.
//

import SwiftUI

struct MovieDetailView: View {
    
    let movieID: Int
    @ObservedObject private var movieDetailState = MovieDetailState()
    
    var body: some View {
        ZStack {
            LoadingView(isLoading: self.movieDetailState.isLoading, error: self.movieDetailState.error) {
                self.movieDetailState.loadMovie(id: self.movieID)
            }
            
            if movieDetailState.movie != nil {
                MovieDetailListView(movie: self.movieDetailState.movie!)
                    .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
            }
        }
        .navigationTitle(movieDetailState.movie?.title ?? "")
        .onAppear {
            self.movieDetailState.loadMovie(id:self.movieID)
        }
    }
}

struct MovieDetailListView: View {
    
    let movie: Movie
    
    var body: some View {
        List {
            MovieDetailImage(imageURL: self.movie.backdropURL)
                .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                .listRowSeparator(.hidden)
            HStack {
                Text(movie.genreText)
                Text("·")
                Text(movie.yearText)
                Text("·")
                Text(movie.durationText)
            }
                .listRowSeparator(.hidden)
            
            Text(movie.overview)
            HStack {
                if !movie.ratingText.isEmpty {
                    Text(movie.ratingText).foregroundStyle(.yellow)
                }
                Text(movie.scoreText)
            }
                .listRowSeparator(.hidden)
            Divider()
                .listRowSeparator(.hidden)
            
            HStack(alignment: .top, spacing: 4) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Starring").font(.headline)
                        .fontWeight(.heavy)
                    ForEach(self.movie.cast!.prefix(9)) { cast in
                        HStack {
                            Text(cast.name)
                                .fontWeight(.semibold)
                            Text("·")
                                .fontWeight(.bold)
                            Text(cast.character)
                        }
                    }
                }
            }
            .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
            .listRowSeparator(.hidden)
            Spacer()
        }
    }
}

struct MovieDetailImage: View {
    
    @ObservedObject private var imageLoader = ImageLoader()
    let imageURL: URL
    
    var body: some View {
        ZStack {
            Rectangle().fill(Color.gray.opacity(0.3))
            if self.imageLoader.image != nil {
                Image(uiImage: self.imageLoader.image!)
                    .resizable()
            }
        }
        .aspectRatio(16/9, contentMode: .fit)
        .onAppear {
            self.imageLoader.loadImage(with: self.imageURL)
        }
    }
}

#Preview {
    NavigationView {
        MovieDetailView(movieID: Movie.stubbedMovie.id)
    }
}

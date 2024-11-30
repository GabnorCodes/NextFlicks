//
//  ContentView.swift
//  Tutorial
//
//  Created by Gabe Jimenez on 9/5/24.
//

import SwiftUI

struct ContentView: View {
    @State private var selectedTab: Tab = .house
    @State private var recommendations: [MovieData] = []
    @State private var showQuiz: Bool = false
    private let tmdbService = TMDbService()
    
    var body: some View {
        NavigationStack {
            ZStack {
                VStack {
                    TabView(selection: $selectedTab) {
                        ForEach(Tab.allCases, id: \.rawValue) { tab in
                            switch selectedTab {
                            case .house:
                                Menu(recommendedMovies: recommendations)
                            case .film:
                                MovieFinder()
                            case .person:
                                Account()
                            }
                        }
                    }
                }
                VStack {
                    Spacer()
                    Navbar(selectedTab: $selectedTab)
                }
                .frame(alignment: .bottom)
            }
            .onAppear {
                startQuiz()
            }
            .sheet(isPresented: $showQuiz) {
                MovieQuizView(viewModel: ChatGPTService(), onComplete: { recs in
                    fetchMovies(for: recs)
                    self.selectedTab = .house
                    self.showQuiz = false
                })
            }
        }
    }
    
    private func fetchMovies(for titles: [String]) {
        recommendations = [] // Clear old recommendations
        let dispatchGroup = DispatchGroup() // Use a dispatch group to wait for all fetches

        for title in titles {
            dispatchGroup.enter() // Enter the dispatch group
            tmdbService.fetchMovie(title: title) { movie in
                if let movie = movie {
                    DispatchQueue.main.async {
                        self.recommendations.append(movie) // Append the fetched movie
                    }
                }
                dispatchGroup.leave() // Leave the dispatch group regardless of success
            }
        }

        // Optionally, you can notify when all movies are fetched
        dispatchGroup.notify(queue: .main) {
            print("All movies fetched.")
            // Here you can do any additional processing after fetching all movies
        }
    }

    
    func startQuiz() {
        showQuiz = true // Activate the quiz view
    }
}

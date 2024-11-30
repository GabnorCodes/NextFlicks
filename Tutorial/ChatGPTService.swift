import SwiftUI
import Combine

// Your API keys
let tmdbAPIKey = "NO_API_KEY_FOR_U" // TMDb API key
let chatGPTAPIKey = "DITTO" // ChatGPT API key

// Movie Struct
struct Movie {
    let title: String
    let genre: String
    let description: String
    let releaseDate: String
}

// TMDb Response Struct
struct MovieResponse: Codable {
    let results: [TMDBMovie]
}

struct TMDBMovie: Codable {
    let title: String
    let overview: String
    let release_date: String
    let genre_ids: [Int]
}

struct QuizResults: Codable {
    var likedMovies: [String]
    var dislikedMovies: [String]
    var favoriteMovies: [String] // Add this line
}

// ViewModel for handling quiz and recommendations
class ChatGPTService: ObservableObject {
    @Published var quizMovies: [String] = []
    @Published var recommendations: [String] = []
    @Published var favoriteMovies: [String] = ["", "", ""]
    @Published var isQuizCompleted: Bool = false
    private var cancellable: AnyCancellable?
    var likedMovies: [String] = []
    var dislikedMovies: [String] = []
    public var seenMovieCount: Int = 0

    let totalMoviesToRate = 40
    let allMovies: [String] = [
            "The Shawshank Redemption", "The Exorcist", "Finding Nemo", "Inception", "Mean Girls",
            "The Dark Knight", "Toy Story", "A Quiet Place", "Gladiator", "The Babadook",
            "The Matrix", "Whiplash", "Spider-Man: No Way Home", "Zootopia", "Psycho",
            "Jurassic Park", "Bridesmaids", "The Prestige", "Hereditary", "Coco",
            "Deadpool", "Train to Busan", "Django Unchained", "The Godfather", "Midsommar",
            "Avatar", "The Silence of the Lambs", "The Incredibles", "The Witch", "The Hangover",
            "Superbad", "A Nightmare on Elm Street", "Fight Club", "Parasite", "The Blair Witch Project",
            "The Social Network", "Zodiac", "Mean Girls", "The Invisible Man", "Inside Out",
            "The Usual Suspects", "The Cabin in the Woods", "Gone Girl", "Se7en", "Shutter Island",
            "12 Angry Men", "Horrible Bosses", "The Lion King", "The Terminator", "Memento",
            "Goodfellas", "The Big Lebowski", "Moonlight", "The Revenant", "Ringu",
            "The Departed", "Candyman", "The Conjuring", "The Road", "Her",
            "Spotlight", "Frozen", "Kung Fu Panda", "The Girl with All the Gifts", "The Shining",
            "The Help", "Love Actually", "A Beautiful Mind", "The Florida Project", "Klaus",
            "A Quiet Place Part II", "The Hobbit: An Unexpected Journey", "The Favourite", "Oldboy", "The Lego Movie",
            "Frozen II", "The Texas Chainsaw Massacre", "World War Z", "Finding Dory", "Lady Bird",
            "Little Miss Sunshine", "Insidious", "Bird Box", "Annihilation", "The Descent",
            "The Mist", "Final Destination", "The Angry Birds Movie", "The Road",
            "Train to Busan", "Dawn of the Dead", "I Am Legend", "Jaws", "The Blind Side",
            "Three Billboards Outside Ebbing, Missouri", "Happy Death Day", "Eragon", "My Neighbor Totoro", "The Nightmare Before Christmas",
            "Perfect Blue", "Kung Fu Panda 2", "Jumanji: Welcome to the Jungle", "Mulan (2020)", "Toy Story 3",
            "Moana", "Soul", "Weathering with You", "Spirited Away", "The Secret Life of Pets",
            "Ralph Breaks the Internet", "National Lampoon's Christmas Vacation", "The Polar Express", "Miracle on 34th Street", "Elf",
            "The Shape of Water", "Mad Max: Fury Road", "Crouching Tiger, Hidden Dragon", "The Grand Budapest Hotel", "12 Years a Slave",
            "Get Out", "The Big Short", "La La Land", "Black Panther", "Wonder Woman",
            "Inside Out", "A Star is Born", "Moonlight", "The Favourite", "Hereditary",
            "Parasite", "Jojo Rabbit", "1917", "Dunkirk", "The Irishman",
            "Marriage Story", "Ford v Ferrari", "Knives Out", "Spider-Man: Into the Spider-Verse", "Zombieland",
            "Coco", "The Incredibles 2", "Toy Story 4", "Onward", "Soul",
            "A Quiet Place", "The Invisible Man", "The Conjuring", "Get Out", "It Follows",
            "The Witch", "Hereditary", "Midsommar", "The Babadook", "The Cabin in the Woods",
            "Donnie Darko", "Trainspotting", "Fight Club", "Oldboy", "The Sixth Sense",
            "The Others", "Shutter Island", "Se7en", "Gone Girl", "Zodiac",
            "Prisoners", "No Country for Old Men", "The Road", "A Clockwork Orange", "The Machinist",
            "Requiem for a Dream", "Black Swan", "There Will Be Blood", "The Master", "Mulholland Drive"
        ]
    
    init() {
            // Load saved quiz results
            loadQuizResults()
            
            // Initialize quizMovies
            quizMovies = allMovies.count >= 150 ? Array(allMovies.prefix(150)) : allMovies
        }
    
    func completeQuiz() {
        isQuizCompleted = true
    }
        
    // Add a function to reset the quiz if needed
    func resetQuiz() {
        likedMovies.removeAll()
        dislikedMovies.removeAll()
        seenMovieCount = 0
        isQuizCompleted = false
        recommendations.removeAll() // Clear recommendations
    }
    
    func saveQuizResults() {
        let results = QuizResults(likedMovies: likedMovies, dislikedMovies: dislikedMovies, favoriteMovies: favoriteMovies)
            if let encoded = try? JSONEncoder().encode(results) {
                UserDefaults.standard.set(encoded, forKey: "quizResults")
            }
        }
        
    // Method to load quiz results
    func loadQuizResults() {
        if let data = UserDefaults.standard.data(forKey: "quizResults"),
            let decoded = try? JSONDecoder().decode(QuizResults.self, from: data) {
            likedMovies = decoded.likedMovies
            dislikedMovies = decoded.dislikedMovies
            favoriteMovies = decoded.favoriteMovies
            seenMovieCount = likedMovies.count + dislikedMovies.count
        }
    }

    
    func recordMovieResponse(movie: String, liked: Bool) {
        if liked {
            likedMovies.append(movie)
        } else {
            dislikedMovies.append(movie)
        }
        
        seenMovieCount += 1
        
        saveQuizResults()
    }
    
    func requestOpenAIRecommendations(likedMovies: [String], dislikedMovies: [String], favoriteMovies: [String], completion: @escaping ([String]) -> Void) {
        guard let url = URL(string: "https://api.openai.com/v1/chat/completions") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(chatGPTAPIKey)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let prompt = """
        Based on the user's preferences:
        (Third Priority) - Liked movies: \(likedMovies.joined(separator: ", "))
        (Secondary Priority) - Disliked movies: \(dislikedMovies.joined(separator: ", "))
        (Highest Priority) - Favorite movies: \(favoriteMovies.joined(separator: ", "))
        
        Recommend 5 movies that the user would like, ensuring no recommendations include disliked or liked movies. Focus on picking movies that would specifically suit the user's most common movie interests, factoring in things such as movie complexity, genre, etc. Take given factors into account based on priority level. Return only the movies in this Format: Movie1,Movie2,Movie3, etc. No spaces, use commas as seperators.
        """

        let json: [String: Any] = [
            "model": "gpt-4o-mini",
            "messages": [["role": "user", "content": prompt]]
        ]

        request.httpBody = try? JSONSerialization.data(withJSONObject: json)

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print("Error: \(error?.localizedDescription ?? "Unknown error")")
                return
            }

            if let response = try? JSONDecoder().decode(OpenAIResponse.self, from: data),
               let message = response.choices.first?.message.content {
                DispatchQueue.main.async {
                    self.recommendations = message.components(separatedBy: "\n").filter { !$0.isEmpty }
                    completion(self.recommendations)
                    print("ChatGPT Recommendations: \(self.recommendations)")
                }
            } else {
                print("Failed to decode response")
            }
        }

        task.resume()
    }
    
    struct OpenAIResponse: Codable {
        let choices: [Choice]
        
        struct Choice: Codable {
            let message: Message
        }
        
        struct Message: Codable {
            let content: String
        }
    }

    // Main View
//    struct ContentView: View {
//        @StateObject var viewModel = ChatGPTService()
//        @State private var currentMovieIndex: Int = 0
//        
//        var body: some View {
//            VStack {
//                if viewModel.seenMovieCount < viewModel.totalMoviesToRate {
//                    Text("Rate the movie:")
//                    Text(viewModel.quizMovies[currentMovieIndex])
//                        .font(.largeTitle)
//                        .padding()
//                    
//                    HStack {
//                        Button("Like") {
//                            viewModel.recordMovieResponse(movie: viewModel.quizMovies[currentMovieIndex], liked: true)
//                            nextMovie()
//                        }
//                        Button("Dislike") {
//                            viewModel.recordMovieResponse(movie: viewModel.quizMovies[currentMovieIndex], liked: false)
//                            nextMovie()
//                        }
//                        Button("Haven't Seen") {
//                            nextMovie()
//                        }
//                    }
//                } else {
//                    // Enter favorite movies
//                    Text("Enter your favorite movies:")
//                    ForEach(0..<3, id: \.self) { index in
//                        TextField("Favorite Movie \(index + 1)", text: $viewModel.favoriteMovies[index])
//                            .textFieldStyle(RoundedBorderTextFieldStyle())
//                            .padding()
//                    }
//                    
//                    Button("Generate Recommendations") {
//                        viewModel.requestOpenAIRecommendations(
//                            likedMovies: viewModel.likedMovies,
//                            dislikedMovies: viewModel.dislikedMovies,
//                            favoriteMovies: viewModel.favoriteMovies
//                        )
//                        // Save favorite movies when generating recommendations
//                        viewModel.saveQuizResults()
//                    }
//                    
//                    Text("Recommendations:")
//                    ForEach(viewModel.recommendations, id: \.self) { recommendation in
//                        Text(recommendation)
//                    }
//                }
//            }
//            .padding()
//        }
//        
//        private func nextMovie() {
//            if currentMovieIndex < viewModel.quizMovies.count - 1 {
//                currentMovieIndex += 1
//            }
//        }
//    }
    
    // App entry point
//    @main
//    struct MovieRecommendationApp: App {
//        var body: some Scene {
//            WindowGroup {
//                ContentView()
//            }
//        }
//    }
}

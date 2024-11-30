//
//  QuizView.swift
//  NextFlicks
//
//  Created by Gabe Jimenez on 10/29/24.
//

import SwiftUI

class QuizManager: ObservableObject {
    @Published var isQuizCompleted: Bool = false
}

struct QuizView: View {
    @ObservedObject var quizManager: QuizManager   // Observe the quiz manager

    var body: some View {
        VStack {
            // Your quiz content here
            
            Button("Complete Quiz") {
                quizManager.isQuizCompleted = true   // Set completion state
            }
            
            if quizManager.isQuizCompleted {
                Text("Congratulations! You completed the quiz.")
                    .font(.title)
                    .padding()
            }
        }
    }
}

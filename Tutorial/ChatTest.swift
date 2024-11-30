////
////  ChatTest.swift
////  NextFlicks
////
////  Created by Gabe Jimenez on 9/15/24.
////
//
//import SwiftUI
//
//struct ChatTest: View {
//    @State private var prompt: String = ""
//    @State private var responseText: String = ""
//    private let chatGPTService = ChatGPTService()
//    
//    var body: some View {
//        VStack {
//            TextField("Enter prompt", text: $prompt)
//                .textFieldStyle(RoundedBorderTextFieldStyle())
//                .padding()
//            
//            Button(action: {
//                getMovieRecommendations()
//            }) {
//                Text("Get Recommendations")
//                    .padding()
//                    .background(Color.blue)
//                    .foregroundColor(.white)
//                    .cornerRadius(8)
//            }
//            .padding()
//            
//            Text(responseText)
//                .padding()
//                .frame(maxWidth: .infinity, alignment: .leading)
//        }
//        .padding()
//    }
//    
//    private func getMovieRecommendations() {
//        chatGPTService.fetchChatGPTResponse(prompt: prompt) { response in
//            DispatchQueue.main.async {
//                if let response = response {
//                    self.responseText = response
//                } else {
//                    self.responseText = "Failed to get a response."
//                }
//            }
//        }
//    }
//}
//
//#Preview {
//    ChatTest()
//}
//

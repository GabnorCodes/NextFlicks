//
//  ContentView.swift
//  MovieDBProject
//
//  Created by Gabe Jimenez on 11/5/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        ZStack {
            MovieListView()
        }
        .padding()
    }
}

#Preview {
    ContentView()
}

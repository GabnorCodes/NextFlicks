//
//  ActivityIndicatorView.swift
//  MovieDBProject
//
//  Created by Gabe Jimenez on 11/11/24.
//

import SwiftUI

struct ActivityIndicatorView: UIViewRepresentable {
    func updateUIView(_ uiView: UIActivityIndicatorView, context: Context) {
    }
    
    func makeUIView(context: Context) -> UIActivityIndicatorView {
        let view = UIActivityIndicatorView(style: .large)
        view.startAnimating()
        return view
    }
}

#Preview {
    ActivityIndicatorView()
}

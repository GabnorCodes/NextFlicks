//
//  Navbar.swift
//  Tutorial
//
//  Created by Gabe Jimenez on 9/5/24.
//

import SwiftUI

enum Tab: String, CaseIterable {
    case house
    case film
    case person
}

struct Navbar: View {
    @Binding var selectedTab: Tab
    private var fillImage: String {
        selectedTab.rawValue + ".fill"
    }
    
    private var tabColor: Color {
        switch selectedTab {
        case .house:
            return .white
        case .film:
            return .white
        case .person:
            return .white
        }
    }
    
    var body: some View {
        VStack {
            HStack {
                ForEach(Tab.allCases, id: \.rawValue) { tab in
                    Spacer()
                    Image(systemName: selectedTab == tab ? fillImage : tab.rawValue)
                        .scaleEffect(selectedTab == tab ? 1.25 : 1)
                        .font(selectedTab == tab ? .system(size: 22) : .system(size: 20))
                        .foregroundColor(selectedTab == tab ? tabColor : .gray)
                        .onTapGesture {
                            withAnimation(.easeIn(duration: 0.1)) {
                                selectedTab = tab
                            }
                        }
                    Spacer()
                }
            }
            .frame(width: nil, height: 60)
            .background(Color(red: 4/255, green: 39/255, blue: 57/255))
            .cornerRadius(5)
        }

    }
}

struct Navbar_Previews: PreviewProvider {
    static var previews: some View {
        Navbar(selectedTab: .constant(.house))
    }
}

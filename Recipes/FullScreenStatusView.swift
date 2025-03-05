//
//  FullScreenStatusView.swift
//  Recipes
//
//  Created by Jaim Zuber on 3/8/25.
//

import SwiftUI

struct FullScreenStatusView: View {
    let text: String
    var body: some View {
        VStack {
            Spacer()
            Text(text)
                .font(.headline)
                .padding()
            Text("Pull to refresh")
                .font(.subheadline)
                .padding()
            Spacer()
        }
    }
}

#Preview {
    GeometryReader { geometry in
        ScrollView {
            FullScreenStatusView(text: "We encountered an error")
                .frame(width: geometry.size.width, height: geometry.size.height)
        }
    }
}

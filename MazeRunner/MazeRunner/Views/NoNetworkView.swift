//
//  NoNetworkView.swift
//  MazeRunner
//
//  Created by Brett Keck on 3/12/25.
//

import SwiftUI

// A banner to show at the top of the app if there is no active network connection
struct NoNetworkView: View {
    var body: some View {
        HStack {
            Spacer()
            Text(LocalizedStringKey("no_network_connection"))
                .padding(.vertical, 4)
                .foregroundColor(.white)
            Spacer()
        }
        .background(Color.red)
        .dynamicTypeSize(.xSmall ... .xLarge)
        .transition(.opacity.combined(with: .move(edge: .top)))
    }
}

#Preview {
    NoNetworkView()
}

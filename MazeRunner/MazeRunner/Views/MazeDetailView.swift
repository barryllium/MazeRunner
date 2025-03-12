//
//  MazeDetailView.swift
//  MazeRunner
//
//  Created by Brett Keck on 3/12/25.
//

import SwiftUI

struct MazeDetailView: View {
    @Bindable var mazeViewModel: MazeViewModel
    
    @State private var lastScaleValue: CGFloat = 1.0
    @State private var scale: CGFloat = 1.0
    
    let maxZoom: CGFloat = 5
    let minZoom: CGFloat = 1
    let padding: CGFloat = 32
    
    var body: some View {
        if let solvedMazeImage = mazeViewModel.solvedMazeImage {
            GeometryReader { geometry in
                let maxSize = min(geometry.size.width, geometry.size.height) - padding
                
                ScrollView([.horizontal, .vertical], showsIndicators: false) {
                    Image(uiImage: solvedMazeImage)
                        .resizable()
                        .frame(width: maxSize, height: maxSize)
                        .scaleEffect(self.scale)
                        .frame(
                            width: maxSize * self.scale,
                            height: maxSize * self.scale
                        )
                }
                .gesture(
                    MagnifyGesture()
                        .onChanged { value in
                            let delta = value.magnification / self.lastScaleValue
                            self.lastScaleValue = value.magnification
                            var newScale = self.scale * delta
                            newScale = max(min(newScale, maxZoom), minZoom)
                            self.scale = newScale
                        }
                        .onEnded { value in
                            self.lastScaleValue = 1.0
                        }
                )
            }
        } else {
            VStack(alignment: .center, spacing: 8) {
                Text("solving_maze")
                ProgressView()
            }
            .font(.headline)
        }
    }
}

#Preview {
    let viewModel = MazeViewModel()
    MazeDetailView(mazeViewModel: MazeViewModel())
}

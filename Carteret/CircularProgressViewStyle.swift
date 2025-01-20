//
//  CircularProgressViewStyle.swift
//  Carteret
//
//  Created by Alexander Rohrig on 1/17/25.
//

import SwiftUI

struct CircularProgressViewStyle: ProgressViewStyle {
    let showText: Bool
    
    func makeBody(configuration: Configuration) -> some View {
        ZStack {
            Circle()
                .trim(from: 0.0, to: CGFloat(configuration.fractionCompleted ?? 0))
                .stroke(Color.blue, lineWidth: 10)
                .rotationEffect(.degrees(-90))
                .animation(.linear, value: configuration.fractionCompleted)
            if showText {
                Text(String(format: "%.0f%%", (configuration.fractionCompleted ?? 0) * 100))
                    .font(.largeTitle)
                    .bold()
            }
        }
    }
}

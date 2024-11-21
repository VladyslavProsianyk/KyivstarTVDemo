//
//  SimilarItemView.swift
//  DemoApp
//
//  Created by Vladyslav Prosianyk on 20.11.2024.
//

import SwiftUI

struct SimilarItemView: View {
    let model: AssetDetailsSimilarModel
    
    var body: some View {
        AsyncImage(url: URL(string: model.image)) { phase in
            if let image = phase.image {
                image // Displays the loaded image.
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } else if phase.error != nil {
                Color.red //Displays a placeholder color when an error occurs.
                    .overlay(
                        Text("Image not loaded because of an error")
                            .font(.caption)
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                            .minimumScaleFactor(0.5)
                    )
                
            } else {
                Text("Image is loading...")
                    .font(.caption)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
            }
        }
        .frame(width: 104, height: 156)
        .overlay(alignment: .topLeading) {
            if !model.purchased {
                Image("lock_in_circle_small_icon")
                    .padding(8)
            }
        }
        .overlay(alignment: .bottom) {
            progressBar
        }
        .frame(width: 104, height: 156)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
    
    private var progressView: some View {
        ZStack(alignment: .leading) {
            Rectangle()
                .frame(height: 4)
                .foregroundColor(Color.gray.opacity(0.5))
            
            Rectangle()
                .frame(width: 33, height: 4)
                .foregroundColor(Color.blue)
        }
    }
    
    @ViewBuilder private var progressBar: some View {
        if model.progress > 0 {
            ProgressView(value: model.progress)
                .progressViewStyle(LinearProgressViewStyle())
                .background(Color.black.opacity(0.6))
                .frame(height: 4)
        }
    }
}

#if DEBUG
#Preview {
    SimilarItemView(model: .mockList.first!)
}
#endif

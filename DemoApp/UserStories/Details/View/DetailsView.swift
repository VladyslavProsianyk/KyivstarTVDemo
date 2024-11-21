//
//  DetailsView.swift
//  DemoApp
//
//  Created by Vladyslav Prosianyk on 20.11.2024.
//

import SwiftUI

struct DetailsView: View {
    // MARK: - Properties
    @ObservedObject var viewModel: DetailsViewModel
    
    // MARK: - Body
    var body: some View {
        Group {
            if viewModel.isLoading {
                loadingStateView
            } else if let model = viewModel.model {
                successStateView(model: model)
            } else if let error = viewModel.error {
                errorStateView(error)
            } else {
                noDataStateView
            }
        }
        .overlay(alignment: .topLeading, content: { backButton })
        .onAppear(perform: loadDetails)
        .navigationBarHidden(true)
        .navigationTitle("")
    }
    
    // MARK: - Private state views
    /// Loading state view
    /// to show when data
    /// is loading
    private var loadingStateView: some View {
        Color.white
            .ignoresSafeArea()
            .overlay {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
                    .foregroundStyle(.gray)
                    .scaleEffect(2)
            }
    }
    
    /// Success state view
    /// to show when data
    /// is loaded successfully
    private func successStateView(model: AssetDetailsModel) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            ZStack(alignment: .topLeading) {
                headImage(link: model.headImage)
                headImageGradient
            }
            .clipped()
            .frame(height: 250)
            
            playAndFavouriteButtonsStack
            
            Divider()
                .padding(.horizontal, 24)
            
            ScrollView {
                textStack(
                    title: model.title,
                    durationText: model.durationText,
                    year: model.year,
                    description: model.description
                )
                
                similarItemsGrid(similarAssets: model.similarAssets)
            }
        }
    }
    
    
    /// Error state view
    /// to show when error
    /// occurred during data
    /// loading
    private func errorStateView(_ error: Error) -> some View {
        Color.white
            .ignoresSafeArea()
            .overlay {
                VStack {
                    Text("An error occurred when loading data!")
                        .font(.title)
                        .foregroundStyle(.red)
                    
                    Text(error.localizedDescription)
                        .font(.body)
                        .padding(.bottom, 16)
                    
                    Button(action: loadDetails) {
                        Text("Retry")
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .background(Color.blue)
                            .foregroundStyle(.white)
                            .clipShape(Capsule())
                    }
                }
            }
    }
    
    /// "No data" state view
    /// to show when error
    /// didn't occurred during
    /// data loading and there
    /// is no data to show
    private var noDataStateView: some View {
        Color.white
            .ignoresSafeArea()
            .overlay {
                Text("No data")
                    .font(.title)
                    .foregroundStyle(.red)
            }
    }
    
    // MARK: - Success state components
    private func headImage(link: String) -> some View {
        AsyncImage(url: URL(string: link)) { phase in
            ZStack {
                Color.gray
                if let image = phase.image {
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(height: 250)
                } else if phase.error != nil {
                    Image(systemName: "photo")
                        .foregroundStyle(.white)
                        .font(.largeTitle)
                } else {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                }
            }
        }
    }
    
    private var headImageGradient: some View {
        LinearGradient(
            gradient:
                Gradient(
                    colors: [
                        Color.black.opacity(0.5),
                        Color.clear,
                        Color.clear,
                        Color.black.opacity(0.5)
                    ]
                ),
            startPoint: .bottom,
            endPoint: .top
        )
    }
    
    private var backButton: some View {
        Button(action: viewModel.popBack) {
            Image(systemName: "chevron.left")
                .padding(10)
                .background(Color.black.opacity(0.5))
                .foregroundStyle(Color.white)
                .clipShape(Circle())
        }
        .padding(.horizontal, 24)
        .padding(.top, 8)
    }
    
    private var playAndFavouriteButtonsStack: some View {
        HStack {
            Button(action: {
                print("did tap play")
            }) {
                HStack {
                    Image(systemName: "play.fill")
                    
                    Text("Play")
                        .font(.headline)
                }
                .padding(.horizontal, 32)
                .padding(.vertical, 10)
                .foregroundColor(.white)
                .background {
                    buttonBackground(fillColor: Color.blue, borderColor: Color.teal)
                }
            }
            
            Spacer()
            
            Button(action: {
                print("did tap favourite")
            }) {
                Image(systemName: "star.fill")
                    .padding(.vertical, 12)
                    .padding(.horizontal, 24)
                    .foregroundStyle(Color.black.opacity(0.7))
                    .background {
                        buttonBackground(fillColor: Color.gray.opacity(0.3), borderColor: Color.white)
                    }
            }
        }
        .padding(.horizontal, 24)
        .padding(.vertical, 16)
    }
    
    private func buttonBackground(fillColor: Color, borderColor: Color) -> some View {
        Capsule()
            .fill(fillColor)
            .overlay(
                Capsule()
                    .stroke(borderColor, lineWidth: 1.5)
                    .offset(x: 0, y: -1)
                    .scaleEffect(x: 1, y: 0.95)
            )
    }
    
    private func textStack(title: String, durationText: String, year: Int, description: String) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.system(size: 22, weight: .bold))
            
            //here is should the actual ganre, but there is no such data in response model
            Text("\("Some ganre") • \(durationText) • \(year.description)")
                .font(.system(size: 14, weight: .regular))
                .foregroundStyle(Color.black.opacity(0.7))
            
            Text(description)
                .font(.system(size: 12, weight: .regular))
                .foregroundStyle(.secondary)
                .padding(.bottom, 16)
            
            Text("Similar")
                .font(.system(size: 16, weight: .medium))
            
        }
        .padding(.horizontal, 24)
        .padding(.top, 16)
        .padding(.bottom, 8)
    }
    
    private func similarItemsGrid(similarAssets: [AssetDetailsSimilarModel]) -> some View {
        LazyVGrid(columns: [
            GridItem(spacing: 8),
            GridItem(spacing: 8),
            GridItem(spacing: 8),
        ], spacing: 8) {
            ForEach(0..<similarAssets.count, id: \.self) { index in
                SimilarItemView(model: similarAssets[index])
                    .onTapGesture {
                        print("did tap similar item with id \(similarAssets[index].id)")
                    }
            }
        }
        .padding(.horizontal, 24)
    }
        
    // MARK: - Private methods
    private func loadDetails() {
        Task {
            await viewModel.fetchDetails()
        }
    }
}

#if DEBUG
#Preview {
    DetailsView(viewModel: DetailsViewModel(coordinator: Coordinator(navigationController: UINavigationController())))
}
#endif

import SwiftUI

struct FavouritesView: View {
    
    @State var viewModel: FavouritesViewModel = .init()
    
    var body: some View {
        NavigationStack{
            List {
                ForEach(viewModel.assets) { asset in
                    NavigationLink {
                        AssetHistoryView(viewModel: .init(asset))
                    } label: {
                        AssetView(
                            assetViewState: .init(asset)
                        )
                    }
                }
            }
            .listStyle(.plain)
            .animation(.linear, value: viewModel.assets)
            .navigationTitle("Favourites")
        }
        .task {
            await viewModel.getFavourites()
        }
    }
}

#Preview {
    FavouritesView()
}

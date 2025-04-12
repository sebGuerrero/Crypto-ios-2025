import SwiftUI

struct AssetList: View {
    
    var viewModel: AssetListViewModel = .init()

//    @State var task: Task<Void, Never>?
    
    var body: some View {
        Text(viewModel.errorMessage ?? "")
            
        List {
            ForEach(viewModel.assets) { asset in
                AssetView(asset: asset)
            }
        }
        .listStyle(.plain)
        .task {
           await viewModel.fetchAssets()
        }
//        .onAppear {
//            task = Task {
//                await viewModel.fetchAssets()
//            }
//        }
//        .onDisappear {
//            task?.cancel()
//        }
    }
}

#Preview {
    AssetList()
}

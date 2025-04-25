import Foundation
import Dependencies

@Observable
final class FavouritesViewModel {
    
    @ObservationIgnored
    @Dependency(\.assetsApiClient) var apiClient
    
    @ObservationIgnored
    @Dependency(\.authClient) var authClient
    
    var assets: [Asset] = []
    
    func getFavourites() async {
        do {
            let user = try authClient.getCurrentUser()
            let stream = await apiClient.fetchFavourites(user)
            
            for await favouritesArray in stream {
                
                let removedAssets = Set(assets.map(\.id)).subtracting(Set(favouritesArray))
                for removed in removedAssets {
                    assets.removeAll { $0.id == removed}
                }
                
                await withTaskGroup { [self] group in
                    for favouriteId in favouritesArray {
                        if assets.contains(where: { $0.id == favouriteId}) {
                            continue
                        }
                        
                        group.addTask {
                            do {
                                print("Start fetching \(favouriteId)")
                                let asset = try await self.apiClient.fetchAsset(favouriteId)
                                self.assets += [asset]
                                print("Completed fetching \(favouriteId)")
                            } catch {
                                // TODO: Handle error
                            }
                        }
                    }
                }
               
            }

        } catch {
            print(error.localizedDescription)
            // Handle errors
        }
    }
}

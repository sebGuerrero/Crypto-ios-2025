import Foundation
import Dependencies

@Observable
final class FavouritesViewModel {
    
    @ObservationIgnored
    @Dependency(\.assetsApiClient) var apiClient
    
    @ObservationIgnored
    @Dependency(\.authClient) var authClient
    
    var assets: [Asset] = []
    
    var tasks: [Task<Void, Never>] = []
    
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
                        
                        let task = Task {
                            do {
                                print("Start fetching \(favouriteId)")
                                let asset = try await self.apiClient.fetchAsset(favouriteId)
                                self.assets += [asset]
                                print("Completed fetching \(favouriteId)")
                            } catch {
                                // TODO: Handle error
                            }
                        }
                        
                        group.addTask {
                            task
                        }
                        
                        tasks.append(task)
                    }
                }
            }

        } catch {
            print(error.localizedDescription)
            // Handle errors
        }
    }
    
    deinit {
        for task in tasks {
            task.cancel()
        }
    }
}

import Foundation
import Dependencies

@Observable
final class AssetHistoryViewModel {
    
    @ObservationIgnored
    @Dependency(\.assetsApiClient) var assetsApiClient
    
    var timelineData: [AssetHistory] = []
    var asset: Asset
    var chartRange: ClosedRange<Double> = 0...1
    
    let assetViewState: AssetViewState
        
    init(_ asset: Asset) {
        self.asset = asset
        self.assetViewState = .init(asset)
    }
    
    func fetchAssetHistory() async {
        do {
            let data = try await assetsApiClient.fetchAssetHistory(asset.id)

            let minValue = data.min(by: { $0.priceUsd < $1.priceUsd })?.priceUsd ?? 0.0
            let maxValue = data.max(by: { $1.priceUsd > $0.priceUsd })?.priceUsd ?? 1

            let padding = (maxValue - minValue) * 0.2
            let lowerBound = max(0.0, minValue - padding)
            let upperBound = maxValue

            chartRange = lowerBound...upperBound
            timelineData = data
        } catch {
            // TODO: Handle errors
        }
    }

    
}

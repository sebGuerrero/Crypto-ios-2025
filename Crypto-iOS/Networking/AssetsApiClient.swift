import Dependencies
import Foundation
import XCTestDynamicOverlay
import FirebaseFirestore

struct AssetsApiClient {
    var fetchAllAssets: () async throws -> [Asset]
    var saveFavourite: (User, Asset) async throws -> Void
    var fetchFavourites: @Sendable (User)  async -> AsyncStream<[String]>
    var fetchAsset: (String) async throws -> Asset
    var fetchAssetHistory: (String) async throws -> [AssetHistory]
}

enum AssetsApiClientError: Error {
}

extension AssetsApiClient: DependencyKey {
    static var liveValue: AssetsApiClient {
        let db = Firestore.firestore().collection("favourites")
        
        return .init(
            fetchAllAssets: {
                let assetsResponse = try await HTTPClient.sendRequest(
                    endpoint: AssetsEndpoints.fetchAll,
                    responseModel: AssetsResponse.self
                )
                return assetsResponse.data
            },
            saveFavourite: { user, asset in
                try await db.document(user.id).setData(
                    ["favourites": FieldValue.arrayUnion([asset.id])],
                    merge: true
                )
            },
            fetchFavourites: { user in
                return AsyncStream { continuation in
                    db.document(user.id).addSnapshotListener { documentSnapshot, error in
                        let favourites = documentSnapshot?.get("favourites") as? [String] ?? []
                        continuation.yield(favourites)
                    }
                }
            },
            fetchAsset: { assetId in
                let assetsResponse = try await HTTPClient.sendRequest(
                    endpoint: AssetsEndpoints.fetch(assetId),
                    responseModel: AssetResponse.self
                )
                return assetsResponse.data
            },
            fetchAssetHistory: { assetId in
                let response = try await HTTPClient.sendRequest(
                    endpoint: AssetsEndpoints.history(assetId),
                    responseModel: AssetHistoryResponse.self
                )
                return response.data
            }
        )
    }
    
    static var previewValue: AssetsApiClient {
        .init(
            fetchAllAssets: {[
                .init(
                    id: "bitcoin",
                    name: "Bitcoin",
                    symbol: "BTC",
                    priceUsd: "89111121.2828",
                    changePercent24Hr: "8.992929292"
                ),
                .init(
                    id: "ethereum",
                    name: "Ethereum",
                    symbol: "ETH",
                    priceUsd: "1289.282828",
                    changePercent24Hr: "-1.2323232323"
                ),
                .init(
                    id: "solana",
                    name: "Solana",
                    symbol: "SOL",
                    priceUsd: "500.29292929",
                    changePercent24Hr: "9.2828282"
                )
            ]},
            saveFavourite: { _, _ in },
            fetchFavourites: { _ in .finished },
            fetchAsset: { _ in .init(
                id: "solana",
                name: "Solana",
                symbol: "SOL",
                priceUsd: "500.29292929",
                changePercent24Hr: "9.2828282"
            )},
            fetchAssetHistory: { _ in []}
        )
    }
    
    static var testValue: AssetsApiClient {
        .init(
            fetchAllAssets: {
                XCTFail("AssetsApiClient.fetchAllAssets is unimplemented")
                //            reportIssue("AssetsApiClient.fetchAllAssets is unimplemented")
                return []
            },
            saveFavourite: { _, _ in
                XCTFail("AssetsApiClient.saveFavourite is unimplemented")
            },
            fetchFavourites: { _ in
                XCTFail("AssetsApiClietnt.fetchAsset is unimplemented")
                return .finished
            },
            fetchAsset: { _ in
                XCTFail("AssetsApiClient.fetchAsset is unimplemented")
                return .init(
                    id: "solana",
                    name: "Solana",
                    symbol: "SOL",
                    priceUsd: "500.29292929",
                    changePercent24Hr: "9.2828282"
                )
            },
            fetchAssetHistory: { _ in
                XCTFail("AssetsApiClient.fetchAssetHistory is unimplemented")
                return []
            }
        )
    }
}

extension DependencyValues {
    var assetsApiClient: AssetsApiClient {
        get { self[AssetsApiClient.self] }
        set { self[AssetsApiClient.self] = newValue }
    }
}


//
//
//protocol AssetsApiProtocol {
//    func getAssets() async throws -> [Asset]
//}
//
//
//struct AssetsApiService: AssetsApiProtocol {
//    func getAssets() async throws -> [Asset] {
//        let urlSession = URLSession.shared
//        
//        guard let url = URL(string: "https://4ff399d1-53e9-4a28-bc99-b7735bad26bd.mock.pstmn.io/v3/assets") else {
//            throw NetworkingError.invalidURL
//        }
//        
//        let (data, _) = try await urlSession.data(for: URLRequest(url: url))
//        let assetsResponse = try JSONDecoder().decode(AssetsResponse.self, from: data)
//        
//        return assetsResponse.data
//    }
//}
//
//struct AssetsApiServicePreview: AssetsApiProtocol {
//    func getAssets() async throws -> [Asset] {
//        [
//            .init(
//                id: "bitcoin",
//                name: "Bitcoin",
//                symbol: "BTC",
//                priceUsd: "89111121.2828",
//                changePercent24Hr: "8.992929292"
//            ),
//            .init(
//                id: "ethereum",
//                name: "Ethereum",
//                symbol: "ETH",
//                priceUsd: "1289.282828",
//                changePercent24Hr: "-1.2323232323"
//            ),
//            .init(
//                id: "solana",
//                name: "Solana",
//                symbol: "SOL",
//                priceUsd: "500.29292929",
//                changePercent24Hr: "9.2828282"
//            )
//        ]
//    }
//}

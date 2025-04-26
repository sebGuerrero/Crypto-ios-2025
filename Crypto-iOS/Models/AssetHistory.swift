import Foundation

struct AssetHistory: Decodable, Identifiable {
    var id: Int {
        time
    }
    let priceUsd: Double
    let time: Int
    
    var date: Date {
        Date(timeIntervalSince1970: TimeInterval(self.time/1000))
    }
    
    enum CodingKeys: String, CodingKey {
        case priceUsd
        case time
    }
    
    init(from decoder: Decoder) throws {
        let priceStr = try decoder.container(keyedBy: CodingKeys.self).decode(String.self, forKey: .priceUsd)
        self.priceUsd = Double(priceStr) ?? 0.0
        self.time = try decoder.container(keyedBy: CodingKeys.self).decode(Int.self, forKey: .time)
    }
}

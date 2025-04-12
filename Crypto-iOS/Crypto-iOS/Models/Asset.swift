import Foundation

struct Asset: Decodable, Identifiable {
    let id: String
    let name: String
    let symbol: String
    let priceUsd: String
    let changePercent24Hr: String
    
//    enum CodingKeys: String, CodingKey {
//        case id
//        case name
//        case symbol
//        case priceUsd = "price_usd"
//        case changePercent24Hr = "change_percent_24_hr"
//    }
    
    var percentage: Double {
        Double(changePercent24Hr) ?? 0
    }
    
    var formattedPrice: String {
        String(format: "%.2f", Double(priceUsd) ?? 0)
    }
    
    var formattedPercentage: String {
        String(format: "%.2f", Double(changePercent24Hr) ?? 0)
    }
    
    var iconUrl: URL? {
        URL(string: "https://assets.coincap.io/assets/icons/\(symbol.lowercased())@2x.png")
    }
}


//struct Persona: Identifiable {
//    
//    var id: String {
//        UUID().uuidString
//    }
//    
//    let ci: String
//    let name: String
//    let lastname: String
//}

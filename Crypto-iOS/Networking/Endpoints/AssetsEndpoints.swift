import Foundation

enum AssetsEndpoints {
    case fetchAll
    case fetch(String)
}

extension AssetsEndpoints: Endpoint {
    
    var path: String {
        let apiKey = "123123123"
        
        switch self {
        case .fetchAll:
            return "assets?apiKey=\(apiKey)"
        case .fetch(let id):
            return "assets/\(id)?apiKey=\(apiKey)"
        }
    }
    
    var method: RequestMethod {
        switch self {
        case .fetchAll, .fetch:
            return .get
        }
    }
    
    var header: [String : String]? {
        return nil
    }
    
    var body: [String : String]? {
        return nil
    }
}



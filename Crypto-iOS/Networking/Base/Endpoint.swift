protocol Endpoint {
    var baseURL: String { get }
    var path: String { get }
    var method: RequestMethod { get }
    var header: [String: String]? { get }
    var body: [String: String]? { get }
}

extension Endpoint {
  var baseURL: String {
    return "https://4ff399d1-53e9-4a28-bc99-b7735bad26bd.mock.pstmn.io/v3/"
  }
}

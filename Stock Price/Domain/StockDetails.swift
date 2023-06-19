struct StockDetails: Decodable {
    
    let currentPrice: Double
    let change: Double
    let percentChange: Double
    
    private enum CodingKeys: String, CodingKey {
        case currentPrice = "c"
        case change = "d"
        case percentChange = "dp"
    }
}

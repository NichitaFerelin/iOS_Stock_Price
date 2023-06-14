import Foundation

struct Stock: Codable {
    
    let name: String
    let symbol: String
    let logoUrl: String
    let country: String
    let phone: String
    let webUrl: String
    let industry: String
    let currency: String
    let capitalization: String
    
    enum CodingKeys: String, CodingKey {
        case name
        case symbol
        case logoUrl = "logo"
        case country
        case phone
        case webUrl = "weburl"
        case industry = "finnhubIndustry"
        case currency
        case capitalization = "marketCapitalization"
    }
}

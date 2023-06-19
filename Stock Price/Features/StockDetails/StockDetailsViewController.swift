import Foundation
import UIKit
import Alamofire

class StockDetailsViewController: UIViewController {
    
    private let companySymbol: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "HelveticaNeue-Bold", size: 18.0)
        return label
    }()
    
    private let companyFullName: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "HelveticaNeue-Normal", size: 12.0)
        return label
    }()
    
    private let backButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "Close"), for: .normal)
        return button
    }()
    
    private let stockImageView: UIImageView = {
        let image = UIImageView()
        image.clipsToBounds = true
        image.layer.cornerRadius = 4
        image.contentMode = .scaleAspectFit
        return image
    }()
    
    private let stockPrice: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "HelveticaNeue-Bold", size: 24.0)
        return label
    }()
    
    private let stockPriceChange: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "HelveticaNeue-Bold", size: 16.0)
        return label
    }()
    
    var selectedStock: StockDataModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(rgb: 0xFFF0F4F7)
        self.view.addSubview(backButton)
        self.view.addSubview(companySymbol)
        self.view.addSubview(companyFullName)
        self.view.addSubview(stockImageView)
        self.view.addSubview(stockPrice)
        self.view.addSubview(stockPriceChange)
        self.view.addSubview(stockPriceChange)
        self.view.addSubview(stockPriceChange)
        
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        backButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
        backButton.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 24).isActive = true
        backButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 15).isActive = true
        backButton.addTarget(self, action: #selector(onCloseTapped), for: .touchUpInside)
        
        companySymbol.translatesAutoresizingMaskIntoConstraints = false
        companySymbol.bottomAnchor.constraint(equalTo: backButton.centerYAnchor).isActive = true
        companySymbol.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        companySymbol.text = selectedStock!.symbol
        
        companyFullName.translatesAutoresizingMaskIntoConstraints = false
        companyFullName.topAnchor.constraint(equalTo: backButton.centerYAnchor).isActive = true
        companyFullName.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        companyFullName.text = selectedStock!.name
        
        stockImageView.translatesAutoresizingMaskIntoConstraints = false
        stockImageView.heightAnchor.constraint(equalToConstant: 34).isActive = true
        stockImageView.widthAnchor.constraint(equalToConstant: 34).isActive = true
        stockImageView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 24).isActive = true
        stockImageView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -15).isActive = true
        
        stockPrice.translatesAutoresizingMaskIntoConstraints = false
        stockPrice.topAnchor.constraint(equalTo: companyFullName.bottomAnchor, constant: 25).isActive = true
        stockPrice.centerXAnchor.constraint(equalTo: companyFullName.centerXAnchor).isActive = true
        
        stockPriceChange.translatesAutoresizingMaskIntoConstraints = false
        stockPriceChange.topAnchor.constraint(equalTo: stockPrice.bottomAnchor, constant: 5).isActive = true
        stockPriceChange.centerXAnchor.constraint(equalTo: stockPrice.centerXAnchor).isActive = true
        
        let countryRowView = addCompanyRowInfo(bottomOf: stockPriceChange, title: "Country", content: selectedStock!.country)
        let industryRowView = addCompanyRowInfo(bottomOf: countryRowView, title: "Industry", content: selectedStock!.industry)
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 0
        formatter.minimumFractionDigits = 0
        let capitalizationRowView = addCompanyRowInfo(bottomOf: industryRowView, title: "Capitalization", content: "$\(formatter.string(for: selectedStock!.capitalization)!)")
        
        AF.request(selectedStock!.logoUrl).responseImage { response in
            if let image = response.data {
                self.stockImageView.image = UIImage(data: image)
            }
        }
        
        let apiKey = Bundle.main.infoDictionary!["API_KEY"] as! String
        AF.request("https://finnhub.io/api/v1/quote?symbol=\(selectedStock!.symbol)&token=\(apiKey)").responseDecodable(of: StockDetailsModel.self) { response in
            
            if response.error == nil, let result = response.value {
                self.stockPrice.text = "$\(String(format: "%.2f", result.currentPrice))"
                
                let priceChange = String(format: "%.2f", abs(result.change))
                let priceChangePercent = String(format: "%.2f", abs(result.percentChange))
                let prefix = result.change > 0 ? "+" : "-"
                let resultStr = "\(prefix)$\(priceChange) (\(priceChangePercent)%)"
                self.stockPriceChange.text = resultStr
                
                if result.change > 0 {
                    self.stockPriceChange.textColor = .green
                } else {
                    self.stockPriceChange.textColor = .red
                }
            }
        }
    }
    
    @objc func onCloseTapped(sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    private func addCompanyRowInfo(bottomOf topView: UIView, title: String, content: String) -> UIView {
        let titleLabel = UILabel()
        titleLabel.font = UIFont(name: "HelveticaNeue-Medium", size: 20.0)
        titleLabel.textColor = .lightGray
        titleLabel.text = title
        
        let contentLabel = UILabel()
        contentLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 22.0)
        contentLabel.text = content
        
        self.view.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 40).isActive = true
        titleLabel.topAnchor.constraint(equalTo: topView.bottomAnchor, constant: 16).isActive = true
        
        self.view.addSubview(contentLabel)
        contentLabel.translatesAutoresizingMaskIntoConstraints = false
        contentLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -40).isActive = true
        contentLabel.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor).isActive = true
        
        return titleLabel
    }
}

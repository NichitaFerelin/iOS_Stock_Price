import Foundation
import UIKit
import Alamofire
import AlamofireImage

class StockViewCell: UICollectionViewCell {
    
    static let identifier = "StockCell"
    
    private var stockImageView: UIImageView = {
        let image = UIImageView()
        image.clipsToBounds = true
        image.layer.cornerRadius = 16
        image.contentMode = .scaleAspectFit
        return image
    }()
    
    private var companySymbol: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "HelveticaNeue-Bold", size: 18.0)
        return label
    }()
    
    private var companyFullName: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "HelveticaNeue-Normal", size: 12.0)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(stockImageView)
        contentView.addSubview(companySymbol)
        contentView.addSubview(companyFullName)
        contentView.clipsToBounds = true
        contentView.layer.cornerRadius = 16
        
        stockImageView.translatesAutoresizingMaskIntoConstraints = false
        stockImageView.heightAnchor.constraint(equalTo: contentView.heightAnchor, constant: -20).isActive = true
        stockImageView.widthAnchor.constraint(equalTo: contentView.heightAnchor, constant: -20).isActive = true
        stockImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        stockImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10).isActive = true
        
        companySymbol.translatesAutoresizingMaskIntoConstraints = false
        companySymbol.leadingAnchor.constraint(equalTo: stockImageView.trailingAnchor, constant: 15).isActive = true
        companySymbol.bottomAnchor.constraint(equalTo: stockImageView.centerYAnchor).isActive = true
        
        companyFullName.translatesAutoresizingMaskIntoConstraints = false
        companyFullName.leadingAnchor.constraint(equalTo: stockImageView.trailingAnchor, constant: 15).isActive = true
        companyFullName.topAnchor.constraint(equalTo: stockImageView.centerYAnchor).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        stockImageView.image = nil
    }
    
    func bind(_ stock: StockDataModel, at indexPath: IndexPath) {
        companySymbol.text = stock.symbol
        companyFullName.text = stock.name
        
        if (indexPath.row % 2 == 0) {
            contentView.backgroundColor = UIColor(rgb: 0xFFF0F4F7)
        } else {
            contentView.backgroundColor = .white
        }

        AF.request(stock.logoUrl).responseImage { response in
            if let image = response.data {
                self.stockImageView.image = UIImage(data: image)
            }
        }
    }
}

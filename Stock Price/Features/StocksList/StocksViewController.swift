import UIKit
import Foundation
import CoreData

class StocksViewController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    enum StocksSection {
        case all
    }
    
    private var stocks: [StockDataModel] = []
    private var fetchStocksController: NSFetchedResultsController<StockDataModel>!
    
    private let stocksCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(StockViewCell.self, forCellWithReuseIdentifier: StockViewCell.identifier)
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        view.addSubview(stocksCollectionView)
        
        stocksCollectionView.delegate = self
        stocksCollectionView.dataSource = self
        
        stocksCollectionView.backgroundColor = .white
        stocksCollectionView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        stocksCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        stocksCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        stocksCollectionView.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
        
        fetchStocksData()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return stocks.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width - 16, height: 68)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: StockViewCell.identifier, for: indexPath) as! StockViewCell
        cell.bind(stocks[indexPath.row], at: indexPath)
        return cell
    }
    
    private func fetchStocksData() {
        let fetchRequest: NSFetchRequest<StockDataModel> = StockDataModel.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "capitalization", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let fetchContext = appDelegate.persistentContainer.viewContext
        
        fetchStocksController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: fetchContext, sectionNameKeyPath: nil, cacheName: nil)
        
        do {
            try fetchStocksController.performFetch()
            updateStocksSnapshot()
        } catch {
            print("Fetch stocks error: \(error)")
        }
    }
    
    private func updateStocksSnapshot() {
        if let fetchedObjects = fetchStocksController.fetchedObjects {
            stocks = fetchedObjects
        }
        
        if stocks.isEmpty {
            setupInitialStocksCache()
            fetchStocksData()
        } else {
            stocksCollectionView.reloadData()
        }
    }
    
    private func setupInitialStocksCache() {
        let stocks: Array<Stock> = loadStocksFromJson() ?? []
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let stoskDataModel = stocks.map({ (stock: Stock) in
            stock.toManagedObject(in: appDelegate.persistentContainer.viewContext)
        }).filter({ stock in
            stock != nil
        })
        
        appDelegate.savePersistentContainerContext()
    }
    
    private func loadStocksFromJson() -> Array<Stock>? {
        let contentUrl = Bundle.main.url(forResource: "Stocks", withExtension: ".json")!
        
        do {
            let data = try Data(contentsOf: contentUrl)
            let jsonData = try JSONDecoder().decode(Array<Stock>.self, from: data)
            return jsonData
        } catch {
            print("Json reading error: \(error)")
        }
        return nil
    }
}

extension Stock {
    
    func toManagedObject(in context: NSManagedObjectContext) -> StockDataModel? {
        guard let entityName = StockDataModel.entity().name else {
            NSLog("Can't get entity name for StockDataModel")
            return nil
        }
        
        guard let entityDescription = NSEntityDescription.entity(forEntityName: entityName, in: context) else {
            NSLog("Can't create entity \(entityName)")
            return nil
        }
        
        let object: StockDataModel = StockDataModel.init(entity: entityDescription, insertInto: context)
        
        object.name = name
        object.symbol = symbol
        object.logoUrl = logoUrl
        object.country = country
        object.phone = phone
        object.webUrl = webUrl
        object.industry = industry
        object.currency = currency
        object.capitalization = Int64(capitalization) ?? 0
        return object
    }
}

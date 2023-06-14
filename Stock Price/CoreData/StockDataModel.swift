import CoreData

@objc(StockDataModel)
public class StockDataModel: NSManagedObject {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<StockDataModel> {
        return NSFetchRequest<StockDataModel>(entityName: "StockDataModel")
    }

    @NSManaged public var name: String
    @NSManaged public var symbol: String
    @NSManaged public var logoUrl: String
    @NSManaged public var country: String
    @NSManaged public var phone: String
    @NSManaged public var webUrl: String
    @NSManaged public var industry: String
    @NSManaged public var currency: String
    @NSManaged public var capitalization: Int64
}

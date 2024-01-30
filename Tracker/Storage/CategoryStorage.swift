import Foundation

final class CategoryStorage {
    // MARK: Singletone
    static let shared = CategoryStorage()
    private init() {}
    
    // MARK: Private enum
    private enum Keys: String, CodingKey {
        case caterory = "Caterory"
    }
    
    // MARK: Private properties
    private let userDefaults = UserDefaults.standard
    
    // MARK: Public properties

    var category: [String?] {
        get { userDefaults.stringArray(forKey: Keys.caterory.rawValue) ?? [String]() }
        set { userDefaults.set(newValue, forKey: Keys.caterory.rawValue) }
    }
}

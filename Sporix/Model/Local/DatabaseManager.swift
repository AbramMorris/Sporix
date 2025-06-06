import Foundation
import UIKit
import CoreData

class DatabaseManager {
    
    static let shared = DatabaseManager()
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    func saveFav(_ fav: Fav) {
        if isFavExist(id: fav.id) { return }
        
        let favEntity = FavEntity(context: context)
        favEntity.id = Int64(fav.id)
        favEntity.leagueName = fav.LeagueName
        favEntity.leagueImage = fav.LeagueImage
        favEntity.countryName = fav.countryName
        favEntity.sportType = fav.sportType
        saveContext()
    }
    
    func getAllFavs() -> [Fav] {
        let request: NSFetchRequest<FavEntity> = FavEntity.fetchRequest()
        do {
            let results = try context.fetch(request)
            return results.map {
                Fav(
                    id: Int($0.id),
                    LeagueName: $0.leagueName ?? "",
                    LeagueImage: $0.leagueImage,
                    countryName: $0.countryName ?? "",
                    sportType: $0.sportType ?? ""
                )
            }
        } catch {
            print("Failed to fetch favs: \(error)")
            return []
        }
    }
    
    func deleteFav(withId id: Int) {
        let request: NSFetchRequest<FavEntity> = FavEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %d", id)
        do {
            let results = try context.fetch(request)
            for obj in results {
                context.delete(obj)
            }
            saveContext()
        } catch {
            print("Delete error: \(error)")
        }
    }
    
    func isFavExist(id: Int) -> Bool {
        let request: NSFetchRequest<FavEntity> = FavEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %d", id)
        do {
            let count = try context.count(for: request)
            return count > 0
        } catch {
            print("Exist check error: \(error)")
            return false
        }
    }

    private func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print("Context save error: \(error)")
            }
        }
    }
}

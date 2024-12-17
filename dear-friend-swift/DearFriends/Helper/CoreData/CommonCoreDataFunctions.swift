//
//  ConnectionLogsCoreData.swift
//  ChillsQatarCustomer
//
//  Created by M1 Mac Mini 2 on 07/07/22.
//

import Foundation
import CoreData
import UIKit

enum CoreDataEntityType: String {
    case LocalDownloads = "LocalDownloads"
    case BackgroundDownloads = "BackgroundDownloads"
}

class CommonCDFunctions: NSObject  {
    
    static let arrayOfCoreDataEntityType = [CoreDataEntityType.LocalDownloads.rawValue]
    
    /// get contex
    class func getContext() -> NSManagedObjectContext {
        return appDelegate.persistentContainer.viewContext
    }
    
    // Singleton Instance
    static var shared: CommonCDFunctions = {
        var instance = CommonCDFunctions()
        // setup code
        return instance
    }()
    
    
    // MARK: - Remove all the data
    
    class func removeAllCoreEntities() {
        for entity in arrayOfCoreDataEntityType {
            self.removeOnebyOneEntities(entity: entity)
        }
    }
    
    class func removeOnebyOneEntities(entity: String) {
        
        let managedContext = self.getContext()
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        fetchRequest.returnsObjectsAsFaults = false
        do {
            if let results = try managedContext.fetch(fetchRequest) as? [NSManagedObject] {
                for result in results {
                    print("Deleting....",result)
                    managedContext.delete(result)
                }
                try managedContext.save()
                print("DELETED ALL Entities")
            }
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    class func getProductInfoFromData(with productID: String = "", completion: @escaping ([LocalDownloads], String?, Int) -> Void) {
        
        let managedContext = self.getContext()
        let fetchRequest = NSFetchRequest<LocalDownloads>(entityName: CoreDataEntityType.LocalDownloads.rawValue)
        fetchRequest.returnsObjectsAsFaults = false
        
        do {
            sleep(UInt32(0.2))
            
            var fetchedProdo: [NSManagedObject] = []
            fetchedProdo = try managedContext.fetch(fetchRequest)
            print("Fetching ProductInfoCore.",fetchedProdo)
            print("Total Fetched ",fetchedProdo.count)
            
            var finalData = fetchedProdo as? [LocalDownloads]
            if productID != "" {
                finalData = finalData?.filter({$0.music_id == productID})
            }
            
            let userid = "\(CurrentUser.shared.user?.internalIdentifier ?? 0)"
            finalData = finalData?.filter({$0.userid == userid})
            
            completion(finalData ?? [], "", fetchedProdo.count)
        }
        
        catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
            completion([],error.localizedDescription, 0)
        }
    }
    
    class func CheckandSavePrododuct(currentProduct: CommonAudioList, completion: @escaping (Bool, String?) -> Void) {
        
        self.checkCurrentData(currentProduct: "\(currentProduct.internalIdentifier ?? 0)") { response, error in
            if response.count == 0 {
                // Add whole new product
                self.saveMyProduct(currentProduct: currentProduct) { isSaved, errr in
                    self.getProductInfoFromData(with: "\(currentProduct.internalIdentifier ?? 0)") { myLocalData, error, count in
                        completion(isSaved, errr)
                    }
                }
            } else {
                completion(true, nil)
            }
        }
    }
    
    class func deleteProduct(currentProduct: LocalMusicModel, isFromCart: Bool = false, completion: @escaping (Bool, String?) -> Void) {
        let managedContext = self.getContext()
        let fetchRequest = NSFetchRequest<LocalDownloads>(entityName: CoreDataEntityType.LocalDownloads.rawValue)
        
        let productID = NSPredicate(format: "music_id = %@", "\(currentProduct.music_id)")
        fetchRequest.predicate = productID
        
        fetchRequest.returnsObjectsAsFaults = false
        let results = try? managedContext.fetch(fetchRequest)
        if let fetchedProd = results?.first {
            managedContext.delete(fetchedProd)
        }
        
        do {
            try managedContext.save()
            completion(true, nil)
        } catch {
            //Handle error
            completion(false, nil)
        }
    }
    
    class func saveMyProduct(currentProduct: CommonAudioList, completion: @escaping (Bool, String?) -> Void) {
        let managedContext = self.getContext()
        let entityLocalCart = NSEntityDescription.entity(forEntityName: "LocalDownloads", in: managedContext)
        let localCartData = LocalDownloads(entity: entityLocalCart!, insertInto: managedContext)
        
        localCartData.setValue("\(CurrentUser.shared.user?.internalIdentifier ?? 0)", forKey: "userid")
        localCartData.setValue(currentProduct.title ?? "", forKey: "music_title")
        localCartData.setValue("\(currentProduct.internalIdentifier ?? 0)", forKey: "music_id")
        localCartData.setValue("\(currentProduct.audioDuration ?? "")", forKey: "music_duration")
        localCartData.setValue("\(currentProduct.audioDuration ?? "")", forKey: "music_duration_secods")
        localCartData.setValue("\(currentProduct.female_audio_duration ?? "")", forKey: "female_music_duration_secods")
        localCartData.setValue(currentProduct.narratedBy ?? "", forKey: "narrated_by")
        localCartData.setValue(currentProduct.category?.title ?? "", forKey: "category")
        localCartData.setValue("\(currentProduct.categoryId ?? 0)", forKey: "category_id")
        localCartData.setValue(currentProduct.forSTr ?? "", forKey: "forStr")
        localCartData.setValue(currentProduct.is_background_audio ?? "", forKey: "is_background_audio")
        
        var arrBGAudios = [BackgroundsList]()
        if let backgroundAudios = currentProduct.backgrounds as? [BackgroundsList] {
            for bgAudio in backgroundAudios {
                arrBGAudios.append(bgAudio)
            }
        }

        localCartData.setValue(arrBGAudios as NSObject, forKey: "backgrounds")

        print("Storing Data..")
        
        do {
            try managedContext.save()
            print("Saved Music, \(currentProduct.internalIdentifier ?? 0)")
            completion(true, nil)
            
        } catch {
            print("Storing data Failed")
            completion(false, nil)
        }
    }
    
    class func updateMyProduct(music_id: String,
                               myData: Data,
                               key: String,
                               music_local_url: String,
                               key2: String,
                               isForCustom: Bool = false,
                               completion: @escaping (Bool, String?) -> Void) {
        
        let managedContext = self.getContext()
        let fetchRequest = NSFetchRequest<LocalDownloads>(entityName: CoreDataEntityType.LocalDownloads.rawValue)
        
        let productID = NSPredicate(format: "music_id = %@", music_id)
        fetchRequest.predicate = productID
        fetchRequest.returnsObjectsAsFaults = false
        
        do {
            let results = try? managedContext.fetch(fetchRequest)
            let fetchedProd = results?.first
            fetchedProd?.setValue(myData, forKey: key)
            fetchedProd?.setValue(music_local_url, forKey: key2)
            
            if isForCustom {
                fetchedProd?.setValue(true, forKey: "isForCustom")
            }
            
            try managedContext.save()
            
        } catch {
            print("Storing data Failed")
            completion(false, nil)
        }
        
        do {
            try managedContext.save()
            print("Updated, \(music_id)")
            
            self.getProductInfoFromData(with: "\(music_id)") { model, error, count in
                print("model, \(model)")
                completion(true, nil)
            }
            
        } catch {
            print("Storing data Failed")
            completion(false, nil)
        }
    }
    
    class func checkCurrentData(currentProduct: String, completion: @escaping ([LocalDownloads], String?) -> Void) {
        print("Fetching Data..")
        let managedContext = self.getContext()
        let request = NSFetchRequest<LocalDownloads>(entityName: CoreDataEntityType.LocalDownloads.rawValue)
        request.returnsObjectsAsFaults = false
        do {
            let result: [LocalDownloads] = try managedContext.fetch(request)
            let finalData = result.filter({$0.music_id == currentProduct})
            print("OLD Fethced, \(currentProduct) \(finalData.count)", finalData)
            completion(finalData, nil)

        } catch {
            print("Fetching data Failed")
            completion([], "Fetching data Failed")
        }
    }
}

// MARK: - Manage for background music

extension CommonCDFunctions {
    
    class func CheckandSaveBGMusic(currentProduct: BGAudioListModel, completion: @escaping (Bool, [BackgroundDownloads], String?) -> Void) {
        
        self.checkCurrentBG(currentProduct: currentProduct) { response, error in
            if response.count == 0 {
                // Add whole new product
                self.saveMyBGMusic(currentProduct: currentProduct) { isSaved, errr in
                    self.getBGInfoFromData(with: currentProduct.file ?? "") { myLocalData, error, count in
                        completion(isSaved, myLocalData, errr)
                    }
                }
            } else {
                completion(true, [], nil)
            }
        }
    }
    
    class func checkCurrentBG(currentProduct: BGAudioListModel, completion: @escaping ([BackgroundDownloads], String?) -> Void) {
        print("Fetching Data..")
        let managedContext = self.getContext()
        let request = NSFetchRequest<BackgroundDownloads>(entityName: CoreDataEntityType.BackgroundDownloads.rawValue)
        request.returnsObjectsAsFaults = false
        do {
            let result: [BackgroundDownloads] = try managedContext.fetch(request)
            
            let arrayOfURLs = result.compactMap({$0.file ?? ""}).map{ URL(string: $0)?.lastPathComponent }
            
            if let url2 = URL(string: currentProduct.file ?? "") {
                if let index = arrayOfURLs.firstIndex(where: {$0 == url2.lastPathComponent}) {
                    let finalData = [result[index]]
                    print("OLD Fethced, \(currentProduct) \(finalData.count)", finalData)
                    completion(finalData, nil)
                } else {
                    completion([], nil)
                }
            } else {
                completion([], nil)
            }

        } catch {
            print("Fetching data Failed")
            completion([], "Fetching data Failed")
        }
    }
    
    class func getBGInfoFromData(with productID: String = "", completion: @escaping ([BackgroundDownloads], String?, Int) -> Void) {
        
        let managedContext = self.getContext()
        let fetchRequest = NSFetchRequest<BackgroundDownloads>(entityName: CoreDataEntityType.BackgroundDownloads.rawValue)
        fetchRequest.returnsObjectsAsFaults = false
        
        do {
            sleep(UInt32(0.2))
            
            var fetchedProdo: [NSManagedObject] = []
            fetchedProdo = try managedContext.fetch(fetchRequest)
//            print("Fetching ProductInfoCore.",fetchedProdo)
//            print("Total Fetched ",fetchedProdo.count)
            
            var finalData = fetchedProdo as? [BackgroundDownloads]
            
            if productID != "" {
                finalData?.forEach { model in
                    if let url = URL(string: model.file ?? "") {
                        if let url2 = URL(string: productID) {
                            if url.lastPathComponent == url2.lastPathComponent {
                                let finalData = [model]
                                completion(finalData, "", fetchedProdo.count)
                            }
                        }
                    }
                }
            }
            
            completion(finalData ?? [], "", fetchedProdo.count)
        }
        
        catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
            completion([],error.localizedDescription, 0)
        }
    }
    
    class func saveMyBGMusic(currentProduct: BGAudioListModel, completion: @escaping (Bool, String?) -> Void) {
        let managedContext = self.getContext()
        let entityLocalCart = NSEntityDescription.entity(forEntityName: CoreDataEntityType.BackgroundDownloads.rawValue, in: managedContext)
        let localCartData = BackgroundDownloads(entity: entityLocalCart!, insertInto: managedContext)
        
        localCartData.setValue("\(currentProduct.internalIdentifier ?? 0)", forKey: "bg_id")
        localCartData.setValue(currentProduct.title ?? "", forKey: "title")
        localCartData.setValue(currentProduct.type ?? "", forKey: "type")
        localCartData.setValue(currentProduct.file ?? "", forKey: "file")
        
        print("Storing Data..")
        
        do {
            try managedContext.save()
            print("Saved Music, \(currentProduct.internalIdentifier ?? 0)")
            completion(true, nil)
            
        } catch {
            print("Storing data Failed")
            completion(false, nil)
        }
    }
}

struct LocalMusicModel {
    var userid: String = ""
    var music_title: String = ""
    var music_id: String = ""
    var music_duration: String = ""
    var music_duration_secods: String = ""
    var narrated_by: String = ""
    var category: String = ""
    var category_id: String = ""
    var music_local_url: String = ""
    var female_music_local_url: String = ""
    var forStr: String = ""
    var female_music_duration_secods: String = ""
    var music_file: Data?
    var female_file: Data?
    var music_image: Data?
    var is_background_audio: String = ""
    var isForCustom = 0
    var defaultBGMusic = [BackgroundsList]()
}

var kProduct_unique_id = "product_unique_id"
var kqty = "qty"

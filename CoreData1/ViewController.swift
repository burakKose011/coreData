//
//  ViewController.swift
//  CoreData1
//
//  Created by macbook on 13.11.2023.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // VERİ ÇEKMEK İÇİN
    var nameArray = [String]()
    var idArray = [UUID]()
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {  // kaç satır table view
        return nameArray.count // ne kadar veri eklersek o kadar olsun
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {  // satırlara erişim sağlar
        
        let cell = UITableViewCell()
        cell.textLabel?.text = nameArray[indexPath.row]
        return cell
    }



    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // burada table view e sağ üste + işareti koyduk
        
        navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.add, target: self, action: #selector(addItem))
        
        tableView.delegate = self     // table view için bunları yazmamız gerek
        tableView.dataSource = self  // table view için bunları yazmamız gerek
        
        getData()  // veri çekme fonsyonunu çağırıyoruz
    }
    
    
    // VERİ ÇEKMEK
    
    func getData() {
        
        self.nameArray.removeAll(keepingCapacity: true) // ikiz verileri 
        self.idArray.removeAll(keepingCapacity: true)
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate  // guard ekledik diye else ekledik
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Gallery")
        fetchRequest.returnsObjectsAsFaults = false // burada büyük data verilerinin de kullanılması halinde daha hızlı olur
        
        do{
            let results = try context.fetch(fetchRequest)
            for result in results as! [NSManagedObject] {
                
                if let name = result.value(forKey: "name") as? String {   // "name" coredata da kaydetmek istediğimiz yer
                    self.nameArray.append(name) // textfield a yazdığımız name bu
                }
                
                if let id = result.value(forKey: "id") as? UUID {
                    self.idArray.append(id)
                }
                
                self.tableView.reloadData() // tableView i yenile demek
            }
            
        } catch {
            
        }
    }
    
    
    
    
    
    
    
    
    
    
    @objc func addItem() {  // selectorün içinde ekledik burayı + ya tıkladığımda ne yapacağımı belirleriz
        
        performSegue(withIdentifier: "toSecondVC", sender: nil)
    }
    
 
}





// ilk başta coredata1 e geç sonra Add Entity e bas sonra dosya ya Gallery ismini verdik ,Attributes te + ya tıkla ve istediğini ekle ben year,place,name,image,id dosyası ekledim

// DOSYALAMA İÇİN APP DELEGATE ten de işlem yapıyoruz

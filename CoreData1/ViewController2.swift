//
//  ViewController2.swift
//  CoreData1
//
//  Created by macbook on 13.11.2023.
//

import UIKit
import CoreData

class ViewController2: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate { // delegate leri resim için seçtik

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var placeTextField: UITextField!
    @IBOutlet weak var yearTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        imageView.isUserInteractionEnabled = true // görseli tıklanabilir hale getirir
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTap)) // görsele tıklandığında götürmek için
        imageView.addGestureRecognizer(gestureRecognizer) // görselle recognizer ı bağladık
    }
    
    @objc func imageTap() {   // görsele tıklandığında ne yapacak
        
        let picker = UIImagePickerController() //
        picker.delegate = self
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {    // fotografa tıklanır hale getirdik sonra fotografı seçtik burada da fotoyu seçtikten sonra koymayı yaptık
        
        imageView.image = info[.originalImage] as? UIImage
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
    @IBAction func saveTiklandi(_ sender: Any) {
        
        // VERİ KAYDETME İŞLEMİ
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate  // appdelegate ulaştık bu satırla
        let context = appDelegate.persistentContainer.viewContext // app delegate içindeki saveContexte ulaştık bu satırla
        let saveData = NSEntityDescription.insertNewObject(forEntityName: "Gallery", into: context)  // kaydedeceğimiz data ları gösterecez bu satırla
                                                                                                     // "Gallery" AddEnity de oluşturduğumuz dosya ismi
        
        saveData.setValue(nameTextField.text!, forKey: "name") // ilk kısma kaydetmek istediğin seyi, ikinci kısma add enitydeki kaydettiğimiz dosya ismini
        saveData.setValue(placeTextField.text!, forKey: "place")
        
        if let year = Int(yearTextField.text!){  // eğer yılı sayi girerse bu satıra gir uygulamayı güvenli yapıyor
            saveData.setValue(year, forKey: "year")
        }
        
        let imagePress = imageView.image?.jpegData(compressionQuality: 0.5) // 0.5 ile resim kalitesini küçülttük
        saveData.setValue(imagePress, forKey: "image")
        saveData.setValue(UUID(), forKey: "id")
        
        do{                        // do tray catch kullanıcı internet gitse bile veriyi kaydedebilmek için
            try context.save()
            print("succes")
        } catch {
            print("error")
        }
        
        NotificationCenter.default.post(name: NSNotification.Name.init(rawValue: "newData"), object: nil)
        self.navigationController?.popViewController(animated: true)
    }
    
}

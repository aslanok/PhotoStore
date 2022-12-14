//
//  addPhotoViewController.swift
//  PhotoStore
//
//  Created by MacBook on 15.08.2022.
//

import UIKit
import CoreData

class addPhotoViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    @IBOutlet weak var buttonSave: UIButton!
    var pc = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var selectedItem : Entity? = nil
    
    @IBOutlet weak var txtTitle: UITextField!
    @IBOutlet weak var txtDescription: UITextField!
    @IBOutlet weak var imgPhoto: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if selectedItem == nil {
            //new photo will be added
            self.navigationItem.title = "Add a new photo"
        }else {
            //a photo will be edited
            self.navigationItem.title = selectedItem?.titletext
            txtTitle.text = selectedItem?.titletext
            txtDescription.text = selectedItem?.descriptiontext
            imgPhoto.image = UIImage(data: (selectedItem?.image as! Data))
            buttonSave.setTitle("Update", for: UIControl.State.normal)
            
        }
    }
    
    @IBAction func btnCameraClicked(_ sender: UIButton) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .camera
        picker.allowsEditing = true
        self.present(picker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imgPhoto.image = selectedImage
        }
        self.dismiss(animated: true)
    }
    
    
    @IBAction func btnGalleryClicked(_ sender: UIButton) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        self.present(picker, animated: true)
    }
    
    @IBAction func btnSaveClicked(_ sender: UIButton) {
        
        if selectedItem == nil {
            let entityDescription = NSEntityDescription.entity(forEntityName: "Entity", in: pc)
            let newItem = Entity(entity: entityDescription!, insertInto: pc)
            newItem.descriptiontext = txtDescription.text
            newItem.titletext = txtTitle.text
            newItem.image = imgPhoto.image!.jpegData(compressionQuality: 0.8) as NSData?
        }else {
            selectedItem?.descriptiontext = txtDescription.text
            selectedItem?.titletext = txtTitle.text
            selectedItem?.image = imgPhoto.image!.jpegData(compressionQuality: 0.8) as NSData?
        }
        do{
            if pc.hasChanges {
                try pc.save()
            }
        }catch{
            print(error)
            return
        }
        navigationController?.popViewController(animated: true)//bu sat??r sayesinde kullan??c?? kay??t i??leminden sonra anamen??ye d??necek
        
    }
    @IBAction func dissmisKeyboard(_ sender: UITextField) {
        print("it worked")
        self.resignFirstResponder()
    }
    
    
}

//
//  ViewController.swift
//  SeeFood
//
//  Created by Cátia Souza on 19/03/20.
//  Copyright © 2020 Cátia Souza. All rights reserved.
//

import UIKit
import CoreML
import Vision

class ViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    @IBOutlet weak var imageView: UIImageView!
    let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        //imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = false
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let userPicketImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
            
            imageView.image = userPicketImage
            guard let ciimage = CIImage(image: userPicketImage)else{
                fatalError("nao foi possivel converter a imagem")
            }
            detect(image: ciimage)
        }
        imagePicker.dismiss(animated: true, completion: nil)
    }
    func detect(image: CIImage){
        guard let model = try? VNCoreMLModel(for: Inceptionv3().model)else{
            fatalError("Falha no carregamento")
        }
        let request = VNCoreMLRequest(model: model) { (request, error) in
            guard let results = request.results as? [VNClassificationObservation]else{
                fatalError("Falha ao processar a imagem")
            }
            if let firstResults = results.first{
                if firstResults.identifier.contains("cat"){
                    self.navigationItem.title = "Sim, sou um gato! 😻"
                    
                }else{
                    self.navigationItem.title = "Not Hot Dog 😿"
                }
            }
        }
        let handler = VNImageRequestHandler(ciImage: image)
        do{
             try handler.perform([request])
        }
        catch{
            print(error)
        }
        
    }
    @IBAction func cameraTapeed(_ sender: UIBarButtonItem) {
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    
}


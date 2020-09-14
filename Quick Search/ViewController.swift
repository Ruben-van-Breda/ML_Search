//
// ViewController.swift
// SPVision
//
// Created by Ruben van Breda on 2020/09/03.
// Copyright © 2020 Ruben van Breda. All rights reserved.
//


import UIKit
import AVKit
import CoreML
import Vision


class ViewController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate, UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    @IBOutlet weak var debugText: UILabel!
    @IBOutlet weak var lbResults: UILabel!
    @IBOutlet weak var displayImage: UIImageView!
    
    public var model_to_use : MY_ML_Model = MY_ML_Model(name: "Resnet50",image: UIImage(named: "flower")!)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        print("LOADED MODEL \(model_to_use.name)")
        //Here we start up the camera
        
//        let captureSession = AVCaptureSession()
//        captureSession.sessionPreset = .photo
//
//        guard let captureDevice = AVCaptureDevice.default(for: .video) else {return}
//
//        guard let input = try? AVCaptureDeviceInput(device: captureDevice) else {return}
//        captureSession.addInput(input)
//        captureSession.startRunning()
//
//        DetectImage()
        
//        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
//        view.layer.addSublayer(previewLayer)
//        previewLayer.frame = view.frame
        
//
//        let dataOutput = AVCaptureVideoDataOutput()
//        dataOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "videoQueue"))
//        captureSession.addOutput(dataOutput) // monitor image frames
        
        
       
        
       
        // self.itemText.text = "\(itemString)"
        
    }
    
    //each frame that is capture
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        // print("Camera captured frame ", Date())
        guard let pixelBuffer : CVPixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {return}
        
        guard let model = try? self.GetModel() else {return}
        
        let request = VNCoreMLRequest(model: model)
        { (finshedReq, err) in
            
            guard let results = finshedReq.results as? [VNClassificationObservation] else {return}
            // guard let firstObservation = results.first else {return}
            guard var firstObservation = results.first else {return}
            
            var itemString = firstObservation.identifier.description
            DispatchQueue.main.async { // Correct
//                itemText.text = "\(self.itemString) item"
            }
            print(itemString, firstObservation.confidence)
            
        }
        
        try? VNImageRequestHandler(cvPixelBuffer: pixelBuffer,options: [:]).perform([request])
    }
    
    @IBAction func btnImagePicker(_ sender: Any) {
        
        self.debugText.text = "\(model_to_use.name)"
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        
        
        let alert = UIAlertController(title: "Photo Source", message: "Choose image source.", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (UIAlertAction) in
            imagePickerController.sourceType = .camera
            self.present(imagePickerController, animated: true, completion: {
               
            })
        }))
        alert.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { (UIAlertAction) in
            imagePickerController.sourceType = .photoLibrary
            self.present(imagePickerController, animated: true, completion:
            {})
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (UIAlertAction) in
            
        }))
        
        self.present(alert,animated: true,completion: {
             
        })
        
       
    }
    
    
    func DetectImage(){
        
        print("Used this model")
        print(self.model_to_use.name)
        
        guard var model = try? self.GetModel() else {return}
        model = self.GetModel()
        //  Create a vision resquest
        let request = VNCoreMLRequest(model: model) { (req, err) in
            guard let results = req.results as? [VNClassificationObservation], let topeResult = results.first
                else {fatalError("Unexpeted results.")}
            
            DispatchQueue.main.async {
            self.lbResults.text = "\(topeResult.identifier)"
                print(topeResult.identifier,topeResult.confidence)
            }
            
            let alert = UIAlertController(title: "\(topeResult.identifier)", message: "", preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction(title: "Read More", style: .default, handler: { (UIAlertAction) in
              self.LoadURL(search: topeResult.identifier)
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (UIAlertAction) in
                       
            }))
            self.present(alert,animated: true,completion: nil)
            
            
        }
//        if(self.displayImage.image != nil){
            guard let ciImage = CIImage(image: self.displayImage.image!) else{
                 
                fatalError("Image error: Cant create CIImage.")
            }
            
            //Run ml classifier
            let handler = VNImageRequestHandler(ciImage: ciImage)
            DispatchQueue.global().async {
                do {
                    try handler.perform([request])
                } catch {
                    print(error)
                }
            }
//        }
        
    }
    func GetModel() -> VNCoreMLModel{
        var model = try? VNCoreMLModel(for: Resnet50().model)
        switch model_to_use.name {
        case "Flowers":
            model = try? VNCoreMLModel(for: Flowers().model)
        case "Birds":
            model = try? VNCoreMLModel(for: Birds().model)
        case "Vehicle":
            model = try? VNCoreMLModel(for: Birds().model)
        case "Food":
            model = try? VNCoreMLModel(for: Food().model)
        default:
            model = try? VNCoreMLModel(for: Resnet50().model)
        }
        print("Switched to \(model?.description) model")
        
        return model!
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        displayImage.image = image
        self.DetectImage()
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func DetermineLabel(forImage: UIImage) -> String {
        return ""
    }
    
    func LoadURL(search: String){
        let searchText =  search.replacingOccurrences(of: " ", with: "+")
        guard let url = URL(string:"https://www.google.com.au/search?client=safari&channel=ipad_bm&source=hp&ei=PSrkWqHVDYrc8QXp85zoAw&q=\(searchText)&oq=example&gs_l=mobile-gws-wiz-hp.3..0l5.58620.59786..60164...0....334.1724.0j2j3j2..........1.......3..41j0i131.SurD5PmVspw%3D") else { return }
        UIApplication.shared.open(url)
        
//        let search = "Example”
//        if let url = URL(string: "https://www.google.com.au/search?client=safari&channel=ipad_bm&source=hp&ei=PSrkWqHVDYrc8QXp85zoAw&q=\(search)&oq=example&gs_l=mobile-gws-wiz-hp.3..0l5.58620.59786..60164...0....334.1724.0j2j3j2..........1.......3..41j0i131.SurD5PmVspw%3D"), NSWorkspace.shared.open(url) {
//                print("default browser was successfully opened")
//            }

    }
}


// Put this piece of code anywhere you like
extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}


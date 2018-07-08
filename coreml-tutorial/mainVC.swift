//
//  ViewController.swift
//  coreml-tutorial
//
//  Created by PEDRO LUIS AARON R on 7/7/18.
//  Copyright © 2018 paaron. All rights reserved.
//

import UIKit
import AVFoundation
import CoreML
import Vision

class mainVC: UIViewController,AVCapturePhotoCaptureDelegate {
    
    var captureSession:AVCaptureSession!
    var camOutput: AVCapturePhotoOutput!
    var prevLayer:AVCaptureVideoPreviewLayer!
    
    var photoData:Data?

    
    @IBOutlet weak var outputImageView: RndShadowImageView!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var confLabel: UILabel!
    @IBOutlet weak var descLabelView: RndShadowView!
    @IBOutlet weak var camView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        prevLayer.frame=camView.bounds
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let tap=UITapGestureRecognizer(target: self, action: #selector(onTApCamView))
        tap.numberOfTapsRequired = 1
        
        captureSession=AVCaptureSession()
        captureSession.sessionPreset=AVCaptureSession.Preset.hd1920x1080
        
        let bkCamera=AVCaptureDevice.default(for: AVMediaType.video)
        
        do{
            let input=try AVCaptureDeviceInput(device: bkCamera!)
            if captureSession.canAddInput(input)==true{
                captureSession.addInput(input)
            }
        
            camOutput=AVCapturePhotoOutput()
            if captureSession.canAddOutput(camOutput)==true{
                captureSession.addOutput(camOutput!)
                
                prevLayer=AVCaptureVideoPreviewLayer(session:captureSession!)
                prevLayer.videoGravity=AVLayerVideoGravity.resizeAspect
                prevLayer.connection?.videoOrientation=AVCaptureVideoOrientation.portrait
                
                camView.layer.addSublayer(prevLayer!)
                camView.addGestureRecognizer(tap)
                captureSession.startRunning()
                
            }
        }catch{
            debugPrint(error)
        }
        
        
        
    }
    
    func resMethod(request:VNRequest,error:Error?){
        guard let results=request.results as? [VNClassificationObservation] else {return}
        
        for classification in results{
            if classification.confidence<0.6{
                self.descLabel.text="Im am not sure what is it. Can you please try again?"
                self.confLabel.text=""
                break
            }else{
                self.descLabel.text=classification.identifier
                self.confLabel.text="I am \(classification.confidence*100)% confident!"
                break
                
            }
        }
        
    }
    
    
    @objc func onTApCamView(){
        let set = AVCapturePhotoSettings()
        set.previewPhotoFormat=set.embeddedThumbnailPhotoFormat
        camOutput.capturePhoto(with: set, delegate: self)
        
        
    }
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        if let error = error{
            debugPrint(error)
        }else {
            photoData=photo.fileDataRepresentation()
            do{
                let model=try VNCoreMLModel(for: SqueezeNet().model)
                let request=VNCoreMLRequest(model: model, completionHandler: resMethod)
                let handler=VNImageRequestHandler(data: photoData!)
                try handler.perform([request])
            }catch{
                debugPrint(error)
            }
            
            let image=UIImage(data: photoData!)
            self.outputImageView.image=image
        }
    }
    
}


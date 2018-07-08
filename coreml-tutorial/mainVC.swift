//
//  ViewController.swift
//  coreml-tutorial
//
//  Created by PEDRO LUIS AARON R on 7/7/18.
//  Copyright © 2018 paaron. All rights reserved.
//

import UIKit
import AVFoundation

class mainVC: UIViewController {
    
    var captureSession:AVCaptureSession!
    var camOutput: AVCaptureOutput!
    var prevLayer:AVCaptureVideoPreviewLayer!

    
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
                
            }
        }catch{
            debugPrint(error)
        }
        
    }
}


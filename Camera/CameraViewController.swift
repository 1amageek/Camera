//
//  CameraViewController.swift
//  Camera
//
//  Created by 1amageek on 2017/01/09.
//  Copyright © 2017年 Stamp inc. All rights reserved.
//

import UIKit
import AVFoundation
import Photos

class CameraViewController: UIViewController {
    
    lazy var camera: Camera = {
        let camera: Camera = Camera(previewView: self.previewView)
        return camera
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.view.addSubview(self.previewView)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        switch AVCaptureDevice.authorizationStatus(forMediaType: AVMediaTypeVideo) {
        case .authorized:
            // The user has previously granted access to the camera.
            break
            
        case .notDetermined:
            /*
             The user has not yet been presented with the option to grant
             video access. We suspend the session queue to delay session
             setup until the access request has completed.
             
             Note that audio access will be implicitly requested when we
             create an AVCaptureDeviceInput for audio during session setup.
             */
            self.camera.sessionQueue.suspend()
            AVCaptureDevice.requestAccess(forMediaType: AVMediaTypeVideo, completionHandler: { [unowned self] granted in
                if !granted {
                    self.camera.setupResult = .notAuthorized
                }
                self.camera.sessionQueue.resume()
            })
            
        default:
            // The user has previously denied access.
            self.camera.setupResult = .notAuthorized
        }
        
        self.camera.configure()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.camera.startSession()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.camera.stopSession()
    }
    
    lazy var previewView: Camera.PreviewView = {
        let view: Camera.PreviewView = Camera.PreviewView(frame: self.view.bounds)
        return view
    }()
    
}

//
//  StoryCameraViewController.swift
//  Instagram
//
//  Created by 堀田 有哉 on 2017/05/17.
//  Copyright © 2017年 堀田 有哉. All rights reserved.
//

import UIKit
import AVFoundation
import Photos
import lf
import VideoToolbox

class StoryCameraViewController: UIViewController {
    
    @IBOutlet weak var surroundingView: UIView!
    @IBOutlet weak var coreView: UILabel!
    @IBOutlet weak var thunderImageView: UIImageView!
    @IBOutlet weak var inverseImageView: UIImageView!
    @IBOutlet weak var statusNormalLabel: UILabel!
    @IBOutlet weak var statusLiveLabel: UILabel!
    @IBOutlet weak var selectionImageView: UIImageView!
    @IBOutlet weak var statusView: UIView!
    @IBOutlet weak var coreWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var liveTitleLabel: UILabel!
    @IBOutlet weak var liveSubTitleLabel: UILabel!
    @IBOutlet weak var thunderGapConstraint: NSLayoutConstraint!
    @IBOutlet weak var inverseGapConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var coreViewWidthNormalConstraint: NSLayoutConstraint!
    @IBOutlet weak var coreViewWidthLiveConstraint: NSLayoutConstraint!
    @IBOutlet weak var normalStatusCenterConstraint: NSLayoutConstraint!
    @IBOutlet weak var liveStatusCenterConstraint: NSLayoutConstraint!
    
    private var captureSession: AVCaptureSession!
    private var stillImageOutput: AVCapturePhotoOutput?
    private var videoOutput: AVCaptureMovieFileOutput?
    private var previewLayer: AVCaptureVideoPreviewLayer?
    private var cameraView: UIView?
    fileprivate var timer: Timer?
    fileprivate var timerSecond: Int?
    fileprivate var lfView: LFView?
    fileprivate var livePath: String?
    fileprivate var liveKey: String?
    
    var rtmpConnection: RTMPConnection?
    var rtmpStream: RTMPStream?
    var LIVE: Bool = false
    
    fileprivate var viewModel: StoryCameraViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureStatusInteraction()
        configureNormalInteraction()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        //self.view.layoutSubviews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("nanika kaku in viewWillDisappear")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func configureUI() {
        self.view.layoutIfNeeded()
        liveTitleLabel.isHidden = true
        liveSubTitleLabel.isHidden = true
        coreView.translatesAutoresizingMaskIntoConstraints = false
        
        surroundingView.layer.cornerRadius = surroundingView.frame.width / 2.0
        surroundingView.clipsToBounds = true
        coreView.layer.cornerRadius = coreView.frame.width / 2.0
        coreView.clipsToBounds = true
        
        thunderImageView.layer.cornerRadius = thunderImageView.frame.width / 2.0
        thunderImageView.clipsToBounds = true
        
        viewModel = StoryCameraViewModel(
            screenWidth: self.view.frame.width,
            coreWidth: self.coreView.frame.width,
            currentGap: self.thunderGapConstraint.constant
        )
        print(thunderGapConstraint.constant)
    }
    
    private func configureStatusInteraction() {
        let statusTapGesture = UITapGestureRecognizer()
        statusTapGesture.numberOfTapsRequired = 1
        statusTapGesture.addTarget(self, action: #selector(statusChange))
        
        statusView.addGestureRecognizer(statusTapGesture)
    }

    private func configureNormalInteraction() {
        let longPressGesture = UILongPressGestureRecognizer()
        longPressGesture.minimumPressDuration = 0.3
        longPressGesture.addTarget(self, action: #selector(takeMovie))
        
        let tapGesture = UITapGestureRecognizer()
        tapGesture.numberOfTapsRequired = 1
        tapGesture.addTarget(self, action: #selector(takeImage))
        
        coreView.isUserInteractionEnabled = true
        coreView.addGestureRecognizer(longPressGesture)
        coreView.addGestureRecognizer(tapGesture)
    }
    
    private func configureLiveInteraction() {
        let tapGesture = UITapGestureRecognizer()
        tapGesture.numberOfTapsRequired = 1
        tapGesture.addTarget(self, action: #selector(startLive))
        
        coreView.isUserInteractionEnabled = true
        coreView.addGestureRecognizer(tapGesture)
    }
    
    func statusChange() {
        if viewModel?.getCurrentStatus() == .normal {
            for gesture in coreView.gestureRecognizers! {
                coreView.removeGestureRecognizer(gesture)
            }
            configureLiveInteraction()
            liveTitleLabel.isHidden = false
            liveSubTitleLabel.isHidden = false
            liveSubTitleLabel.text = viewModel?.live?.subTitleText
            UIView.animate(withDuration: 0.4, animations: {
                self.coreView.text = self.viewModel?.live?.buttonText
                self.normalStatusCenterConstraint.isActive = false
                self.liveStatusCenterConstraint.isActive = true
                self.coreViewWidthNormalConstraint.isActive = false
                self.coreViewWidthLiveConstraint.isActive = true
                self.thunderGapConstraint.constant = 10
                self.inverseGapConstraint.constant = 10
                self.surroundingView.isHidden = true
                self.view.layoutIfNeeded()
            })
        } else if viewModel?.getCurrentStatus() == .live {
            for gesture in coreView.gestureRecognizers! {
                coreView.removeGestureRecognizer(gesture)
            }
            configureNormalInteraction()
            liveTitleLabel.isHidden = true
            liveSubTitleLabel.isHidden = true
            UIView.animate(withDuration: 0.4, animations: {
                self.liveStatusCenterConstraint.isActive = false
                self.normalStatusCenterConstraint.isActive = true
                self.coreViewWidthLiveConstraint.isActive = false
                self.coreViewWidthNormalConstraint.isActive = true
                self.thunderGapConstraint.constant = 58.5
                self.inverseGapConstraint.constant = 58.5
                self.surroundingView.isHidden = false
                self.view.layoutIfNeeded()
            }, completion: { _ in
                self.coreView.text = self.viewModel?.normal?.buttonText
            })
        }
        
        viewModel?.changeStatus()
        //configureRTMP()
    }
    
    func configureCamera() {
        captureSession = AVCaptureSession()
        stillImageOutput = AVCapturePhotoOutput()
        videoOutput = AVCaptureMovieFileOutput()
        captureSession.sessionPreset = AVCaptureSessionPreset1920x1080//AVCaptureSessionPreset1280x720
        
        let device = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
        
        
        do {
            let input = try AVCaptureDeviceInput(device: device)
            
            if captureSession.canAddInput(input) {
                captureSession.addInput(input)
                
                if captureSession.canAddOutput(stillImageOutput) && captureSession.canAddOutput(videoOutput) {
                    captureSession.addOutput(stillImageOutput)
                    captureSession.addOutput(videoOutput)
                    captureSession.startRunning()
                    
                    previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
                    previewLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
                    previewLayer?.connection.videoOrientation = .portrait
                    previewLayer?.frame = UIScreen.main.bounds
                    
                    self.view.layer.addSublayer(previewLayer!)
                    surroundingView.layer.zPosition = 1.0
                    coreView.layer.zPosition = 2.0
                    thunderImageView.layer.zPosition = 1.0
                    inverseImageView.layer.zPosition = 1.0
                    statusNormalLabel.layer.zPosition = 1.0
                    statusLiveLabel.layer.zPosition = 1.0
                    selectionImageView.layer.zPosition = 1.0
                    statusView.layer.zPosition = 2.0
                    liveTitleLabel.layer.zPosition = 1.0
                    liveSubTitleLabel.layer.zPosition = 1.0
                }
            }
        } catch {
            print(error)
        }
    }
    
    func takeMovie(_ sender: UILongPressGestureRecognizer) {
        if sender.state == UIGestureRecognizerState.began {
            let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
            let documentsDirectory = paths[0]
            let filePath = "\(documentsDirectory)/test.mov"
            let fileURL = URL(fileURLWithPath: filePath)
            videoOutput?.startRecording(toOutputFileURL: fileURL, recordingDelegate: self)
            
            UIView.animate(withDuration: 0.5, animations: { _ in
                self.coreView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
                self.surroundingView.transform = CGAffineTransform(scaleX: 1.4, y: 1.4)
            })
        }
        if sender.state == UIGestureRecognizerState.ended {
            videoOutput?.stopRecording()
            UIView.animate(withDuration: 0.5, animations: { _ in
                self.coreView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                self.surroundingView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            })
        }
    }
    
    func takeImage() {
        let settingForMinitoring = AVCapturePhotoSettings()
        settingForMinitoring.isAutoStillImageStabilizationEnabled = true
        settingForMinitoring.isHighResolutionPhotoEnabled = false
        stillImageOutput?.capturePhoto(with: settingForMinitoring, delegate: self)
    }
}

extension StoryCameraViewController {
    func startLive(_ sender: UITapGestureRecognizer) {
        if !LIVE {
            LIVE = true
            coreView.isUserInteractionEnabled = false
            UIView.animate(withDuration: 0.3, animations: { [unowned self] _ in
                self.coreView.text = "配信中"
            })
            timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(countDown), userInfo: nil, repeats: true)
            timerSecond = 3
            
            liveTitleLabel.text = String(timerSecond!)
            liveSubTitleLabel.isHidden = true
            
            viewModel?.prepareForLive()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                self.configureRTMP()
            }

        } else {
            LIVE = false
            UIView.animate(withDuration: 0.3, animations: { _ in
                self.coreView.text = "ライブ動画を開始"
            })
            finishLive()
        }
    }
    
    func finishLive() {
        rtmpConnection?.close()
        rtmpStream?.close()
        lfView?.removeFromSuperview()
        lfView = nil
        
        DispatchQueue.main.async {
            self.configureCamera()
        }
    }
    
    func countDown() {
        timerSecond! -= 1
        liveTitleLabel.text = String(timerSecond!)
        if timerSecond! <= 0 {
            timer?.invalidate()
            liveTitleLabel.text = ""
        }
    }
    
    func configureRTMP() {
        coreView.isUserInteractionEnabled = true
        rtmpConnection = RTMPConnection()
        rtmpStream = RTMPStream(connection: rtmpConnection!)
        
        
        rtmpStream?.captureSettings = [
            "fps": 30,
            "sessionPreset": AVCaptureSessionPreset1920x1080
        ]
        
        rtmpStream?.videoSettings = [
            "width": UIScreen.main.bounds.width,
            "height": UIScreen.main.bounds.height,
            "bitrate": 640 * 1024,
            "profileLevel": kVTProfileLevel_H264_High_5_2
        ]
        
        print(rtmpStream?.videoSettings)
        
        rtmpStream?.attachAudio(AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeAudio)) { error in
            print("In attachAudio")
            print(error)
        }
        rtmpStream?.attachCamera(DeviceUtil.device(withPosition: .back)) { error in
            print("In attachCamera")
            print(error)
        }
        
        lfView = LFView(frame: (self.view.window?.frame)!)
        lfView?.videoGravity = AVLayerVideoGravityResizeAspectFill
        lfView?.attachStream(rtmpStream)
        let tapGesture = UITapGestureRecognizer()
        tapGesture.numberOfTapsRequired = 1
        tapGesture.addTarget(self, action: #selector(startLive))
        lfView?.addGestureRecognizer(tapGesture)
        self.view.addSubview(lfView!)
        
        
        
        /*
        let qos = DispatchQoS.QoSClass.background
        DispatchQueue.global(qos: qos).async {
            //self.rtmpConnection?.connect("rtmp://35.187.220.27/live")
            //self.rtmpStream?.publish("Story")
            self.rtmpConnection?.connect((self.viewModel?.path.value)!)
            self.rtmpStream?.publish(self.viewModel?.key.value)
        }*/
        
        DispatchQueue.main.async {
            self.rtmpConnection?.connect((self.viewModel?.path.value)!)
            self.rtmpStream?.publish(self.viewModel?.key.value)
        }
    }
    
}

extension StoryCameraViewController: AVCapturePhotoCaptureDelegate {
    func capture(_ captureOutput: AVCapturePhotoOutput, didFinishProcessingPhotoSampleBuffer photoSampleBuffer: CMSampleBuffer?, previewPhotoSampleBuffer: CMSampleBuffer?, resolvedSettings: AVCaptureResolvedPhotoSettings, bracketSettings: AVCaptureBracketedStillImageSettings?, error: Error?) {
        
        if let photoSampleBuffer = photoSampleBuffer {
            let photoData = AVCapturePhotoOutput.jpegPhotoDataRepresentation(forJPEGSampleBuffer: photoSampleBuffer, previewPhotoSampleBuffer: previewPhotoSampleBuffer)
            let image = UIImage(data: photoData!)
            
            UIImageWriteToSavedPhotosAlbum(image!, nil, nil, nil)
            
            
            let adobeViewController = AdobeUXImageEditorViewController(image: image!)
            adobeViewController.delegate = self
            self.present(adobeViewController, animated: true, completion:  nil)
        }
    }
}

extension StoryCameraViewController: AVCaptureFileOutputRecordingDelegate {
    func capture(_ captureOutput: AVCaptureFileOutput!, didStartRecordingToOutputFileAt fileURL: URL!, fromConnections connections: [Any]!) {
        print("recording")
    }
    
    func capture(_ captureOutput: AVCaptureFileOutput!, didFinishRecordingToOutputFileAt outputFileURL: URL!, fromConnections connections: [Any]!, error: Error!) {
        print("finish")
        PHPhotoLibrary.shared().performChanges({
            PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: outputFileURL!)
        }, completionHandler: {completed, error in
            if completed {
                print("saved")
            }
        })
        
        let vc = PostingStoryVideoViewController.instantiate()
        vc.videoURL = outputFileURL
        self.present(vc, animated: true, completion: nil)
    }
    
}

extension StoryCameraViewController: AdobeUXImageEditorViewControllerDelegate {
    func photoEditor(_ editor: AdobeUXImageEditorViewController, finishedWith image: UIImage?) {
        editor.dismiss(animated: true, completion: nil)
        
        let storyboard = UIStoryboard(name: "PostingStoryImageViewController", bundle: nil)
        let vc = storyboard.instantiateInitialViewController() as! PostingStoryImageViewController
        
        vc.postingStoryImage = image!
        
        self.present(vc, animated: true, completion:  nil)
    }
    
    
    // AdobeImageEditorで加工をキャンセルしたときに呼ばれる
    func photoEditorCanceled(_ editor: AdobeUXImageEditorViewController) {
        editor.dismiss(animated: true, completion: nil)
    }

}

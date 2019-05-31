//
//  ZJAddAptFooterView.swift
//  BMLF
//
//  Created by zijia on 5/18/19.
//  Copyright © 2019 BMLF. All rights reserved.
//

import UIKit
import YPImagePicker
import AVFoundation
import AVKit
import Photos


private let imagesPadding: CGFloat = 10
private let imageBackGroundViewPadding: CGFloat = 10
private let imagesWidth: CGFloat = (zjScreenWidth - 2*imageBackGroundViewPadding - 4*imagesPadding)/5
private let imageBackGroundViewHeight = (zjScreenWidth-imageBackGroundViewPadding*2-imagesPadding*4)/5 * (zjScreenHeight/zjScreenWidth)

/*
class PhotoImageView: UIImageView{
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        self.layer.cornerRadius = 8
        self.layer.masksToBounds = true
        self.layer.borderWidth = 2
        self.layer.borderColor = UIColor.orange.cgColor
    }
}
 */
//用户选择的上传图片
var selectedItems = [YPMediaItem]()

class ZJAddAptFooterView: UIView {
    
    
    let selectedImageV = UIImageView()
    
    var imageV0: UIImageView = {
        let im = UIImageView(frame: CGRect(x: 0*(imagesWidth+imagesPadding), y: 0, width: imagesWidth, height: imageBackGroundViewHeight))
        im.layer.cornerRadius = 8
        im.layer.masksToBounds = true
        im.layer.borderWidth = 2
        im.layer.borderColor = UIColor.orange.cgColor
        return im
    }()
    var imageV1: UIImageView = {
        let im = UIImageView(frame: CGRect(x: 1*(imagesWidth+imagesPadding), y: 0, width: imagesWidth, height: imageBackGroundViewHeight))
        im.layer.cornerRadius = 8
        im.layer.masksToBounds = true
        im.layer.borderWidth = 2
        im.layer.borderColor = UIColor.orange.cgColor
        return im
    }()
    var imageV2: UIImageView = {
        let im = UIImageView(frame: CGRect(x: 2*(imagesWidth+imagesPadding), y: 0, width: imagesWidth, height: imageBackGroundViewHeight))
        im.layer.cornerRadius = 8
        im.layer.masksToBounds = true
        im.layer.borderWidth = 2
        im.layer.borderColor = UIColor.orange.cgColor
        return im
    }()
    var imageV3: UIImageView = {
        let im = UIImageView(frame: CGRect(x: 3*(imagesWidth+imagesPadding), y: 0, width: imagesWidth, height: imageBackGroundViewHeight))
        im.layer.cornerRadius = 8
        im.layer.masksToBounds = true
        im.layer.borderWidth = 2
        im.layer.borderColor = UIColor.orange.cgColor
        return im
    }()
    
    var imageV4: UIImageView = {
        let im = UIImageView(frame: CGRect(x: 4*(imagesWidth+imagesPadding), y: 0, width: imagesWidth, height: imageBackGroundViewHeight))
        im.layer.cornerRadius = 8
        im.layer.masksToBounds = true
        im.layer.borderWidth = 2
        im.layer.borderColor = UIColor.orange.cgColor
        return im
    }()
   
    
    fileprivate lazy var imageBackGroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .red
        return view
    }()
    
    fileprivate lazy var resultsButton: UIButton = {
       let b = UIButton()
        b.setTitle("show images", for: .normal)
        b.setTitleColor(.black, for: .normal)
        b.addTarget(self, action: #selector(showResults), for: .touchUpInside)
        return b
    }()
    
    let pickButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "plus_photo")!.withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handlePlusPhoto), for: .touchUpInside)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(pickButton)
        pickButton.anchor(top: self.topAnchor, left: leftAnchor, bottom: nil, right: nil, paddingTop: 10, paddingLeft: 10, paddingBottom: 0, paddingRight: 0, width: 50, height: 50)
        
//        let imagesArr = [imageV0, imageV1, imageV2, imageV3, imageV4]
//        for (index, image) in imagesArr.enumerated(){
//            image = UIImageView(frame: CGRect(x: CGFloat(index)*(imagesWidth+imagesPadding), y: 0, width: imagesWidth, height: self.imageBackGroundView.frame.size.height)) as! PhotoImageView
//            imageBackGroundView.addSubview(image)
//        }
        imageBackGroundView.addSubview(imageV0)
        imageBackGroundView.addSubview(imageV1)
        imageBackGroundView.addSubview(imageV2)
        imageBackGroundView.addSubview(imageV3)
        imageBackGroundView.addSubview(imageV4)
        ZJPrint(selectedItems.count)
        setupImages(images: selectedItems)
        
        
        //第二个20位图片padding 10*4
        
        self.addSubview(imageBackGroundView)
        imageBackGroundView.anchor(top: pickButton.bottomAnchor, left: self.leftAnchor, bottom: nil, right: self.rightAnchor, paddingTop: imageBackGroundViewPadding, paddingLeft: imageBackGroundViewPadding, paddingBottom: 0, paddingRight: imageBackGroundViewPadding, width: 0, height: imageBackGroundViewHeight)
        
        self.addSubview(resultsButton)
        resultsButton.anchor(top: nil, left: pickButton.rightAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 20, width: 200, height: 30)
        resultsButton.centerYAnchor.constraint(equalTo: pickButton.centerYAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


extension ZJAddAptFooterView{
    @objc fileprivate func handlePlusPhoto() {
        
        var config = YPImagePickerConfiguration()
        config.library.mediaType = .photoAndVideo
        config.shouldSaveNewPicturesToAlbum = false
        config.video.compression = AVAssetExportPresetMediumQuality
        config.startOnScreen = .library
        config.screens = [.library, .photo, .video]
        config.video.libraryTimeLimit = 500.0
//        config.showsCrop = .rectangle(ratio: (16/9))
        config.wordings.libraryTitle = "Gallery"
        config.hidesStatusBar = false
        config.hidesBottomBar = false
        
        config.library.maxNumberOfItems = 5
        let picker = YPImagePicker(configuration: config)
        picker.didFinishPicking { [unowned picker] items, cancelled in
            
            if cancelled {
                print("Picker was canceled")
                picker.dismiss(animated: true, completion: nil)
                return
            }
            _ = items.map { print("🧀 \($0)") }
            
            selectedItems = items
            if let firstItem = items.first {
                switch firstItem {
                case .photo(let photo):
//                    self.selectedImageV.image = photo.image
                    self.setupImages(images: selectedItems)
                    picker.dismiss(animated: true, completion: nil)
                case .video(let video):
                    self.selectedImageV.image = video.thumbnail
                    
                    let assetURL = video.url
                    let playerVC = AVPlayerViewController()
                    let player = AVPlayer(playerItem: AVPlayerItem(url:assetURL))
                    playerVC.player = player
                    
                    picker.dismiss(animated: true, completion: { [weak self] in
                        if let vc = UIApplication.topViewController(){
                            vc.present(picker, animated: true, completion: nil)
                        }
                        print("😀 \(String(describing: self?.resolutionForLocalVideo(url: assetURL)!))")
                    })
                }
            }
        }
        if let vc = UIApplication.topViewController(){
            vc.present(picker, animated: true, completion: nil)
        }
        
    }
    
    func setupImages(images: [YPMediaItem]){
        for (index, image) in images.enumerated(){
            let imagesArr = [imageV0, imageV1, imageV2, imageV3, imageV4]
            switch image{
            case .photo(p: let photo):
                imagesArr[index].image = photo.image
            case .video(let video): break
            }
        }
    }
    
    func resolutionForLocalVideo(url: URL) -> CGSize? {
        guard let track = AVURLAsset(url: url).tracks(withMediaType: AVMediaType.video).first else { return nil }
        let size = track.naturalSize.applying(track.preferredTransform)
        return CGSize(width: abs(size.width), height: abs(size.height))
    }
    
    @objc
    func showResults() {
        if selectedItems.count > 0 {
            let gallery = YPSelectionsGalleryVC(items: selectedItems) { g, _ in
                g.dismiss(animated: true, completion: nil)
            }
            let navC = UINavigationController(rootViewController: gallery)
            if let vc = UIApplication.topViewController(){
                vc.present(navC, animated: true, completion: nil)
            }
            
        } else {
            print("No items selected yet.")
        }
    }
}

//
//  ISImageViewerDemo.swift
//  ISImageViewer
//
//  Created by VSquare on 17/12/2015.
//  Copyright © 2015 IgorSokolovsky. All rights reserved.
//

import UIKit

class ISImageViewerDemo: UIViewController,ISImageViewerDelegate {
    

    var imageView:UIImageView?
    var image:UIImage = UIImage(named: "ogame_space.jpg")!
    var ivvc:ISImageViewer!
    var label:UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
       
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        //self.edgesForExtendedLayout = .None
        setUpImageView()
        print(image.size)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        
        
        let labelWidth = label.frame.size.width
        let labelHeight = label.frame.size.height
        
        let labelWidthRatio = self.view.frame.width / labelWidth
        let labelHeightRatio =   self.view.frame.height / labelHeight
        
        let labelxPosRatio = self.view.frame.width / label.frame.origin.x
        let labelyPosRatio = self.view.frame.height / label.frame.origin.y
        
        let labelNewWidth = size.width / labelWidthRatio
        let labelNewHeight = size.height / labelHeightRatio
        let labelNewXPos = size.width / labelxPosRatio
        let labelNewYPos = size.height / labelyPosRatio
        
        label.frame = CGRectMake(labelNewXPos, labelNewYPos, labelNewWidth, labelNewHeight)
        
        if imageView != nil {
            let imageViewWidth = imageView!.frame.size.width
            let imageViewHeight = imageView!.frame.size.height
            
            let imageViewWidthRatio = self.view.frame.width / imageViewWidth
            let imageViewHeightRatio =   self.view.frame.height / imageViewHeight
            
            let imageViewxPosRatio = self.view.frame.width / imageView!.frame.origin.x
            let imageViewyPosRatio = self.view.frame.height / imageView!.frame.origin.y
            
            let imageViewNewWidth = size.width / imageViewWidthRatio
            let imageViewNewHeight = size.height / imageViewHeightRatio
            let imageViewNewXPos = size.width /  imageViewxPosRatio
            let imageViewNewYPos = size.height / imageViewyPosRatio
            
            
            var cornerRadiusRatio:CGFloat
            var newCornerRadius:CGFloat
            if imageView!.layer.cornerRadius > 0{
                
                if UIDevice.currentDevice().orientation.isLandscape{
                    cornerRadiusRatio = imageViewWidth / imageView!.layer.cornerRadius
                    newCornerRadius = imageViewNewHeight / cornerRadiusRatio
                }else{
                    cornerRadiusRatio = imageViewHeight / imageView!.layer.cornerRadius
                    newCornerRadius = imageViewNewWidth / cornerRadiusRatio
                }

            }else{
                newCornerRadius = 0.0
            }
            
            
            imageView!.frame = CGRectMake(imageViewNewXPos, imageViewNewYPos, imageViewNewWidth, imageViewNewHeight)
            imageView?.contentMode = .ScaleAspectFit
            imageView?.layer.cornerRadius = newCornerRadius
        }
        
        self.view.frame = CGRectMake(0, 0, size.width, size.height)
        
        ivvc?.rotationHandling(size)
        
        if UIDevice.currentDevice().orientation.isLandscape{

            UIApplication.sharedApplication().statusBarHidden = true
            UIApplication.sharedApplication().statusBarHidden = false
        }
    }
    
    func setUpImageView(){
        imageView = UIImageView(image: image)
        
        if UIDevice.currentDevice().orientation.isLandscape{
            label = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.frame.width/3, height: self.view.frame.height/2))
            imageView?.frame = CGRectMake(0, 0, self.view.bounds.height/2, self.view.bounds.height/2)
        }else{
            label = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.frame.width/2, height: self.view.frame.width/4))
            imageView?.frame = CGRectMake(0, 0, self.view.bounds.width/2, self.view.bounds.width/2)
        }
        
        label.text = "Tap On The Image To Open The ImageViewer"
        label.numberOfLines = 2
        label.lineBreakMode = .ByWordWrapping
        label.textAlignment = .Center
        label.center = CGPoint(x: self.view.center.x, y: self.view.frame.height/4)
        label.font = UIFont.systemFontOfSize(17)
        self.view.addSubview(label)
        
        let gesture = UITapGestureRecognizer(target: self, action: "oneTapGestureReconizer:")
        gesture.numberOfTapsRequired = 1
        gesture.enabled = true

        imageView?.center = self.view.center
        imageView?.contentMode = .ScaleAspectFit
        imageView?.userInteractionEnabled = true
        imageView?.addGestureRecognizer(gesture)
        imageView?.layer.cornerRadius = (imageView?.frame.width)!/2
        imageView?.layer.masksToBounds = true
        self.view.addSubview(imageView!)
    }


    func oneTapGestureReconizer(sender:UITapGestureRecognizer){
        print("Image View Was Tapped")
        ivvc = ISImageViewer(imageView: self.imageView!)
        ivvc.setNavigationBar(nil, navBarTitle: "ImageViewer", rightNavBarItemTitle: "Edit")
        ivvc.prepareViewToBeLoaded(self)
    }
    
    func didPickNewImage(image: UIImage) {
        
    }
}


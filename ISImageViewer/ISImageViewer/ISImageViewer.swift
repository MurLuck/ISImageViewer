//
//  ISImageViewer.swift
//  ISImageViewer
//
//  Created by VSquare on 17/12/2015.
//  Copyright © 2015 IgorSokolovsky. All rights reserved.
//

import Foundation
import UIKit
import MobileCoreServices

class ISImageViewer:UIViewController,UIScrollViewDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate{
    
    //------------------------------------------------------------    Class Variabls    --------------------------------------------------------------//
    
    private var backGroundColor:UIColor?
    
    //the image view that was tapped to call this class.
    private let parentImageView:UIImageView
    
    //the image view inside scrollView that holds the image.
    private var imageView:UIImageView!
    
    //the scroll view that allows us to zoom on the imageView.
    private var scrollView:UIScrollView!
    
    //imageViewer toolbar for share ,print and so one default is nil.
    private var toolBar:UIToolbar?
    
    //imageViewer navigationBar , default have only X as dismiss view.
    private var navBar:UINavigationBar?
    
    //the background color after tap (navigationBar Hidden), default is black.
    private var backGroundColorDimmMode:UIColor?
    
    //the background color when navigation bar visible ,default is white.
    private var backGroundColorLightMode:UIColor?
    
    //the panGesture(moving the image )
    private var panGestureRecognizer:UIPanGestureRecognizer!
    
    //delegate for handling new image from imagePicker
    var imageViewerDelegate:ISImageViewerDelegate?
    
    //------------------------------------------------------    UIViewController Functions    --------------------------------------------------------//
    
    init(imageView:UIImageView){
        self.parentImageView = imageView
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.edgesForExtendedLayout = .All
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        self.view.superview?.bringSubviewToFront(self.view)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //------------------------------------------------------------    Class Functions    -------------------------------------------------------------//
    
    /*!
    prepares the view to be loaded sets up all the necessary subViews
    */
    func prepareViewToBeLoaded(parentView:UIViewController){
        parentView.navigationController?.navigationBar.hidden = true
        parentView.tabBarController?.tabBar.hidden = true
        self.view.alpha = 1
        self.view.frame = parentView.view.bounds
        self.view.backgroundColor = UIColor.whiteColor()
        parentView.view.addSubview(self.view)
        parentView.addChildViewController(self)
        
        self.view.addSubview(setScrollView())

        if navBar == nil{
            setNavigationBar(nil, navBarTitle: nil, rightNavBarItemTitle: nil)
        }
        
        setToolBar(setToolBar: false, toolBarItems: nil)
        
        self.view.bringSubviewToFront(navBar!)
        
        if toolBar != nil{
            self.view.bringSubviewToFront(toolBar!)
        }
        centerImageViewAnimationOnload()
    }
    
    /**
    sets up the navigation bar at the top of the imageViewer view
    
    - Parameter leftNavBarItemTitle:your custom left toolBar button Image. dismis the imageViewer. if nil , the image will be shown is X.
    - parameter navBarTitle:the title of the navigationBar, if nil , no title will be shown.
    - parameter rightNavBarItemTitle:the right toolBar button Title. Open ActionSheet. if nil , there wont be right button!
    */
    func setNavigationBar(leftNavBarItemImage:UIImage?,navBarTitle:String?,rightNavBarItemTitle:String?){
        if navBar == nil{
            self.navBar = UINavigationBar(frame: CGRectMake(0,0, self.view.frame.size.width, 64))
            self.view.addSubview(navBar!)
        }
        
        let navBarItems = UINavigationItem()
        
        if leftNavBarItemImage != nil {
            let leftNavBarButton = UIBarButtonItem(image: leftNavBarItemImage!, style: UIBarButtonItemStyle.Plain, target: self, action: "dismissImageViewer")
            navBarItems.leftBarButtonItem = leftNavBarButton
        }else{
            let leftNavBarButtonImage = UIImage(named: "X.png")
            let leftNavBarButton = UIBarButtonItem(image: leftNavBarButtonImage, style: UIBarButtonItemStyle.Plain, target: self, action: "dismissImageViewer")
            navBarItems.leftBarButtonItem = leftNavBarButton
        }
        
        if navBarTitle != nil{
            navBarItems.title = navBarTitle
        }
        
        if rightNavBarItemTitle != nil {
            let rightNavBarButton = UIBarButtonItem(title: "\(rightNavBarItemTitle!)", style: UIBarButtonItemStyle.Plain, target: self, action: "openActionSheet")
            navBarItems.rightBarButtonItem = rightNavBarButton
        }

        navBar!.items = [navBarItems]
    }
    
    /**
    sets up the toolbar , default is false.
    - parameter setToolBar: set true if you want toolBar else toolBar Wont be shown .
    - parameter toolBarItems: array of all the UIBarButtonItem that you want in the toolbar .
    */
    func setToolBar(setToolBar setToolBar:Bool,toolBarItems:[UIBarButtonItem]?){
        guard setToolBar else{
            return
        }
        
        let toolBarYPos = self.view.frame.size.height - 44
        toolBar = UIToolbar(frame: CGRectMake(0,toolBarYPos,self.view.frame.size.width,44))
        self.view.addSubview(toolBar!)
    }
    
    /**
    set scroll view min and max zoom for the image, if function dont get called
    it will be default (min = 1.0, max = 3.0).
    - parameter scrollViewMinimumZoom: the min zoom out for the image.
    - parameter scrollviewMaximumZoom: the max zoom in for the image.
    */
    func setScrollViewZoomBounds(scrollViewMinimumZoom:CGFloat,scrollViewMaximumZoom:CGFloat){
        self.scrollView.minimumZoomScale = scrollViewMinimumZoom
        self.scrollView.maximumZoomScale = scrollViewMaximumZoom
    }
    
    /**
    sets the background color of the view after one tap that hide 
    navigation bar and toolBar if they exist and change the background color
    
     - Parameter color: the background color you desire,default is black
    */
    func setBackgroundColorDimmMode(color:UIColor){
        self.backGroundColorDimmMode = color
    }
    
    /**
    sets the background color of the view before tap that hide
    navigation bar and toolBar if they exist and change the background color
    
     - Parameter color: the background color you desire, default is white.
    */
    func setBackgroundColorLightMode(color:UIColor){
        self.backGroundColorLightMode = color
    }
    
    /*!
    handle the rotation call from your view controller
    
    - parameter size:the new view size after rotation
    */
    func rotationHandling(size:CGSize){
        let parent = self.parentViewController
        self.view.removeFromSuperview()
        
        self.view.frame = CGRectMake(0, 0, size.width, size.height)
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            self.scrollView.frame = self.view.frame
            self.navBar?.frame = CGRectMake(0, 0, self.view.frame.width, 64)
            
            self.imageView.frame = self.scrollView.frame
            self.toolBar?.frame = CGRectMake(0,size.height - 44,self.view.frame.size.width,44)
            self.centerScrollViewContents()
        })
        
        parent?.view.addSubview(self.view)
        if UIDevice.currentDevice().orientation.isLandscape && !self.navBar!.hidden{
            UIApplication.sharedApplication().statusBarHidden = true
            UIApplication.sharedApplication().statusBarHidden = false
        }
    }
    
    //------------------------------------------------------------    Private Functions    ------------------------------------------------------------//

    //sets the scroll view as the parent of image view that will handle the zoom,pinch and pan gesture
    private func setScrollView() -> UIScrollView{
        self.scrollView = UIScrollView(frame: self.view.bounds)
        self.scrollView.delegate = self
        self.scrollView.maximumZoomScale = 3.0
        self.scrollView.minimumZoomScale = 1.0
        self.scrollView.zoomScale = 1.0
        setTapGestureForScrollView()
        return self.scrollView
    }
    
    //sets the one and two tap gestureRecognize for the scrollView
    private func setTapGestureForScrollView(){
        let oneTapGesture = UITapGestureRecognizer(target: self, action: "tapGesture:")
        oneTapGesture.numberOfTapsRequired = 1
        
        let twoTapGesture = UITapGestureRecognizer(target: self, action: "doubleTapGesture:")
        twoTapGesture.numberOfTapsRequired = 2
        
        oneTapGesture.requireGestureRecognizerToFail(twoTapGesture)
        
        self.scrollView.addGestureRecognizer(oneTapGesture)
        self.scrollView.addGestureRecognizer(twoTapGesture)
    }
    
    //centers the views and animate them
    private func centerImageViewAnimationOnload(){
        imageView = UIImageView(frame: CGRectMake(parentImageView.frame.origin.x, parentImageView.frame.origin.y, parentImageView.frame.size.width, parentImageView.frame.size.height))
        imageView.layer.cornerRadius = parentImageView.layer.cornerRadius
        imageView.clipsToBounds = true
        imageView.image = parentImageView.image
        imageView.contentMode = .ScaleAspectFit
        scrollView.addSubview(self.imageView)
        
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            let imageWidth = self.parentImageView.image?.size.width
            let imageHeight = self.parentImageView.image?.size.height
            let imageRatio = imageWidth! / imageHeight!
            let viewRatio = self.view.frame.size.width/self.view.frame.size.height
            var ratio:CGFloat!
            
            if imageRatio >= viewRatio{
                ratio = imageWidth! / self.view.frame.size.width
            }else{
                ratio = imageHeight! / self.view.frame.size.height
            }
            
            let newWidth = imageWidth! / ratio
            let newHeight = imageHeight! / ratio
            
            self.imageView.frame = CGRectMake(self.scrollView.frame.origin.x, self.scrollView.frame.origin.y, newWidth, newHeight)
            self.imageView.center = CGPointMake(self.scrollView.center.x, self.scrollView.center.y)
            self.imageView.layer.cornerRadius = 0.0
            
            self.view.backgroundColor = UIColor.whiteColor()
            
            }, completion: { (finished) -> Void in
                
                self.panGestureRecognizer = UIPanGestureRecognizer(target: self, action: "onImageMovement:")
                self.scrollView.addGestureRecognizer(self.panGestureRecognizer)
                
        })
    }
    
    //handle image reposition to center
    private func centerScrollViewContents(){
        let boundSize = self.scrollView.bounds.size
        var contentsFrame = self.imageView.frame
        UIView.animateWithDuration(0.1) { () -> Void in
            if contentsFrame.size.width < boundSize.width{
                
                contentsFrame.origin.x = (boundSize.width - contentsFrame.size.width) / 2.0
                
            }else{  contentsFrame.origin.x = 0.0 }
            
            if contentsFrame.size.height < boundSize.height{
                
                contentsFrame.origin.y = (boundSize.height - contentsFrame.size.height ) / 2.0
                
            }else{ contentsFrame.origin.y = 0.0 }
            
            self.imageView.frame = contentsFrame
        }
        
    }

    //if right naviigationBar button is enabled show action sheet
    @objc private func openActionSheet(){
        let alertControler:UIAlertController = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
        let deleteAction:UIAlertAction = UIAlertAction(title: "Delete", style: UIAlertActionStyle.Default) { (action) -> Void in
    
            self.imageView.image = self.parentImageView.image
            
        }
        
        let takePicAction:UIAlertAction = UIAlertAction(title: "Take A Picture", style: UIAlertActionStyle.Default) { (action) -> Void in
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera) {
                let imagePicker:UIImagePickerController = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
                imagePicker.allowsEditing = false
                imagePicker.mediaTypes = [kUTTypeImage as String]
                
                self.presentViewController(imagePicker, animated: true, completion: nil)
                
            }else{
                let alert = UIAlertController(title: "Error", message: "Thers no camera available", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.Default, handler: { (action) -> Void in
                    alert.dismissViewControllerAnimated(true, completion: nil)
                }))
            }
        }
        
        let choosePicAction:UIAlertAction = UIAlertAction(title: "Choose Picture From Gallary", style: UIAlertActionStyle.Default) { (action) -> Void in
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.SavedPhotosAlbum) {
                let imagePicker = UIImagePickerController()
                
                imagePicker.delegate = self
                imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
                imagePicker.mediaTypes = [kUTTypeImage as String]
                imagePicker.allowsEditing = false
                self.presentViewController(imagePicker, animated: true, completion: nil)
            }else{
                let alert = UIAlertController(title: "Error", message: "Thers no camera available", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.Default, handler: { (action) -> Void in
                    alert.dismissViewControllerAnimated(true, completion: nil)
                }))
            }
        }
        
        let cancelAction:UIAlertAction = UIAlertAction(title: "Cancel" ,style: UIAlertActionStyle.Cancel, handler: nil)
        
        
        alertControler.addAction(takePicAction)
        alertControler.addAction(choosePicAction)
        alertControler.addAction(deleteAction)
        alertControler.addAction(cancelAction)
        self.presentViewController(alertControler, animated: true, completion: nil)
    }
    
    //dsimiss the view and animate the image to the size and center of the tapped image
    @objc private func dismissImageViewer(){
        self.view.backgroundColor = UIColor.clearColor()
        self.navBar?.hidden = true
        
        let cornerRatio = parentImageView.frame.width / parentImageView.layer.cornerRadius
        let cornerRadius = imageView.frame.width / cornerRatio
        
        let heightRatio = parentImageView.frame.width / parentImageView.frame.height
        let newHeight = imageView.frame.width / heightRatio
        
        imageView.frame = CGRectMake(0 , 0, self.imageView.frame.width, newHeight)
        imageView.layer.cornerRadius = cornerRadius
        
        let center = self.view.center
        self.view.frame = CGRectMake(self.imageView.frame.origin.x , self.imageView.frame.origin.y, self.imageView.frame.width, self.imageView.frame.height)
        self.view.center = center
        self.view.layer.cornerRadius = cornerRadius
        
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            self.parentViewController?.navigationController?.navigationBar.hidden = false
            self.parentViewController?.tabBarController?.tabBar.hidden = false
            
            let sx = self.parentImageView.frame.width/self.imageView.frame.width
            let sy = self.parentImageView.frame.height/self.imageView.frame.height
            
            self.imageView.transform = CGAffineTransformMakeScale(sx, sy)
            
            self.imageView.frame.origin = CGPointMake(0, 0)
            self.view.frame.origin = self.parentImageView.frame.origin
            
            }) { (finished) -> Void in
                self.onDismissView()
        }
    }
    
    //hides the navigation and toolBar and change backGroundColor
    @objc private func tapGesture(sender:UITapGestureRecognizer){
        if let hidden = navBar?.hidden{
            if hidden{
                self.navBar?.hidden = false
                self.toolBar?.hidden = false
                UIApplication.sharedApplication().statusBarHidden = false
                if backGroundColorLightMode != nil{
                    self.view.backgroundColor = backGroundColorLightMode
                }else{
                    self.view.backgroundColor = UIColor.whiteColor()
                }
                
            }else{
                self.navBar?.hidden = true
                self.toolBar?.hidden = true
                UIApplication.sharedApplication().statusBarHidden = true
                
                if backGroundColorLightMode != nil{
                    self.view.backgroundColor = backGroundColorDimmMode
                }else{
                    self.view.backgroundColor = UIColor.blackColor()
                }
            }
        }
        
    }
    
    //zoomin and zoomout based on the tap location on the scrollView
    @objc private func doubleTapGesture(sender:UITapGestureRecognizer){
        if self.scrollView.zoomScale == self.scrollView.minimumZoomScale{
            let zoomRect = self.zoomRectForScale(self.scrollView.maximumZoomScale, withCenter: sender.locationInView(sender.view))
            self.scrollView.zoomToRect(zoomRect, animated: true)
        }else{
            self.scrollView.setZoomScale(self.scrollView.minimumZoomScale, animated: true)
        }
    }
    
    //handles the zoom on double tap location
    private func zoomRectForScale(scale:CGFloat,var withCenter center:CGPoint) -> CGRect{
        
        var zoomRect:CGRect = CGRect()
        
        zoomRect.size.height = self.imageView.frame.size.height / scale
        zoomRect.size.width = self.imageView.frame.size.width / scale
        
        center = self.imageView.convertPoint(center, fromView: self.view)
        
        zoomRect.origin.x = center.x - zoomRect.size.width / 2.0
        zoomRect.origin.y = center.y - zoomRect.size.height / 2.0
        
        return zoomRect
    }
    
    //handle image movment and in specific position dismisses the view
    @objc private func onImageMovement(sender:UIPanGestureRecognizer){
        let deltaY = sender.translationInView(self.scrollView).y
        let translatedPoint = CGPointMake(self.view.center.x, self.view.center.y + deltaY)
        self.scrollView.center = translatedPoint
        
        if sender.state == UIGestureRecognizerState.Ended{
            let velocityY = sender.velocityInView(self.scrollView).y
            let maxDeltaY = (self.view.frame.size.height - imageView.frame.size.height)/2
            
            if velocityY > 700 || (abs(deltaY) > maxDeltaY && deltaY > 0){
                
                UIView.animateWithDuration(0.3, animations: { () -> Void in
                    
                    self.imageView.frame = CGRectMake(self.imageView.frame.origin.x, self.view.frame.size.height, self.imageView.frame.size.width, self.imageView.frame.size.height)
                    self.view.alpha = 0.0
                    
                    UIApplication.sharedApplication().statusBarHidden = false
                    self.parentViewController?.navigationController?.navigationBar.hidden = false
                    self.parentViewController?.tabBarController?.tabBar.hidden = false
                    
                    }, completion: { (finished) -> Void in
                        self.onDismissView()
                })
            }else if velocityY < -700 || (abs(deltaY) > maxDeltaY && deltaY < 0){
                
                UIView.animateWithDuration(0.3, animations: { () -> Void in
                    
                    self.imageView.frame = CGRectMake(self.imageView.frame.origin.x, -self.view.frame.size.height, self.imageView.frame.size.width, self.imageView.frame.size.height)
                    self.view.alpha = 0.0
                    UIApplication.sharedApplication().statusBarHidden = false
                    self.parentViewController?.navigationController?.navigationBar.hidden = false
                    self.parentViewController?.tabBarController?.tabBar.hidden = false
                    
                    }, completion: { (finished) -> Void in
                        self.onDismissView()
                })
                
            }else{
                UIView.animateWithDuration(0.3, animations: { () -> Void in
                    self.scrollView.center = self.view.center
                    }, completion: nil)
            }
        }
    }
    
    private func onDismissView(){
        self.imageView.removeFromSuperview()
        self.scrollView.removeFromSuperview()
        self.navBar?.removeFromSuperview()
        self.toolBar?.removeFromSuperview()
        
        self.navBar = nil
        self.toolBar = nil
        self.scrollView = nil
        self.imageView = nil
        
        self.view.removeFromSuperview()
        self.removeFromParentViewController()
        self.dismissViewControllerAnimated(false, completion: nil)
    }
    
    //-----------------------------------------------------------    ScrollView Delegate    -----------------------------------------------------------//
    
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    func scrollViewDidZoom(scrollView: UIScrollView) {
        self.centerScrollViewContents()
        
        if self.scrollView.zoomScale == self.scrollView.minimumZoomScale{
            self.scrollView.addGestureRecognizer(panGestureRecognizer)
        }else{
            self.scrollView.removeGestureRecognizer(panGestureRecognizer)
        }
    }
    
    //-----------------------------------------------------------    ImagePicker Delegate    ----------------------------------------------------------//
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        var pickedImage:UIImage!
        
        let mediaType = info[UIImagePickerControllerMediaType] as! NSString
        
        if mediaType.isEqualToString(kUTTypeImage as String) {
            
            // Media is an image
            
        } else if mediaType.isEqualToString(kUTTypeMovie as String) {
            return
        }
        
        if picker.allowsEditing{
            pickedImage = info[UIImagePickerControllerEditedImage] as! UIImage
        }else{
            pickedImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        }
        
        self.imageView.image = pickedImage
        self.imageViewerDelegate?.didPickNewImage(pickedImage)
        
        picker.dismissViewControllerAnimated(true) { () -> Void in
            picker.view.removeFromSuperview()
            picker.removeFromParentViewController()
            
            pickedImage = nil
        }
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
}
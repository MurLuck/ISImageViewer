//
//  ISImageViewer.swift
//  ISImageViewer
//
//  Created by VSquare on 17/12/2015.
//  Copyright © 2015 IgorSokolovsky. All rights reserved.
//

import Foundation
import UIKit

class ISImageViewer:UIViewController,UIScrollViewDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate{
    
    //------------------------------------------------------------------------------------------------------------------------------------------------//
    //------------------------------------------------------------    Class Variabls    --------------------------------------------------------------//
    //------------------------------------------------------------------------------------------------------------------------------------------------//
    
    ///the minimum zoom the scroll view will do to the image.
    ///the default is 1.0(default size)
    var scrollViewMinimumZoom:CGFloat?
    
    ///the maximum zoom the scroll view will do to the image.
    ///the default is 3.0
    var scrollviewMaximumZoom:CGFloat?
    
    //the image view that was tapped to call this class
    private let parentImageView:UIImageView
    
    //parent navigationBarController if exist
    private let navigatorBar:UINavigationController?
    
    //parent tabBarController if exist
    private let tabBar:UITabBarController?
    
    //the scroll view that allows us to zoom on the imageView
    private var scrollView:UIScrollView!
    
    //the image view inside scrollView that holds the image 
    private var imageView:UIImageView!
    
    //------------------------------------------------------------------------------------------------------------------------------------------------//
    //------------------------------------------------------    UIViewController Functions    --------------------------------------------------------//
    //------------------------------------------------------------------------------------------------------------------------------------------------//
    
    init(navigationBar:UINavigationController?,tabBar:UITabBarController?,imageView:UIImageView){
        if navigationBar != nil{
            self.navigatorBar = navigationBar!
        }else{
            self.navigatorBar = nil
        }
        
        if tabBar != nil {
            self.tabBar = tabBar!
        }else{
            self.tabBar = nil
        }
        
        self.parentImageView = imageView
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.edgesForExtendedLayout = .None
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //------------------------------------------------------------------------------------------------------------------------------------------------//
    //------------------------------------------------------------    Class Functions    -------------------------------------------------------------//
    //------------------------------------------------------------------------------------------------------------------------------------------------//
    
    //-----------------------------------------------------------//
    func prepareViewToBeLoaded(parenView:UIViewController){
        self.navigatorBar?.navigationBar.hidden = true
        self.tabBar?.hidesBottomBarWhenPushed = true
        self.view.alpha = 1
        self.view.frame = parenView.view.bounds
        self.view.backgroundColor = UIColor.whiteColor()
        parenView.view.addSubview(self.view)
        parenView.addChildViewController(self)
        
        self.view.addSubview(setScrollView())
        self.scrollView.addSubview(setImageView())
    }
    
    //-----------------------------------------------------------//
    
    /**
    sets up the navigation bar at the top of the imageViewer view
    
    - Parameter leftNavBarItemTitle:your custom left toolBar button Image. dismis the imageViewer. if nil , the image will be shown is X.
    - parameter navBarTitle:the title of the navigationBar, if nil , no title will be shown.
    - parameter rightNavBarItemTitle:the right toolBar button Title. Open ActionSheet. if nil , there wont be right button!
    */
    func setNavigationBar(leftNavBarItemImage:UIImage?,navBarTitle:String?,rightNavBarItemTitle:String?){
//        let navBar:UINavigationBar
//        if self.navigationController != nil {
//            navBar = UINavigationBar(frame: CGRectMake(0,64, self.view.frame.size.width, 64))
//        }else{
            let navBar = UINavigationBar(frame: CGRectMake(0,0, self.view.frame.size.width, 64))
      //  }
        
        let navBarItems = UINavigationItem()
        
        if leftNavBarItemImage != nil {
            let leftNavBarButton = UIBarButtonItem(image: leftNavBarItemImage!, style: UIBarButtonItemStyle.Plain, target: self, action: "dismissImageViewer")
            navBarItems.leftBarButtonItem = leftNavBarButton
        }else{
            let leftNavBarButtonImage = UIImage(named: "x.png")
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
        
        navBar.setItems([navBarItems], animated: false)
        navBar.items = [navBarItems]
        self.view.addSubview(navBar)
    }
    
    //-----------------------------------------------------------//
    
    func openActionSheet(){
        
    }
    
    func dismissImageViewer(){
        
    }
    
    //-----------------------------------------------------------    Private Functions    -------------------------------------------------------------//

    private func setScrollView() -> UIScrollView{
        self.scrollView = UIScrollView(frame: self.view.bounds)
        self.scrollView.delegate = self
        
        if self.scrollviewMaximumZoom != nil{
            self.scrollView.maximumZoomScale = scrollviewMaximumZoom!
        }else{
            self.scrollView.maximumZoomScale = 3.0
        }
        
        if self.scrollViewMinimumZoom != nil {
            self.scrollView.minimumZoomScale = self.scrollViewMinimumZoom!
        }else{
            self.scrollView.minimumZoomScale = 1.0
        }
        
        self.scrollView.zoomScale = 1.0
        return self.scrollView
    }
    
    private func setImageView() ->UIImageView{
        self.imageView = UIImageView(frame: self.scrollView.bounds)
        imageView.contentMode = .ScaleAspectFit
        imageView.image = parentImageView.image
        return self.imageView
    }
    
    private func centerImageView(){
        
    }
}
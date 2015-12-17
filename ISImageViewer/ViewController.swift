//
//  ViewController.swift
//  ISImageViewer
//
//  Created by VSquare on 17/12/2015.
//  Copyright © 2015 IgorSokolovsky. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    

    var imageView:UIImageView?
    var image:UIImage = UIImage(named: "ogame_space.jpg")!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.tintColor = UIColor.clearColor()
        self.navigationController?.navigationBar.backgroundColor = UIColor.clearColor()
        self.navigationController?.navigationBar.barTintColor = UIColor.clearColor()
        // Do any additional setup after loading the view, typically from a nib.
       
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        self.edgesForExtendedLayout = .None
        setUpImageView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setUpImageView(){
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.frame.width/2, height: self.view.frame.width/4))
        label.text = "Tap On The Image To Open The ImageViewer"
        label.numberOfLines = 2
        label.lineBreakMode = .ByWordWrapping
        label.textAlignment = .Center
        label.center = CGPoint(x: self.view.center.x, y: self.view.frame.height/4)
        self.view.addSubview(label)
        
        let gesture = UITapGestureRecognizer(target: self, action: "oneTapGestureReconizer:")
        gesture.numberOfTapsRequired = 1
        gesture.enabled = true
        imageView = UIImageView(image: image)
        imageView?.frame = CGRectMake(0, 0, self.view.bounds.width/2, self.view.bounds.width/2)
        imageView?.center = self.view.center
        imageView?.contentMode = .ScaleAspectFit
        imageView?.userInteractionEnabled = true
        imageView?.addGestureRecognizer(gesture)
        self.view.addSubview(imageView!)
    }


    func oneTapGestureReconizer(sender:UITapGestureRecognizer){
        print("Image View Was Tapped")
        let ivvc = ISImageViewer(navigationBar: nil,tabBar: nil,imageView: self.imageView!)
        ivvc.prepareViewToBeLoaded(self)
        ivvc.setNavigationBar(nil, navBarTitle: "ImageViewer", rightNavBarItemTitle: "Edit")
        self.navigationController?.pushViewController(ivvc, animated: true)//presentViewController(ivvc, animated: true, completion: nil)
    
    }
}


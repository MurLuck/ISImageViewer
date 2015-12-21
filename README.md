# ISAudioRecorder
ISImageViewerController

### Any issues, bugs and improvments reported are highly appreciated

![Screenshot0][img0] &nbsp;&nbsp; ![Screenshot1][img1] &nbsp;&nbsp; ![Screenshot0][img2] &nbsp;&nbsp; ![Screenshot1][img3] &nbsp;&nbsp;

## Getting Started

####### Swift 

and then its simple use, just create an instance and pass the imageview to present:

````Swift
let ivvc = ISImageViewer(imageView)
````

then just call 

````Swift
ivvc.prepareViewToBeLoaded(self)
````

if you want delegate that pass the image from imagePicker (more info later) add:

````Swift
class YourViewController: UIViewController,ISImageViewerDelegate
````

then :

````Swift
ivvc.imageViewerDelegate = self
````

and implement :

````Swift
func didPickNewImage(image:UIImage)
````

* *delegate that pass the data to parent controller, dont forget to append your controller to this delegate *
````Swift
var imageViewerDelegate:ISImageViewerDelegate?
````

````Swift
ivvc.imageViewerDelegate = self
````

####### functions:

sets up the navigation bar at the top of the imageViewer view

- Parameter leftNavBarItemTitle:your custom left toolBar button Image. dismis the imageViewer. if nil , the image will be shown is X.
- parameter navBarTitle:the title of the navigationBar, if nil , no title will be shown.
- parameter rightNavBarItemTitle:the right toolBar button Title. Open ActionSheet. if nil , there wont be right button!
````Swift
func setNavigationBar(leftNavBarItemImage:UIImage?,navBarTitle:String?,rightNavBarItemTitle:String?)
````

sets up the toolbar , default is false.
````Swift
func setToolBar(setToolBar setToolBar:Bool,toolBarItems:[UIBarButtonItem]?)
````

set scroll view min and max zoom for the image, if function dont get called
it will be default (min = 1.0, max = 3.0).
- parameter scrollViewMinimumZoom: the min zoom out for the image.
- parameter scrollviewMaximumZoom: the max zoom in for the image.
````Swift
func setScrollViewZoomBounds(scrollViewMinimumZoom:CGFloat,scrollViewMaximumZoom:CGFloat)
````

sets the background color of the view after one tap that hide 
navigation bar and toolBar if they exist and change the background color

- Parameter color: the background color you desire,default is black
````Swift
func setBackgroundColorDimmMode(color:UIColor)
````

sets the background color of the view before tap that hide
navigation bar and toolBar if they exist and change the background color

- Parameter color: the background color you desire, default is white.
````Swift
func setBackgroundColorLightMode(color:UIColor)
````

handle the rotation of the screen
resize all the views and position them
removes the view resize and adds it back so self.view will be on top
you need to handle your view for rotation

- parameter size:the new view size after rotation

````Swift
func rotationHandling(size:CGSize)
````

>**NOTE:**
>
> you better override UIView function .
> 
>override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator:UIViewControllerTransitionCoordinator) 
>
>and handle the rotation ther and call ivvc.rotationHandling(size:CGSize) in that function but its up to you.

####### Example


````Swift
ivvc.setNavigationBar(nil,navBarTitle:nil,rightNavBarItemTitle:nil)
````

# Thanks & Dependencies:

If some one deserve credite please leave a comment and i will check that out

this was writen based on what iv learned from peoples guide for swift 

## License

`ISImageViewer` is released under an [MIT License](http://opensource.org/licenses/MIT). See `LICENSE` for details.

>**Copyright &copy; 2015-present Igor Sokolovsky.**

*Please provide attribution, it is greatly appreciated.*


[img0]:https://raw.githubusercontent.com/MurLuck/ISImageViewer/master/1.png
[img1]:https://raw.githubusercontent.com/MurLuck/ISImageViewer/master/2.png
[img2]:https://raw.githubusercontent.com/MurLuck/ISImageViewer/master/3.png
[img3]:https://raw.githubusercontent.com/MurLuck/ISImageViewer/master/4.png

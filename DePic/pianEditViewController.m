//
//  pianEditViewController.m
//  DePic
//
//  Created by Pian Ji on 8/22/13.
//  Copyright (c) 2013 Pian Ji. All rights reserved.
//

#import "pianEditViewController.h"
#import "pianCTView.h"
#import "Global.h"
#import "QBImagePickerController.h"
#import "pianShareViewController.h"
#import "pianBackViewController.h"
#import "FlurryAds.h"
#import "Flurry.h"

#define CAMERA_TRANSFORM   1.12412

#define CAMERA_TRANSFORM_X 1
#define CAMERA_TRANSFORM_Y 1.22412

@interface pianEditViewController ()

@end

@implementation pianEditViewController
@synthesize btnTag;
@synthesize multiSelect;
@synthesize isBackground;
@synthesize multiImagePickerController;
@synthesize viewTemplate;
@synthesize viewSlider;
@synthesize sliderTransparent;
@synthesize viewPopup;
@synthesize viewTopbar;
@synthesize viewTempBack;
@synthesize viewTextAdjust;
@synthesize viewChange;
@synthesize colorPicker;

@synthesize tableFont;
@synthesize sliderFont;
@synthesize viewWatermark;
@synthesize viewCameraBar;
@synthesize imgBackground;
@synthesize imgTemplateBack;
@synthesize imgTempBack;
@synthesize imageFilter;
@synthesize imgWatermark;
@synthesize btnCameraContorl;
@synthesize btnCameraAuto;
@synthesize viewFilter;
@synthesize scrollviewFilter;

@synthesize arrayImageFilter;
@synthesize currentFrame;
@synthesize currentFilterButton;

@synthesize view_addView,view_buyNow;


+(id)sharedEditViewController{
    NSString *nibName =  IS_IPHONE5 ? @"pianEditViewController_iPhone5" : @"pianEditViewController";
	return [[pianEditViewController alloc] initWithNibName:nibName bundle:nil] ;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    textCount = 0;
    textIndex = 0;
    cameraIndex = 0;
    
    multiSelect = false;
    isBackground = false;
    
    [self setFrame];
    [self showButton:NO];
    [self showPopup:YES];
    [self showSlider:NO animated:NO];
    [self showTextAdjust:NO animated:NO];
    [self showFilter:NO animated:NO];
    [self showCameraBar:NO animated:NO];
    [self.viewTopbar setHidden:YES];
    [self.viewChange setHidden:YES];
    [self.imgTempBack setHidden:YES];
    [self.viewTempBack clipsToBounds];
    
    if (_globalData.bCustomWatermark == TRUE) {
        [self.imgWatermark setImage:_globalData.waterMark];
        [self.imgWatermark setAlpha:0.8f];
        [self.viewWatermark setFrame:CGRectMake(self.viewWatermark.frame.origin.x + self.viewWatermark.frame.size.width - _globalData.waterMark.size.width, self.viewWatermark.frame.origin.y + self.viewWatermark.frame.size.height - _globalData.waterMark.size.height, _globalData.waterMark.size.width, _globalData.waterMark.size.height)];
        [self.imgWatermark setFrame:CGRectMake(0, 0, _globalData.waterMark.size.width, _globalData.waterMark.size.height)];
        [self.viewWatermark setHidden:NO];
    }else{
        [self.viewWatermark setHidden:YES];
    }
    
    UIColor *c=[UIColor colorWithRed:(arc4random()%100)/100.0f
                               green:(arc4random()%100)/100.0f
                                blue:(arc4random()%100)/100.0f
                               alpha:1.0];
    
    colorPicker.color=c;
    colorPicker.delegate = self;
    
    familyNames = [[NSArray alloc] initWithArray:[UIFont familyNames]];
    
    for (NSInteger indFamily=0; indFamily<[familyNames count]; ++indFamily)
    {
        fontNames = [[NSArray alloc] initWithArray:[UIFont fontNamesForFamilyName:[familyNames objectAtIndex:indFamily]]];
    }
    
    [tableFont setHidden:YES];
    
//    arrayFilter = [ NSArray arrayWithObjects : @"Origin", @"BookStore", @"City", @"Country", @"Film", @"Forest", @"Lake", @"Moment", @"NYC", @"Tea", @"Vintage", @"1Q84", @"B&W", nil ] ;
    arrayFilter = [ NSArray arrayWithObjects : @"Origin", @"BookStore", @"City", @"Country", @"Film", nil ] ;
    [scrollviewFilter setContentSize:CGSizeMake(500, 80)];
    
    currentFrame = [[pianCTView alloc] init];
    
    [FlurryAds setAdDelegate:self];
    
    // Do any additional setup after loading the view from its nib.
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [FlurryAds fetchAndDisplayAdForSpace:@"pianEditViewController" view:view_addView size:BANNER_BOTTOM];
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    view_buyNow.hidden = YES;
   // [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackTranslucent animated:YES];
    
//    _pickerController = [[UIImagePickerController alloc] init];
//	_pickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
//	_pickerController.delegate = self;
//	_pickerController.showsCameraControls = NO;
//	_pickerController.allowsEditing = NO;
//    _pickerController.wantsFullScreenLayout = YES;
//    _pickerController.cameraViewTransform = CGAffineTransformScale(_pickerController.cameraViewTransform, CAMERA_TRANSFORM, CAMERA_TRANSFORM);
//
//    
//	[self.view addSubview:_pickerController.view];
//	[self.view sendSubviewToBack:_pickerController.view];
    if (self.imgBackground.image == [UIImage imageNamed:@"background.png"]) {
        [_pickerController.view setAlpha:0];
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
}

#pragma mark - share
- (UIImage *)captureView:(UIView *)view {
    
    CGRect screenRect = [viewTempBack bounds];
    
    //UIGraphicsBeginImageContext(screenRect.size);
    
    UIGraphicsBeginImageContextWithOptions(screenRect.size, viewTempBack.opaque, 0.0);
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    [[UIColor blackColor] set];
    CGContextFillRect(ctx, screenRect);
    
    [viewTempBack.layer renderInContext:ctx];
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    newImage = [self imageWithImage:newImage scaledToSize:CGSizeMake(300, 300)];
    
    UIGraphicsEndImageContext();
    
    return newImage;
}

- (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    
    //UIGraphicsBeginImageContext(newSize);
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

#pragma mark - create Textview

-(void) createTextView{
    pianTextView *textView = [[pianTextView alloc] initWithFrame:CGRectMake(40.0f, self.view.frame.size.height - KEYBOARD_HEIGHT - 150.0f, 0, 0)];
    textView.piandelegate = self;
    [textView setTag:textCount];
    [viewTempBack addSubview:textView];
    
    [_globalData.arrayTextView addObject:textView];
    textCount += 1;
}


#pragma mark - actions

-(IBAction)actionChangeTemplate:(id)sender{
    currentFrame = [arrayFrameView objectAtIndex:0];
    if (!(currentFrame.img_back.image == [UIImage imageNamed:@"img_temp"])){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Start Over?" message:@"Would you like to clear all pictures?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
        [alert show];
//        [alert release];
        return;
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(IBAction)actionChangeBackground:(id)sender{
    pianBackViewController *viewController = [pianBackViewController sharedViewController];
    viewController.filterDelegate = self;
    viewController.imageOriginal = imgTemplateBack.image;
    [self.navigationController pushViewController:viewController animated:YES];
}

-(IBAction)actionCameraAuto:(id)sender{
    switch (_cameraPickerController.cameraFlashMode) {
        case UIImagePickerControllerCameraFlashModeAuto:{
            _cameraPickerController.cameraFlashMode = UIImagePickerControllerCameraFlashModeOn;
            [btnCameraAuto setImage:[UIImage imageNamed:@"btn_cameraon"] forState:UIControlStateNormal];
            break;
        }
        case UIImagePickerControllerCameraFlashModeOn:{
            _cameraPickerController.cameraFlashMode = UIImagePickerControllerCameraFlashModeOff;
            [btnCameraAuto setImage:[UIImage imageNamed:@"btn_cameraoff"] forState:UIControlStateNormal];
            break;
        }
        case UIImagePickerControllerCameraFlashModeOff:{
            _cameraPickerController.cameraFlashMode = UIImagePickerControllerCameraFlashModeAuto;
            [btnCameraAuto setImage:[UIImage imageNamed:@"btn_auto"] forState:UIControlStateNormal];
            break;
        }
        default:
            break;
    }
}

-(IBAction)actionCameraControl:(id)sender{
    if (_cameraPickerController.cameraDevice == UIImagePickerControllerCameraDeviceRear) {
        _cameraPickerController.cameraDevice = UIImagePickerControllerCameraDeviceFront;
    }else{
        _cameraPickerController.cameraDevice = UIImagePickerControllerCameraDeviceRear;
    }
    
}

-(IBAction)actionCameraDone:(id)sender{
    [self imagePickerControllerDidCancel:(QBImagePickerController*)_cameraPickerController];
    [self setFrameCameraImage:(NSArray*)arrayCameraImage];
    [self setBlankImage];
}

-(IBAction)actionCancel:(id)sender{
    [_cameraPickerController dismissViewControllerAnimated:YES completion:Nil];
}

-(IBAction)actionTakePhoto:(id)sender{
    [_cameraPickerController takePicture];
    [btnCameraContorl setHidden:YES];
    [btnCameraAuto setHidden:YES];
}

-(IBAction)actionMore:(id)sender{
    [[Chartboost sharedChartboost] showMoreApps];
}

-(IBAction)actionPro:(id)sender{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://itunes.apple.com/us/app/depic-pro/id694589312?ls=1&mt=8"]];
}

-(IBAction)actionTextPlus:(id)sender{
    [self showTextAdjust:YES animated:NO];
    [self createTextView];
}


-(IBAction)actionFont:(id)sender{
    [colorPicker setHidden:YES];
    [tableFont setHidden:NO];
    [tableFont reloadData];
}

-(IBAction)actionFontColor:(id)sender{
    [colorPicker setHidden:NO];
    [tableFont setHidden:YES];
}

-(IBAction)actionLeft:(id)sender{
    [_globalData.currentTextView._lblText setTextAlignment:NSTextAlignmentLeft];
}

-(IBAction)actionRight:(id)sender{
    [_globalData.currentTextView._lblText setTextAlignment:NSTextAlignmentRight];
}

-(IBAction)actionCenter:(id)sender{
    [_globalData.currentTextView._lblText setTextAlignment:NSTextAlignmentCenter];
}

-(IBAction)actionFontSliderChanged:(UISlider*)sender{
    [_globalData.currentTextView._lblText setFont:[UIFont systemFontOfSize:sender.value] ];
}


-(IBAction)actionTextDone:(id)sender{
    [self showTextAdjust:NO animated:NO];
    [_globalData.currentTextView setTextBorder:NO];
    [viewTemplate setUserInteractionEnabled:YES];
}

-(IBAction)actionText:(id)sender{
    [self createTextView];
    [viewTemplate setUserInteractionEnabled:NO];
}

-(IBAction)actionShare:(id)sender{
    [self hideBorder];
    [self hideTextBorder];
    [self imagePickerControllerDidCancel:(QBImagePickerController*)_pickerController];
    
    pianShareViewController *viewController = [pianShareViewController sharedShareViewController];
    [self.imgTempBack setHidden:NO];
    [viewController setImageShare:[self captureView:self.view]];
    [self.navigationController pushViewController:viewController animated:YES];
    [self.imgTempBack setHidden:YES];
}

- (IBAction)actionDone:(id)sender{
    [self showSlider:NO animated:NO];
    [self showFilter:NO animated:NO];
    [self.viewTopbar setHidden:YES];
}

- (IBAction)actionFilterButton:(id)sender{
    for (int i = 0; i < 5; i++) {
        currentFilterButton = (UIButton* )[scrollviewFilter viewWithTag:i+50];
        currentFilterButton.layer.borderColor = [[UIColor yellowColor] CGColor];
        currentFilterButton.layer.borderWidth = 0.0f;
    }
    currentFilterButton = (UIButton*)sender;
    currentFilterButton.layer.borderColor = [[UIColor greenColor] CGColor];
    currentFilterButton.layer.borderWidth = 2.0f;
    
    currentFrame = [arrayFrameView objectAtIndex:frameIndex];
    [currentFrame setImage:[self setupFilter:[(UIButton*)sender tag]-50 :imageFilter]];
    
}

-(IBAction)actionFilter:(id)sender{
    currentFrame = [arrayFrameView objectAtIndex:frameIndex];
    if ((currentFrame.img_back.image != [UIImage imageNamed:@""]) && (currentFrame.img_back.image != [UIImage imageNamed:@"img_temp"])) {
        self.imageFilter = currentFrame.img_back.image;
        [self showFilter:YES animated:YES];
        [self.viewTopbar setHidden:NO];
        [self setFilterButton];
    }
    [self setFilterArry];
}

-(IBAction)actionTransparentSliderChanged:(UISlider*)sender{
    pianCTView *view = [arrayFrameView objectAtIndex:frameIndex];
    if ((view.img_back.image != [UIImage imageNamed:@""]) && (view.img_back.image != [UIImage imageNamed:@"img_temp"])) {
        [view.img_back setAlpha:sender.value];
    }
}

-(IBAction)actionSlider:(id)sender{
    pianCTView *view = [arrayFrameView objectAtIndex:frameIndex];
    if ((view.img_back.image != [UIImage imageNamed:@""]) && (view.img_back.image != [UIImage imageNamed:@"img_temp"])) {
        [self showSlider:YES animated:YES];
        [self.viewTopbar setHidden:NO];
    }
}

-(IBAction)mChangeSelect:(id)sender{
    if (self.imgTemplateBack.image != [UIImage imageNamed:@"img_templatebackground.png"]){
        if (self.viewChange.hidden == YES) {
            [self.viewChange setHidden:NO];
        }else{
            [self.viewChange setHidden:YES];
        }
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(IBAction)mCameraSelect:(id)sender{
    isBackground = TRUE;
    [self onAddFromCamera];
}

-(IBAction)mGallerySelect:(id)sender{
    isBackground = TRUE;
    [self onAddFromLibrary];
}


#pragma mark - tap gesture recognizer

- (void)handleLongPress:(UILongPressGestureRecognizer *)sender
{
    CGPoint newPoint = [sender locationInView:viewTemplate];
    
    if (sender.state == UIGestureRecognizerStateBegan)
    {
        CGPoint location = [sender locationInView:self.viewTemplate];
        frameIndex = [sender.view tag];
        draggableImageView = [[UIImageView alloc] init] ;
        
        UIImage *firstImage = [(pianCTView*)[arrayFrameView objectAtIndex:frameIndex] img_back].image;
        [draggableImageView setFrame:CGRectMake(location.x - firstImage.size.width/4/2, location.y - firstImage.size.height/4/2, firstImage.size.width/4, firstImage.size.height/4)];
        
        draggableImageView.image = firstImage;
        draggableImageView.alpha = 0.5;
        draggableImageView.userInteractionEnabled = YES;
        
        [self.viewTemplate addSubview:draggableImageView];
        [self setBorder];
        
    }else if (sender.state == UIGestureRecognizerStateChanged){
        
        CGPoint center = draggableImageView.center;
        center.x += newPoint.x - _priorPoint.x;
        center.y += newPoint.y - _priorPoint.y;
        draggableImageView.center = center;

    }else if (sender.state == UIGestureRecognizerStateEnded){
        for (int i = 0; i < frameCount; i++) {
            currentFrame = [arrayFrameView objectAtIndex:i];
            if ((newPoint.x > currentFrame.frame.origin.x) && (newPoint.x < currentFrame.frame.origin.x + currentFrame.frame.size.width) && (newPoint.y > currentFrame.frame.origin.y) && (newPoint.y < currentFrame.frame.origin.y + currentFrame.frame.size.height)) {
                
                if (!(currentFrame == (pianCTView *)[arrayFrameView objectAtIndex:frameIndex])) {
                    UIImage *imageTemp = [(pianCTView *)[arrayFrameView objectAtIndex:frameIndex] img_back].image;
                    [(pianCTView *)[arrayFrameView objectAtIndex:frameIndex] setImage:currentFrame.img_back.image];
                    [currentFrame setImage:imageTemp];
                    frameIndex = i;
                    
                    if (self.view.frame.size.height - viewFilter.frame.size.height == viewFilter.frame.origin.y) {
                        self.imageFilter = currentFrame.img_back.image;
                        [self setFilterButton];
                        [self setFilterArry];
                    }
                }
            }
        }
        [draggableImageView removeFromSuperview];
        NSLog(@"ended");
        [self setBorder];
        
    }
    _priorPoint = newPoint;
}

- (void)handleDoubleTap:(UITapGestureRecognizer *)recognizer {
    frameIndex = [recognizer.view tag];
    
    [self setBorder];
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Select an Image Source" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Choose From Library", @"Take Photo", nil];
    [actionSheet showInView:self.view];
//    [actionSheet release];
    
    if (self.view.frame.size.height - viewFilter.frame.size.height == viewFilter.frame.origin.y) {
        currentFrame = [arrayFrameView objectAtIndex:frameIndex];
        if (([currentFrame img_back].image != [UIImage imageNamed:@""]) && ([currentFrame img_back].image != [UIImage imageNamed:@"img_temp"])) {
            self.imageFilter = currentFrame.img_back.image;
            [self setFilterButton];
        }
    }

    
}

- (void)handleSingleTap:(UITapGestureRecognizer *)recognizer {
    frameIndex = [recognizer.view tag];
    
    [self setBorder];
    
    pianCTView *view = [arrayFrameView objectAtIndex:frameIndex];
    
    if (([(pianCTView*)recognizer.view img_back].image != [UIImage imageNamed:@""]) && ([(pianCTView*)recognizer.view img_back].image != [UIImage imageNamed:@"img_temp"])) {
        self.imageFilter = view.img_back.image;
        [self setFilterButton];
    }
    
    multiSelect = FALSE;
}

- (void)setBorder{
    [self hideBorder];
    currentFrame = [arrayFrameView objectAtIndex:frameIndex];
    [currentFrame.layer setBorderWidth:1.0f];
    [currentFrame.layer setBorderColor:[[UIColor greenColor] CGColor]];

}

- (void)hideBorder{
    for (int i = 0; i < frameCount; i++) {
        pianCTView *view = [arrayFrameView objectAtIndex:i];
        [view.layer setBorderWidth:0.0f];
    }
}

- (void)hideTextBorder{
    for (int i = 0; i < _globalData.arrayTextView.count; i++) {
        pianTextView *view = [_globalData.arrayTextView objectAtIndex:i];
        [view setTextBorder:NO];
    }
}
#pragma mark - set frame

- (void)setFilterButton{
    for (int i = 0; i < 5; i++) {
        currentFilterButton = (UIButton*)[scrollviewFilter viewWithTag:i+50];
        //[(UIButton*)sender layer].borderWidth = 0.0f;
        UIImage *buttonImage = [self setupFilter:i :imageFilter];
        [currentFilterButton setImage:buttonImage forState:UIControlStateNormal];
        [currentFilterButton.layer setShadowColor:[UIColor blackColor].CGColor];
        [currentFilterButton.layer setShadowOffset:CGSizeMake(1.0, 1.0)];
        [currentFilterButton.layer setShadowRadius:.8];
    }
}

- (void)showButton:(BOOL)bShow{
    
    for (int i = 0; i < [arrayFrameView count]; i++) {
        currentFrame = [arrayFrameView objectAtIndex:i];
        for (UIButton* button in currentFrame.subviews){
            if (button.tag == 100) {
                if (bShow) {
                    button.hidden = NO;
                }else{
                    button.hidden = YES;
                }
            }
        }
    }
    if (!bShow) {
        for (int i = 0; i<arrayFrameView.count; i++) {
            currentFrame = [arrayFrameView objectAtIndex:i];
            
            UITapGestureRecognizer *doubleFingerTap =
            [[UITapGestureRecognizer alloc] initWithTarget:self
                                                    action:@selector(handleDoubleTap:)];
            doubleFingerTap.numberOfTapsRequired = 2;
            
            [currentFrame addGestureRecognizer:doubleFingerTap];
            
//            [doubleFingerTap release];
            
            UITapGestureRecognizer *singleFingerTap =
            [[UITapGestureRecognizer alloc] initWithTarget:self
                                                    action:@selector(handleSingleTap:)];
            singleFingerTap.numberOfTapsRequired = 1;
            
            [currentFrame addGestureRecognizer:singleFingerTap];
            
//            [singleFingerTap release];
            
            UILongPressGestureRecognizer *gestureRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
            [currentFrame addGestureRecognizer:gestureRecognizer];
//            [gestureRecognizer release];
        }
    }
    
}

-(void)showCameraBar:(BOOL)bShow animated : (BOOL)bAnimated{
    if (bAnimated) {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.3f];
        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:viewTextAdjust cache:YES];
    }
    
    if (bShow) {
        viewCameraBar.frame = CGRectMake(0, self.view.frame.size.height - viewCameraBar.frame.size.height, viewCameraBar.frame.size.width, viewCameraBar.frame.size.height);
        viewCameraBar.hidden = NO;
        [btnCameraContorl setHidden:NO];
        [btnCameraAuto setHidden:NO];
    }
    else {
        viewCameraBar.frame = CGRectMake(0, self.view.frame.size.height , viewCameraBar.frame.size.width, viewCameraBar.frame.size.height);
        viewCameraBar.hidden = YES;
        btnCameraContorl.hidden = YES;
        [btnCameraAuto setHidden:YES];
    }
    if (bAnimated) {
        [UIView commitAnimations];
    }
    
}

-(void)showFilter:(BOOL)bShow animated : (BOOL)bAnimated{
    if (bAnimated) {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.3f];
        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:viewTextAdjust cache:YES];
    }
    
    if (bShow) {
        viewFilter.frame = CGRectMake(0, self.view.frame.size.height - viewFilter.frame.size.height, viewFilter.frame.size.width, viewFilter.frame.size.height);
        viewFilter.hidden = NO;
        [self.view bringSubviewToFront:viewFilter];
    }
    else {
        viewFilter.frame = CGRectMake(0, self.view.frame.size.height , viewFilter.frame.size.width, viewFilter.frame.size.height);
        viewFilter.hidden = YES;
    }
    
    if (bAnimated) {
        [UIView commitAnimations];
    }
    
}

-(void)showTextAdjust:(BOOL)bShow animated : (BOOL)bAnimated{
    if (bAnimated) {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.3f];
        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:viewTextAdjust cache:YES];
    }
    
    if (bShow) {
        viewTextAdjust.frame = CGRectMake(0, self.view.frame.size.height - viewTextAdjust.frame.size.height, viewTextAdjust.frame.size.width, viewTextAdjust.frame.size.height);
        viewTextAdjust.hidden = NO;
        [_globalData.currentTextView setTextBorder:YES];
        [viewTemplate setUserInteractionEnabled:NO];
        [self.view bringSubviewToFront:viewTextAdjust];
    }
    else {
        viewTextAdjust.frame = CGRectMake(0, self.view.frame.size.height , viewTextAdjust.frame.size.width, viewTextAdjust.frame.size.height);
        viewTextAdjust.hidden = YES;
        [_globalData.currentTextView setTextBorder:NO];
        [viewTemplate setUserInteractionEnabled:YES];
    }
    
    if (bAnimated) {
        [UIView commitAnimations];
    }
    
}


-(void)showSlider:(BOOL)bShow animated : (BOOL)bAnimated{
    if (bAnimated) {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.3f];
        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:viewSlider cache:YES];
    }
    
    if (bShow) {
        viewSlider.hidden = NO;
        viewSlider.frame = CGRectMake(0, self.view.frame.size.height - viewSlider.frame.size.height, viewSlider.frame.size.width, viewSlider.frame.size.height);
        [self.view bringSubviewToFront:viewSlider];
    }
    else {
        viewSlider.frame = CGRectMake(0, self.view.frame.size.height , viewSlider.frame.size.width, viewSlider.frame.size.height);
        viewSlider.hidden = YES;
    }
    
    if (bAnimated) {
        [UIView commitAnimations];
    }

}

-(void)showPopup:(BOOL)bShow{
    if (bShow) {
        [self.viewPopup setHidden:NO];
    }else{
        [self.viewPopup setHidden:YES];
    }
}

- (void)setFrameCameraImage:(NSArray *)array{
    for (int i = 0; i<array.count; i++) {
        if ([[array objectAtIndex:i] isKindOfClass:[UIImage class]]) {
            if (frameIndex + i < frameCount) {
                currentFrame= [arrayFrameView objectAtIndex:frameIndex + i];
            }else{
                currentFrame= [arrayFrameView objectAtIndex:frameIndex + i - frameCount];
            }
            //            UIImage *image = [array objectAtIndex:i] ;
            [currentFrame setImage:[array objectAtIndex:i]];
        }
    }
    [self showButton:NO];
}

-(void)setFilterArry{
    for (int i = 0 ; i < frameCount; i++) {
        currentFrame = [arrayFrameView objectAtIndex:i];
        if (currentFrame.img_back.image != nil) {
            [arrayImageFilter replaceObjectAtIndex:i withObject:currentFrame.img_back.image];
        }
    }
}

- (void)setBlankImage{
    for (int i = 0; i < frameCount; i++) {
        currentFrame = [arrayFrameView objectAtIndex:i];
        if (currentFrame.img_back.image == [UIImage imageNamed:@"img_temp"]) {
            [currentFrame setImage:[UIImage imageNamed:@""]];
        }
    }
}

- (void)setFrameImage:(NSArray *)array{
    for (int i = 0; i<array.count; i++) {
        if (frameIndex + i < frameCount) {
            currentFrame= [arrayFrameView objectAtIndex:frameIndex + i];
        }else{
            currentFrame= [arrayFrameView objectAtIndex:frameIndex + i - frameCount];
        }
        
        //        UIImage *image = [[array objectAtIndex:i] objectForKey:@"UIImagePickerControllerOriginalImage"];
        [currentFrame setImage:[[array objectAtIndex:i] objectForKey:@"UIImagePickerControllerOriginalImage"]];
    }
}

- (void)setFrameImageAtIndex:(UIImage *)image{
    currentFrame = [arrayFrameView objectAtIndex:frameIndex];
    [currentFrame setImage:image];
}

-(void)setFrame{
    switch (btnTag) {
        case 0:{
            pianCTView *viewTemp = [[pianCTView alloc] initWithFrame:CGRectMake(10.0, 10.0, 300.0f, 300.0f)];
            [self.viewTemplate addSubview:viewTemp];
            viewTemp.tag = 0;
            viewTemp.piandelegate = self;
            
            arrayFrameView = [[NSMutableArray alloc] initWithObjects:viewTemp, nil];
            frameCount = 1;
            break;
        }
        case 1:{
            pianCTView *viewTemp1 = [[pianCTView alloc] initWithFrame:CGRectMake(10, 10, 145.0f, 300.0f)];
            [self.viewTemplate addSubview:viewTemp1];
            viewTemp1.tag = 0;
            viewTemp1.piandelegate = self;
            
            pianCTView *viewTemp2 = [[pianCTView alloc] initWithFrame:CGRectMake(165.0f, 10.0f, 145.0f, 300.0f)];
            [self.viewTemplate addSubview:viewTemp2];
            viewTemp2.tag = 1;
            viewTemp2.piandelegate = self;
            
            arrayFrameView = [[NSMutableArray alloc] initWithObjects:viewTemp1, viewTemp2, nil];
            frameCount = 2;
            
            break;
        }
        case 2:{
            pianCTView *viewTemp1 = [[pianCTView alloc] initWithFrame:CGRectMake(10.0f, 10.0, 300.0f, 145.0f)];
            [self.viewTemplate addSubview:viewTemp1];
            viewTemp1.tag = 0;
            viewTemp1.piandelegate = self;
            
            pianCTView *viewTemp2 = [[pianCTView alloc] initWithFrame:CGRectMake(10.0, 165.0, 300.0f, 145.0f)];
            [self.viewTemplate addSubview:viewTemp2];
            viewTemp2.tag = 1;
            viewTemp2.piandelegate = self;
            
            arrayFrameView = [[NSMutableArray alloc] initWithObjects:viewTemp1, viewTemp2, nil];
            frameCount = 2;
            break;
        }
        case 3:{
            pianCTView *viewTemp1 = [[pianCTView alloc] initWithFrame:CGRectMake(10.0f, 10.0f, 145.0f, 300.0f)];
            [self.viewTemplate addSubview:viewTemp1];
            viewTemp1.tag = 0;
            viewTemp1.piandelegate = self;
            
            pianCTView *viewTemp2 = [[pianCTView alloc] initWithFrame:CGRectMake(165.0f, 10.0f, 145.0f, 145.0f)];
            [self.viewTemplate addSubview:viewTemp2];
            viewTemp2.tag = 1;
            viewTemp2.piandelegate = self;
            
            pianCTView *viewTemp3 = [[pianCTView alloc] initWithFrame:CGRectMake(165.0f, 165.0f, 145.0f, 145.0f)];
            [self.viewTemplate addSubview:viewTemp3];
            viewTemp3.tag = 2;
            viewTemp3.piandelegate = self;
            
            arrayFrameView = [[NSMutableArray alloc] initWithObjects:viewTemp1, viewTemp2, viewTemp3, nil];
            frameCount = 3;
            break;
        }
        case 4:{
            pianCTView *viewTemp1 = [[pianCTView alloc] initWithFrame:CGRectMake(10.0f, 10.0f, 300.0f, 145.0f)];
            [self.viewTemplate addSubview:viewTemp1];
            viewTemp1.tag = 0;
            viewTemp1.piandelegate = self;
            
            pianCTView *viewTemp2 = [[pianCTView alloc] initWithFrame:CGRectMake(10.0f, 165.0f, 145.0f, 145.0f)];
            [self.viewTemplate addSubview:viewTemp2];
            viewTemp2.tag = 1;
            viewTemp2.piandelegate = self;
            
            pianCTView *viewTemp3 = [[pianCTView alloc] initWithFrame:CGRectMake(165.0f, 165.0f, 145.0f, 145.0f)];
            [self.viewTemplate addSubview:viewTemp3];
            viewTemp3.tag = 2;
            viewTemp3.piandelegate = self;
            
            arrayFrameView = [[NSMutableArray alloc] initWithObjects:viewTemp1, viewTemp2, viewTemp3, nil];
            frameCount = 3;
            break;
            
        }
        case 5:{
            pianCTView *viewTemp1 = [[pianCTView alloc] initWithFrame:CGRectMake(10.0f, 10.0f, 95.0f, 300.0f)];
            [self.viewTemplate addSubview:viewTemp1];
            viewTemp1.tag = 0;
            viewTemp1.piandelegate = self;
            
            pianCTView *viewTemp2 = [[pianCTView alloc] initWithFrame:CGRectMake(112.5f, 10.0f, 95.0f, 300.0f)];
            [self.viewTemplate addSubview:viewTemp2];
            viewTemp2.tag = 1;
            viewTemp2.piandelegate = self;
            
            pianCTView *viewTemp3 = [[pianCTView alloc] initWithFrame:CGRectMake(215.0f, 10.0f, 95.0f, 300.0f)];
            [self.viewTemplate addSubview:viewTemp3];
            viewTemp3.tag = 2;
            viewTemp3.piandelegate = self;
            
            arrayFrameView = [[NSMutableArray alloc] initWithObjects:viewTemp1, viewTemp2, viewTemp3, nil];
            frameCount = 3;
            break;
        }
        case 6:{
            pianCTView *viewTemp1 = [[pianCTView alloc] initWithFrame:CGRectMake(10.0f, 10.0f, 70.0f, 300.0f)];
            [self.viewTemplate addSubview:viewTemp1];
            viewTemp1.tag = 0;
            viewTemp1.piandelegate = self;
            
            pianCTView *viewTemp2 = [[pianCTView alloc] initWithFrame:CGRectMake(87.0f, 10.0f, 70.0f, 300.0f)];
            [self.viewTemplate addSubview:viewTemp2];
            viewTemp2.tag = 1;
            viewTemp2.piandelegate = self;
            
            pianCTView *viewTemp3 = [[pianCTView alloc] initWithFrame:CGRectMake(163.0f, 10.0f, 70.0f, 300.0f)];
            [self.viewTemplate addSubview:viewTemp3];
            viewTemp3.tag = 2;
            viewTemp3.piandelegate = self;
            
            pianCTView *viewTemp4 = [[pianCTView alloc] initWithFrame:CGRectMake(240.0f, 10.0f, 70.0f, 300.0f)];
            [self.viewTemplate addSubview:viewTemp4];
            viewTemp4.tag = 3;
            viewTemp4.piandelegate = self;
            
            arrayFrameView = [[NSMutableArray alloc] initWithObjects:viewTemp1, viewTemp2, viewTemp3, viewTemp4, nil];
            frameCount = 4;
            break;
        }
        case 7:{
            pianCTView *viewTemp1 = [[pianCTView alloc] initWithFrame:CGRectMake(10.0f, 10.0f, 145.0f, 145.0f)];
            [self.viewTemplate addSubview:viewTemp1];
            viewTemp1.tag = 0;
            viewTemp1.piandelegate = self;
            
            pianCTView *viewTemp2 = [[pianCTView alloc] initWithFrame:CGRectMake(165.0f, 10.0f, 145.0f, 145.0f)];
            [self.viewTemplate addSubview:viewTemp2];
            viewTemp2.tag = 1;
            viewTemp2.piandelegate = self;
            
            pianCTView *viewTemp3 = [[pianCTView alloc] initWithFrame:CGRectMake(10.0f, 165.0f, 145.0f, 145.0f)];
            [self.viewTemplate addSubview:viewTemp3];
            viewTemp3.tag = 2;
            viewTemp3.piandelegate = self;
            
            pianCTView *viewTemp4 = [[pianCTView alloc] initWithFrame:CGRectMake(165.0f, 165.0f, 145.0f, 145.0f)];
            [self.viewTemplate addSubview:viewTemp4];
            viewTemp4.tag = 3;
            viewTemp4.piandelegate = self;
            
            arrayFrameView = [[NSMutableArray alloc] initWithObjects:viewTemp1, viewTemp2, viewTemp3, viewTemp4, nil];
            frameCount = 4;
            break;
        }
        default:
            break;
    }
    
    arrayCameraImage = [[NSMutableArray alloc] initWithCapacity:frameCount];
    arrayImageFilter = [[NSMutableArray alloc] initWithCapacity:frameCount];
    
    for (int i = 0; i < frameCount; i++) {
        [arrayCameraImage addObject:@""];
        [arrayImageFilter addObject:@""];
    }
    [viewTemplate bringSubviewToFront:viewWatermark];
    btnTag = -1;
}

-(void)onAddFromCamera{
    
    [self imagePickerControllerDidCancel:(QBImagePickerController*)_pickerController];
    //[_pickerController dismissViewControllerAnimated:YES completion:nil];
    
    if ([UIImagePickerController isSourceTypeAvailable:
         UIImagePickerControllerSourceTypeCamera])
    {
        _backPickerContoller = [[UIImagePickerController alloc] init];
        _backPickerContoller.delegate = self;
        _backPickerContoller.sourceType =UIImagePickerControllerSourceTypeCamera;
        _backPickerContoller.mediaTypes = [NSArray arrayWithObjects:(NSString *) kUTTypeImage,nil];
        _backPickerContoller.allowsEditing = YES;
        [self presentViewController:_backPickerContoller animated:YES completion:nil];
    }
}

-(void)onAddFromLibrary
{
	[self imagePickerControllerDidCancel:(QBImagePickerController*)_pickerController];
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum]) {
        _backPickerContoller = [[UIImagePickerController alloc] init] ;
        _backPickerContoller.delegate = self;
		_backPickerContoller.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        _backPickerContoller.allowsEditing = TRUE;

        [self presentViewController:_backPickerContoller animated:YES completion:nil];
    }
}

#pragma mark - uialertview delegate
- (void)alertView:(UIAlertView *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    // the user clicked one of the OK/Cancel buttons
    if (buttonIndex == 0)
    {
        
    }
    else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - colorpicker delegate

- (void)colorPicked:(UIColor *)color forPicker:(ILColorPickerView *)picker
{
    [_globalData.currentTextView._lblText setTextColor:color];
    //colorChip.backgroundColor=color;
}

#pragma mark - pianCameraDelegate
- (void)actionBack:(id)sender{
    [_cameraPickerController setToolbarHidden:YES animated:YES];
    [self showCameraBar:YES animated:YES];
}

- (void)actionUse:(id)sender{
    [arrayCameraImage replaceObjectAtIndex:cameraIndex withObject:cameraImage];
    cameraIndex += 1;
    [_cameraPickerController setToolbarHidden:YES animated:YES];
    [self showCameraBar:YES animated:YES];
    if (cameraIndex == frameCount) {
        [self imagePickerControllerDidCancel:(QBImagePickerController*)_cameraPickerController];
        [self setFrameCameraImage:(NSArray*)arrayCameraImage];
    }
}

#pragma mark - pianbackdelegate
- (void)setFileteredBackImage:(UIImage *)image{
    [imgTemplateBack setImage:image];
    [self.viewChange setHidden:YES];
}

#pragma mark - pianFilterDelegate
- (void)setFileteredImage:(UIImage *)image{
    [self setFrameImageAtIndex:image];
}

#pragma mark - pianCTViewDelegate
- (void)actionClick:(id)sender{
    frameIndex = [[sender superview] tag];
    [self setBorder];
    multiSelect = TRUE;
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Select an Image Source" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Choose From Library", @"Take Photo", nil];
    [actionSheet showInView:self.view];
//    [actionSheet release];

}

#pragma mark - pianTextview Delegate
- (void)actionTextDelegate:(int)mTag{
    _globalData.currentTextView = [_globalData.arrayTextView objectAtIndex:mTag];
    textIndex = mTag;
    [self showTextAdjust:YES animated:YES];
}

#pragma mark - actionsheet delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    // the user clicked one of the OK/Cancel buttons
    
    if (buttonIndex == 0){
            [self imagePickerControllerDidCancel:(QBImagePickerController*)_pickerController];
            QBImagePickerController *imagePickerController = [[QBImagePickerController alloc] init] ;
//        QBImagePickerController *imagePickerController = [[[QBImagePickerController alloc] init] autorelease];
            imagePickerController.delegate = self;
            imagePickerController.filterType = QBImagePickerFilterTypeAllPhotos;
            imagePickerController.showsCancelButton = YES;
            imagePickerController.fullScreenLayoutEnabled = YES;
            imagePickerController.allowsMultipleSelection = YES;
            
            imagePickerController.limitsMaximumNumberOfSelection = YES;
            imagePickerController.maximumNumberOfSelection = frameCount;
            
            UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:imagePickerController];
//        UINavigationController *navigationController = [[[UINavigationController alloc] initWithRootViewController:imagePickerController] autorelease];
        
            [self presentViewController:navigationController animated:YES completion:NULL];

    }else if (buttonIndex == 1){

            cameraIndex = 0;
        
            [self imagePickerControllerDidCancel:(QBImagePickerController*)_pickerController];
            
            _cameraPickerController = [[UIImagePickerController alloc] init];
            _cameraPickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
            _cameraPickerController.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;
            _cameraPickerController.cameraDevice = UIImagePickerControllerCameraDeviceRear;
            _cameraPickerController.cameraFlashMode = UIImagePickerControllerCameraFlashModeAuto;
            _cameraPickerController.showsCameraControls = NO;
            _cameraPickerController.navigationBarHidden = YES;
            _cameraPickerController.toolbarHidden = YES;
            _cameraPickerController.wantsFullScreenLayout = YES;
            _cameraPickerController.cameraViewTransform = CGAffineTransformScale(_cameraPickerController.cameraViewTransform, CAMERA_TRANSFORM_X, CAMERA_TRANSFORM_Y);
            _cameraPickerController.delegate = self;
        
            [btnCameraContorl setFrame:CGRectMake(250, 40, 55, 27)];
            [btnCameraAuto setFrame:CGRectMake(15, 40, 55, 27)];
        
            [_cameraPickerController.view addSubview:viewCameraBar];
            [_cameraPickerController.view addSubview:btnCameraContorl];
            [_cameraPickerController.view addSubview:btnCameraAuto];
        
            [self showCameraBar:YES animated:YES];

            
            [self presentViewController:_cameraPickerController animated:YES completion:nil];
//            [_cameraPickerController release];
    }
}

#pragma mark UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    if (picker.class == [QBImagePickerController class]) {
        QBImagePickerController *pickerController = (QBImagePickerController *)picker;
        if (pickerController.allowsMultipleSelection) {
            NSArray *mediaInfoArray = (NSArray *)info;
            //imageArray =(NSMutableArray*) mediaInfoArray;
            [self setFrameImage:mediaInfoArray];
            [self setBlankImage];
        }
        [self showButton:NO];
        [self dismissViewControllerAnimated:YES completion:nil];
    }else if(picker == _backPickerContoller){
        UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
        
        [self.imgTemplateBack setImage:image];
        [self.imgBackground setImage:[UIImage imageNamed:@"background.png"]];
        [self dismissViewControllerAnimated:YES completion:nil];
        [self showButton:YES];
        [self showPopup:NO];
    }else if (picker == _cameraPickerController){
       // [self dismissViewControllerAnimated:YES completion:nil];
        
        cameraImage = [info objectForKey:UIImagePickerControllerOriginalImage];
        cameraViewController = [pianCameraViewController sharedViewController];
        cameraViewController.piandelegate = self;
        [cameraViewController setOriginalImage:cameraImage];
        [self showCameraBar:NO animated:NO];
        [self showButton:NO];
        [_cameraPickerController pushViewController:cameraViewController animated:YES];
        
    }
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackTranslucent animated:YES];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    if (picker == _pickerController) {
        [self dismissViewControllerAnimated:YES completion:nil];
        [picker.view removeFromSuperview];
//        [picker release];
    }else if(picker == _cameraPickerController){
        [self dismissViewControllerAnimated:NO completion:Nil];
    }else if(picker.class == [QBImagePickerController class] ){
        [self dismissViewControllerAnimated:YES completion:Nil];
    }else{
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
//    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackTranslucent animated:YES];
}


#pragma mark - QBImagePickerControllerDelegate


- (NSString *)descriptionForSelectingAllAssets:(QBImagePickerController *)imagePickerController
{
    return @"すべての写真を選択";
}

- (NSString *)descriptionForDeselectingAllAssets:(QBImagePickerController *)imagePickerController
{
    return @"すべての写真の選択を解除";
}

- (NSString *)imagePickerController:(QBImagePickerController *)imagePickerController descriptionForNumberOfPhotos:(NSUInteger)numberOfPhotos
{
    return [NSString stringWithFormat:@"写真%d枚", numberOfPhotos];
}

- (NSString *)imagePickerController:(QBImagePickerController *)imagePickerController descriptionForNumberOfVideos:(NSUInteger)numberOfVideos
{
    return [NSString stringWithFormat:@"ビデオ%d本", numberOfVideos];
}

- (NSString *)imagePickerController:(QBImagePickerController *)imagePickerController descriptionForNumberOfPhotos:(NSUInteger)numberOfPhotos numberOfVideos:(NSUInteger)numberOfVideos
{
    return [NSString stringWithFormat:@"写真%d枚、ビデオ%d本", numberOfPhotos, numberOfVideos];
}

#pragma mark  - font table delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return familyNames.count; // Font and Font features, although the latter for some fonts may have no feature enabled
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	fontNames = [[NSArray alloc] initWithArray:
                 [UIFont fontNamesForFamilyName:
                  [familyNames objectAtIndex:section]]];
	return fontNames.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
//	return [familyNames objectAtIndex:section];
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] ;
//        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
	
	cell.selectionStyle = UITableViewCellSelectionStyleBlue;
	cell.accessoryType = UITableViewCellAccessoryNone;
	cell.textLabel.enabled = YES;
    
    fontNames = [[NSArray alloc] initWithArray:
                 [UIFont fontNamesForFamilyName:
                  [familyNames objectAtIndex:indexPath.section]]];
    
    NSString *fontName = [fontNames objectAtIndex:indexPath.row];
    
    cell.textLabel.text = _globalData.currentTextView._lblText.text;
	cell.textLabel.font = [UIFont fontWithName:fontName size:20.0];
	
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    fontNames = [[NSArray alloc] initWithArray:
                 [UIFont fontNamesForFamilyName:
                  [familyNames objectAtIndex:indexPath.section]]];
    
    NSString *fontName = [fontNames objectAtIndex:indexPath.row];
    
    [_globalData.currentTextView._lblText setFont:[UIFont fontWithName:fontName size:sliderFont.value]];
}


#pragma mark - filter

- (UIImage *) setupFilter : ( FILTER_TYPE ) _type : (UIImage *)image
{
    GPUImageOutput < GPUImageInput >* filterForCamera = nil ;
    
    // New ;
    switch( _type )
    {
        case FILTER_ORIGINAL :
        {
            filterForCamera = [ [ GPUImageGammaFilter alloc ] init ] ;
            break ;
        }
            
        case FILTER_BOOKSTORE :
        {
            filterForCamera = [ [ GPUImageFilterGroup alloc ] init ] ;
            
            // Tone Curve ;
            GPUImageToneCurveFilter*    tone        = [[ GPUImageToneCurveFilter alloc ] initWithACV : @"BookStore" ];
            GPUImageSaturationFilter*   saturation  = [  [ GPUImageSaturationFilter alloc ] init ];
            
            [ ( GPUImageFilterGroup* )filterForCamera addFilter : saturation ] ;
            [ tone addTarget : saturation ] ;
            
            [ ( GPUImageFilterGroup* )filterForCamera setInitialFilters : [ NSArray arrayWithObject : tone ] ] ;
            [ ( GPUImageFilterGroup* )filterForCamera setTerminalFilter : saturation ] ;
            break ;
        }
            
        case FILTER_CITY :
        {
            filterForCamera = [ [ GPUImageFilterGroup alloc ] init ] ;
            
            GPUImageToneCurveFilter*    tone        = [ [ GPUImageToneCurveFilter alloc ] initWithACV : @"City" ] ;
            GPUImageSaturationFilter*   saturation  =  [ [ GPUImageSaturationFilter alloc ] init ] ;
            
            [ ( GPUImageFilterGroup* )filterForCamera addFilter : saturation ] ;
            [ tone addTarget : saturation ] ;
            
            [ ( GPUImageFilterGroup* )filterForCamera setInitialFilters : [ NSArray arrayWithObject : tone ] ] ;
            [ ( GPUImageFilterGroup* )filterForCamera setTerminalFilter : saturation ] ;
            break ;
        }
            
        case FILTER_COUNTRY :
        {
            filterForCamera = [ [ GPUImageFilterGroup alloc ] init ] ;
            
            // Tone Curve ;
            GPUImageToneCurveFilter*    tone        = [ [ GPUImageToneCurveFilter alloc ] initWithACV : @"Country" ] ;
            GPUImageSaturationFilter*   saturation  = [ [ GPUImageSaturationFilter alloc ] init ] ;
            
            [ ( GPUImageFilterGroup* )filterForCamera addFilter : saturation ] ;
            [ tone addTarget : saturation ] ;
            
            [ ( GPUImageFilterGroup* )filterForCamera setInitialFilters : [ NSArray arrayWithObject : tone ] ] ;
            [ ( GPUImageFilterGroup* )filterForCamera setTerminalFilter : saturation ] ;
            break ;
        }
            
        case FILTER_FILM :
        {
            filterForCamera = [ [ GPUImageFilterGroup alloc ] init ] ;
            
            // Tone Curve ;
            GPUImageToneCurveFilter*    tone        = [ [ GPUImageToneCurveFilter alloc ] initWithACV : @"Film" ] ;
            GPUImageSaturationFilter*   saturation  = [ [ GPUImageSaturationFilter alloc ] init ]  ;
            
            [ ( GPUImageFilterGroup* )filterForCamera addFilter : saturation ] ;
            [ tone addTarget : saturation ] ;
            
            [ ( GPUImageFilterGroup* )filterForCamera setInitialFilters : [ NSArray arrayWithObject : tone ] ] ;
            [ ( GPUImageFilterGroup* )filterForCamera setTerminalFilter : saturation ] ;
            break ;
        }
            
        case FILTER_FOREST :
        {
            filterForCamera = [ [ GPUImageFilterGroup alloc ] init ] ;
            
            // Tone Curve ;
            GPUImageToneCurveFilter*    tone        = [ [ GPUImageToneCurveFilter alloc ] initWithACV : @"Forest" ] ;
            GPUImageSaturationFilter*   saturation  = [ [ GPUImageSaturationFilter alloc ] init ] ;
            
            [ ( GPUImageFilterGroup* )filterForCamera addFilter : saturation ] ;
            [ tone addTarget : saturation ] ;
            
            [ ( GPUImageFilterGroup* )filterForCamera setInitialFilters : [ NSArray arrayWithObject : tone ] ] ;
            [ ( GPUImageFilterGroup* )filterForCamera setTerminalFilter : saturation ] ;
            break ;
        }
            
        case FILTER_LAKE :
        {
            filterForCamera = [ [ GPUImageFilterGroup alloc ] init ] ;
            
            // Tone Curve ;
            GPUImageToneCurveFilter*    tone        = [ [ GPUImageToneCurveFilter alloc ] initWithACV : @"Lake" ] ;
            GPUImageSaturationFilter*   saturation  = [ [ GPUImageSaturationFilter alloc ] init ] ;
            
            [ ( GPUImageFilterGroup* )filterForCamera addFilter : saturation ] ;
            [ tone addTarget : saturation ] ;
            
            [ ( GPUImageFilterGroup* )filterForCamera setInitialFilters : [ NSArray arrayWithObject : tone ] ] ;
            [ ( GPUImageFilterGroup* )filterForCamera setTerminalFilter : saturation ] ;
            break ;
        }
            
        case FILTER_MOMENT :
        {
            filterForCamera = [ [ GPUImageFilterGroup alloc ] init ] ;
            
            // Tone Curve ;
            GPUImageToneCurveFilter*    tone        = [ [ GPUImageToneCurveFilter alloc ] initWithACV : @"Moment" ] ;
            GPUImageSaturationFilter*   saturation  = [ [ GPUImageSaturationFilter alloc ] init ] ;
            
            [ ( GPUImageFilterGroup* )filterForCamera addFilter : saturation ] ;
            [ tone addTarget : saturation ] ;
            
            [ ( GPUImageFilterGroup* )filterForCamera setInitialFilters : [ NSArray arrayWithObject : tone ] ] ;
            [ ( GPUImageFilterGroup* )filterForCamera setTerminalFilter : saturation ] ;
            break ;
        }
            
        case FILTER_NYC :
        {
            filterForCamera = [ [ GPUImageFilterGroup alloc ] init ] ;
            
            // Tone Curve ;
            GPUImageToneCurveFilter*    tone        = [ [ GPUImageToneCurveFilter alloc ] initWithACV : @"NYC" ] ;
            GPUImageSaturationFilter*   saturation  = [ [ GPUImageSaturationFilter alloc ] init ] ;
            
            [ ( GPUImageFilterGroup* )filterForCamera addFilter : saturation ] ;
            [ tone addTarget : saturation ] ;
            
            [ ( GPUImageFilterGroup* )filterForCamera setInitialFilters : [ NSArray arrayWithObject : tone ] ] ;
            [ ( GPUImageFilterGroup* )filterForCamera setTerminalFilter : saturation ] ;
            break ;
        }
            
        case FILTER_TEA :
        {
            filterForCamera = [ [ GPUImageFilterGroup alloc ] init ] ;
            
            // Tone Curve ;
            GPUImageToneCurveFilter*    tone        = [ [ GPUImageToneCurveFilter alloc ] initWithACV : @"Tea" ] ;
            GPUImageSaturationFilter*   saturation  = [ [ GPUImageSaturationFilter alloc ] init ] ;
            
            [ ( GPUImageFilterGroup* )filterForCamera addFilter : saturation ] ;
            [ tone addTarget : saturation ] ;
            
            [ ( GPUImageFilterGroup* )filterForCamera setInitialFilters : [ NSArray arrayWithObject : tone ] ] ;
            [ ( GPUImageFilterGroup* )filterForCamera setTerminalFilter : saturation ] ;
            break ;
        }
            
        case FILTER_VINTAGE :
        {
            filterForCamera = [ [ GPUImageFilterGroup alloc ] init ] ;
            
            // Tone Curve ;
            GPUImageToneCurveFilter*    tone        = [ [ GPUImageToneCurveFilter alloc ] initWithACV : @"Vintage" ] ;
            GPUImageVignetteFilter*     vintage     = [ [ GPUImageVignetteFilter alloc ] init ] ;
            
            [ ( GPUImageFilterGroup* )filterForCamera addFilter : vintage ] ;
            [ tone addTarget : vintage ] ;
            
            [ ( GPUImageFilterGroup* )filterForCamera setInitialFilters : [ NSArray arrayWithObject : tone ] ] ;
            [ ( GPUImageFilterGroup* )filterForCamera setTerminalFilter : vintage ] ;
            break ;
        }
            
        case FILTER_1Q84 :
        {
            filterForCamera = [ [ GPUImageFilterGroup alloc ] init ] ;
            
            // Tone Curve ;
            GPUImageToneCurveFilter*    tone        = [ [ GPUImageToneCurveFilter alloc ] initWithACV : @"1Q84" ]  ;
            GPUImageSaturationFilter*   saturation  = [ [ GPUImageSaturationFilter alloc ] init ] ;
            
            [ ( GPUImageFilterGroup* )filterForCamera addFilter : saturation ] ;
            [ tone addTarget : saturation ] ;
            
            [ ( GPUImageFilterGroup* )filterForCamera setInitialFilters : [ NSArray arrayWithObject : tone ] ] ;
            [ ( GPUImageFilterGroup* )filterForCamera setTerminalFilter : saturation ] ;
            break ;
        }
            
        case FILTER_BW :
        {
            filterForCamera = [ [ GPUImageFilterGroup alloc ] init ] ;
            
            // Tone Curve ;
            GPUImageToneCurveFilter*    tone        = [ [ GPUImageToneCurveFilter alloc ] initWithACV : @"B&W" ] ;
            GPUImageGrayscaleFilter*    gray        = [ [ GPUImageGrayscaleFilter alloc ] init ] ;
            
            [ ( GPUImageFilterGroup* )filterForCamera addFilter : gray ] ;
            [ tone addTarget : gray ] ;
            
            [ ( GPUImageFilterGroup* )filterForCamera setInitialFilters : [ NSArray arrayWithObject : tone ] ] ;
            [ ( GPUImageFilterGroup* )filterForCamera setTerminalFilter : gray ] ;
            break ;
        }
            
        default :
        {
            filterForCamera = [ [ GPUImageGammaFilter alloc ] init ] ;
            break ;
        }
    }
    
    GPUImageRotationMode imageViewRotationMode = kGPUImageRotateLeft ;
    
    switch( [ imageFilter imageOrientation ] )
    {
        case UIImageOrientationLeft :
            imageViewRotationMode = kGPUImageRotateLeft ;
            break ;
            
        case UIImageOrientationRight :
            imageViewRotationMode = kGPUImageRotateRight ;
            break ;
            
        case UIImageOrientationDown :
            imageViewRotationMode = kGPUImageNoRotation ;
            break ;
            
        default :
            imageViewRotationMode = kGPUImageNoRotation ;
            break ;
    }
    
    [ filterForCamera setInputRotation : imageViewRotationMode atIndex : 0 ] ;
    
    UIImage *filteredImage = [ filterForCamera imageByFilteringImage : imageFilter ] ;
    
    return filteredImage;
}
@end

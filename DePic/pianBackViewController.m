//
//  pianBackViewController.m
//  DePic
//
//  Created by Pian Ji on 9/20/13.
//  Copyright (c) 2013 Pian Ji. All rights reserved.
//

#import "pianBackViewController.h"

@interface pianBackViewController ()

@end

@implementation pianBackViewController
@synthesize imageFiltered;
@synthesize imageOriginal;
@synthesize imageView;
@synthesize filterDelegate;
@synthesize filterView;
@synthesize viewImage,view_buyNow;

+(id)sharedViewController{
    NSString *nibName =  IS_IPHONE5 ? @"pianBackViewController_iPhone5" : @"pianBackViewController";
	return [[pianBackViewController alloc] initWithNibName:nibName bundle:nil] ;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (IBAction)btn_proClicked{
    
    view_buyNow.hidden= NO;
    view_buyNow.alpha = 0.0;
    [self.view bringSubviewToFront:view_buyNow];
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.7];
    [view_buyNow setAlpha:1.0];
    [UIView commitAnimations];
}

- (IBAction)btn_buyOptionClickd : (id)sender{
    
    if ([(UIButton*)sender tag] == 0) {
        [self.view bringSubviewToFront:view_buyNow];
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.7];
        [view_buyNow setAlpha:0.0];
        [UIView commitAnimations];
        view_buyNow.hidden = YES;
        [[UIApplication sharedApplication]
         openURL:[NSURL URLWithString:@"https://itunes.apple.com/us/app/depic-transparent-collage/id694589312?mt=8"]];
    }else{
        
        [self.view bringSubviewToFront:view_buyNow];
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.7];
        [view_buyNow setAlpha:0.0];
        [UIView commitAnimations];
        view_buyNow.hidden = YES;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [filterView setContentSize:CGSizeMake(920, 80)];
    
    [imageView setImage:imageOriginal];
    
    UITapGestureRecognizer *doubleFingerTap =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(textDoubleTap:)];
    doubleFingerTap.numberOfTapsRequired = 2;
    
    [viewImage addGestureRecognizer:doubleFingerTap];
    
    arrayFilter = [ NSArray arrayWithObjects : @"Origin", @"BookStore", @"City", @"Country", @"Film", @"Forest", @"Lake", @"Moment", @"NYC", @"Tea", @"Vintage", @"1Q84", @"B&W", nil ] ;
    
    [self setFilterButton];

    // Do any additional setup after loading the view from its nib.
}

-(void)viewWillAppear:(BOOL)animated{
    view_buyNow.hidden = YES;
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackTranslucent animated:YES];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setFilterButton{
    for (int i = 0; i < 13; i++) {
        UIButton *bt = (UIButton*)[filterView viewWithTag:i+50];
        //[(UIButton*)sender layer].borderWidth = 0.0f;
        UIImage *buttonImage = [self setupFilter:i :imageOriginal];
        [bt setImage:buttonImage forState:UIControlStateNormal];
    }
}

#pragma mark - action
- (IBAction)actionDone:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
    imageFiltered = imageView.image;
    
    if( [filterDelegate respondsToSelector : @selector(setFileteredBackImage:) ] )
    {
        [filterDelegate setFileteredBackImage:imageFiltered];
    }
}

- (IBAction)actionFilterButton:(id)sender{
    for (int i = 0; i < 13; i++) {
        UIButton *button = (UIButton* )[filterView viewWithTag:i+50];
        button.layer.borderColor = [[UIColor greenColor] CGColor];
        button.layer.borderWidth = 0.0f;
    }
    UIButton *button = (UIButton*)sender;
    button.layer.borderColor = [[UIColor greenColor] CGColor];
    button.layer.borderWidth = 2.0f;
    
    [imageView setImage:[self setupFilter:[(UIButton*)sender tag]-50 :imageOriginal]];
}

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
    
    switch( [ imageOriginal imageOrientation ] )
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
    
    UIImage *filteredImage = [ filterForCamera imageByFilteringImage : imageOriginal ] ;
    
    return filteredImage;
}

- (void)textDoubleTap:(UITapGestureRecognizer *)recognizer {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Select an Image Source" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Choose From Library", @"Take Photo", nil];
    [actionSheet showInView:self.view];
//    [actionSheet release];
}

#pragma mark - actionsheet delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == 1){
        UIImagePickerController *pickerController = [[UIImagePickerController alloc] init];
        pickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
        pickerController.delegate = self;
        pickerController.allowsEditing = YES;
        [self presentViewController:pickerController animated:YES completion:nil];
//        [pickerController release];
    }else if (buttonIndex == 0){
        UIImagePickerController *pickerController = [[UIImagePickerController alloc] init];
        pickerController.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        pickerController.delegate = self;
        pickerController.allowsEditing = YES;
        [self presentViewController:pickerController animated:YES completion:nil];
//        [pickerController release];
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    self.imageOriginal = image;
    [imageView setImage:imageOriginal];
    [self setFilterButton];
    [self dismissViewControllerAnimated:YES completion:nil];
    //[imageView setImage:[self setupFilter:[(UIButton*)sender tag]-50 :imageOriginal]];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
}

@end

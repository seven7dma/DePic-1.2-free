//
//  pianViewController.m
//  DePic
//
//  Created by Pian Ji on 8/22/13.
//  Copyright (c) 2013 Pian Ji. All rights reserved.
//

#import "pianViewController.h"
#import "pianSettingViewController.h"
#import "pianEditViewController.h"
#import "Flurry.h"
#import "FlurryAds.h"

#define CAMERA_TRANSFORM   1.12412

@interface pianViewController ()

@end

@implementation pianViewController
@synthesize viewBackground,view_addview,buyVC,view_buyNow;

+(id)sharedViewController{
    NSString *nibName =  IS_IPHONE5 ? @"pianViewController_iPhone5" : @"pianViewController";
	return [[pianViewController alloc] initWithNibName:nibName bundle:nil] ;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    buyVC = [[BuyViewController alloc] initWithNibName:@"BuyViewController" bundle:Nil];
	// Do any additional setup after loading the view, typically from a nib.
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    view_buyNow.hidden = YES;
//    _pickerController = [[UIImagePickerController alloc] init];
//	_pickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
//	_pickerController.delegate = self;
//	_pickerController.showsCameraControls = NO;
//	_pickerController.allowsEditing = NO;
//    _pickerController.wantsFullScreenLayout = YES;
//    _pickerController.cameraViewTransform = CGAffineTransformScale(_pickerController.cameraViewTransform, CAMERA_TRANSFORM, CAMERA_TRANSFORM);
//	[self.view addSubview:_pickerController.view];
//	[self.view sendSubviewToBack:_pickerController.view];
    
    
    [FlurryAds setAdDelegate:self];
    [FlurryAds fetchAndDisplayAdForSpace:@"pianViewController" view:view_addview size:BANNER_BOTTOM];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)actionMore:(id)sender{
    [[Chartboost sharedChartboost] showMoreApps];
}

- (IBAction)mFrameSelect:(id)sender{
    
    if ([(UIButton*)sender tag]>3) {
        
        //[self.navigationController presentViewController:buyVC animated:YES completion:NULL];
        //[self presentViewController:self.view_buyNow animated:YES completion:NULL];
        //[view_buyNow removeFromSuperview];
        //[self.view addSubview:view_buyNow];
        view_buyNow.hidden= NO;
        view_buyNow.alpha = 0.0;
        [self.view bringSubviewToFront:view_buyNow];
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.7];
        [view_buyNow setAlpha:1.0];
        [UIView commitAnimations];
        
        
        return;
    }
    [self imagePickerControllerDidCancel:_pickerController];
    pianEditViewController *viewController = [pianEditViewController sharedEditViewController];
    [viewController setBtnTag:[(UIButton*)sender tag]];
    [self.navigationController pushViewController:viewController animated:YES];
    //[self presentViewController:viewController animated:YES completion:nil];
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

-(IBAction)actionSetting:(id)sender{
    [self imagePickerControllerDidCancel:_pickerController];
    pianSettingViewController *viewController = [pianSettingViewController sharedSettingViewController];
    [self.navigationController pushViewController:viewController animated:YES];
}

-(IBAction)actionSplimage:(id)sender{

    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://itunes.apple.com/us/app/splimage-shoot-it.-splice/id608308710?mt=8"]];
    
    //[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"splimage-shoot-it.-splice://"]];
}

-(IBAction)actionTwitter:(id)sender{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"twitter://user?id=1470462277"]];;
}

-(IBAction)actionInstagram:(id)sender{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"instagram://user?username=depicapp"]];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    [picker dismissViewControllerAnimated:YES completion:nil];
    [picker.view removeFromSuperview];
//    [picker release];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
    [picker.view removeFromSuperview];
//    [picker release];
}

@end

//
//  pianViewController.h
//  DePic
//
//  Created by Pian Ji on 8/22/13.
//  Copyright (c) 2013 Pian Ji. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Chartboost.h"
#import "BuyViewController.h"

@interface pianViewController : UIViewController<UINavigationControllerDelegate, UIImagePickerControllerDelegate, ChartboostDelegate>{
    
    UIImagePickerController *_pickerController;
    UIView *view_addview;
    
    BuyViewController *buyVC;
    UIView *view_buyNow;
}

@property (nonatomic, retain) IBOutlet UIView *viewBackground;
@property (nonatomic, strong) IBOutlet UIView *view_addview;
@property (nonatomic, strong) BuyViewController *buyVC;
@property (nonatomic, strong) IBOutlet UIView *view_buyNow;

+(id)sharedViewController;

- (IBAction)mFrameSelect:(id)sender;

-(IBAction)actionSetting:(id)sender;

-(IBAction)actionSplimage:(id)sender;

-(IBAction)actionTwitter:(id)sender;

-(IBAction)actionInstagram:(id)sender;

-(IBAction)actionMore:(id)sender;

- (IBAction)btn_buyOptionClickd : (id)sender;

@end

//
//  pianSettingViewController.h
//  DepicPhoto
//
//  Created by LimingZhang on 8/9/13.
//  Copyright (c) 2013 PianJi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RKCropImageController.h"
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>


@interface pianSettingViewController : UIViewController<UIActionSheetDelegate, UIDocumentInteractionControllerDelegate, MFMailComposeViewControllerDelegate,MFMessageComposeViewControllerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, RKCropImageViewDelegate>{
    UIActionSheet *actionWatermark;
    
    UIImagePickerController *_backPickerContoller;
    
    UIView *view_addview;
}

@property (nonatomic,strong)IBOutlet UIView *view_addview;


+(id)sharedSettingViewController;

-(IBAction)actionBack:(id)sender;

-(IBAction)actionRateus:(id)sender;

-(IBAction)actionShareApplication:(id)sender;

-(IBAction)actionRestorePurchase:(id)sender;

-(IBAction)actionCustomWaterMark:(id)sender;


@end

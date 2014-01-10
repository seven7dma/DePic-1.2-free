//
//  pianShareViewController.h
//  DepicPhoto
//
//  Created by LimingZhang on 8/10/13.
//  Copyright (c) 2013 PianJi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>

@interface pianShareViewController : UIViewController<UIDocumentInteractionControllerDelegate, MFMailComposeViewControllerDelegate,MFMessageComposeViewControllerDelegate>{
    IBOutlet UIScrollView *scrollView;
}

@property (nonatomic, retain) UIImage *imageShare;

@property (nonatomic,retain) UIDocumentInteractionController *docController;

+(id)sharedShareViewController;

-(IBAction)actionDone:(id)sender;
-(IBAction)actionCancel:(id)sender;

-(IBAction)actionFacebook:(id)sender;
-(IBAction)actionTwitter:(id)sender;
-(IBAction)actionInstagram:(id)sender;
-(IBAction)actionTumblr:(id)sender;
-(IBAction)actionSavePhoto:(id)sender;
-(IBAction)actionMMS:(id)sender;
-(IBAction)actionEmail:(id)sender;

@end

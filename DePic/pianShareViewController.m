//
//  pianShareViewController.m
//  DepicPhoto
//
//  Created by LimingZhang on 8/10/13.
//  Copyright (c) 2013 PianJi. All rights reserved.
//

#import "pianShareViewController.h"
#import <Twitter/Twitter.h>
#import <Accounts/Accounts.h>
#import <Social/Social.h>

#import "SHKFacebook.h"
#import "SHKTwitter.h"
#import "SHKMail.h"
#import "SHKTumblr.h"
#import "pianAppDelegate.h"

@interface pianShareViewController ()

@end

@implementation pianShareViewController
@synthesize imageShare;
@synthesize docController;

+(id)sharedShareViewController{
    NSString *nibName =  IS_IPHONE5 ? @"pianShareViewController_iPhone5" : @"pianShareViewController";
	return [[pianShareViewController alloc] initWithNibName:nibName bundle:nil] ;
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
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
    if (IS_IPHONE5) {
        [scrollView setContentSize:CGSizeMake(320, 540)];
    }else{
        [scrollView setContentSize:CGSizeMake(320, 480)];
    }
    // Do any additional setup after loading the view from its nib.
}

-(void)viewWillAppear:(BOOL)animated{
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)actionDone:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)actionCancel:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}


-(IBAction)actionFacebook:(id)sender{
    if([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) {
        SLComposeViewController *controller = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
        [controller setInitialText:@"#DePic"];
//        controller set
        [controller addImage:imageShare];
        [self presentViewController:controller animated:YES completion:Nil];
    }
}

-(IBAction)actionTwitter:(id)sender{
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
    {
        SLComposeViewController *tweetSheet = [SLComposeViewController
                                               composeViewControllerForServiceType:SLServiceTypeTwitter];
        [tweetSheet setInitialText:@"#DePic"];
        [tweetSheet addImage:imageShare];
        [self presentViewController:tweetSheet animated:YES completion:nil];
    }
}

-(IBAction)actionInstagram:(id)sender{
    if (self.docController) {
        [self.docController dismissMenuAnimated:NO];
        docController = nil;
    }
    
    NSURL *instagramURL = [NSURL URLWithString:@"instagram://app"];
    if ([[UIApplication sharedApplication] canOpenURL:instagramURL]) {
        NSString *documentsDirectory = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
        NSString *savedImagePath = [documentsDirectory stringByAppendingPathComponent:@"Image.igo"];
        NSData *imageData = UIImagePNGRepresentation(imageShare);
        [imageData writeToFile:savedImagePath atomically:YES];
        NSURL *imageUrl = [NSURL fileURLWithPath:savedImagePath];
        NSLog(@"%@",imageUrl);
        docController = [[UIDocumentInteractionController alloc] init];
        docController.delegate = self;
        docController.UTI = @"com.instagram.exclusivegram";
        docController.URL = imageUrl;
        
        [docController presentOpenInMenuFromRect:CGRectZero inView:self.view animated:YES];
    }

}

-(IBAction)actionTumblr:(id)sender{
    SHKItem *item = [SHKItem image:imageShare title:@"#DePic"];
    SHKTumblr *sharer = [[SHKTumblr alloc] init] ;
//    SHKTumblr *sharer = [[[SHKTumblr alloc] init] autorelease];
    pianAppDelegate* deleg = (pianAppDelegate*)([UIApplication sharedApplication].delegate);
    sharer.shareDelegate = deleg;
    [sharer loadItem:item];
    [sharer share];
}

-(IBAction)actionSavePhoto:(id)sender{
    
    UIImageWriteToSavedPhotosAlbum(imageShare,nil,nil,nil);
}

-(IBAction)actionMMS:(id)sender{
    MFMessageComposeViewController *picker = [[MFMessageComposeViewController alloc] init];
    
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.persistent = YES;
    pasteboard.image = imageShare;
    
//    NSString *phoneToCall = @"sms:";
//    NSString *phoneToCallEncoded = [phoneToCall stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
//    NSURL *url = [[NSURL alloc] initWithString:phoneToCallEncoded];
//    [[UIApplication sharedApplication] openURL:url];
    
    
    if([MFMessageComposeViewController canSendText]) {
        NSMutableString *emailBody = [[NSMutableString alloc] initWithString:@"Check out this photo I made with DePic iPhone app - http://bit.ly/18yDNQ7"];
        picker.messageComposeDelegate = self;
        //picker.recipients = [NSArray arrayWithObject:@"123456789"];
        [picker setBody:emailBody];// your recipient number or self for testing
        picker.body = emailBody;
        NSLog(@"Picker -- %@",picker.body);
        [self presentViewController:picker animated:YES completion:nil];
        NSLog(@"SMS fired");
    }
}

-(IBAction)actionEmail:(id)sender{
    if ([MFMailComposeViewController canSendMail])
    {
        MFMailComposeViewController *mailer = [[MFMailComposeViewController alloc] init];
        mailer.mailComposeDelegate = self;
        [mailer setSubject:@"DePic"];
        NSArray *toRecipients = [NSArray arrayWithObjects:@"", nil];
        [mailer setToRecipients:toRecipients];
        NSData *imageData = UIImagePNGRepresentation(imageShare);
        [mailer addAttachmentData:imageData mimeType:@"image/png" fileName:@"mobiletutsImage"];
        NSString *emailBody = @"Check out this photo I made with DePic iPhone app - http://bit.ly/18yDNQ7";
        [mailer setMessageBody:emailBody isHTML:NO];
        [self presentViewController:mailer animated:TRUE completion:nil];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Failure"
                                                        message:@"Your device doesn't support the composer sheet"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles: nil];
        [alert show];
    }

}

#pragma mark  - mailcomposer delegate

- (void)mailComposeController:(MFMailComposeViewController*)controller
          didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
	NSString *feedbackMsg;
	// Notifies users about errors associated with the interface
	switch (result)
	{
		case MFMailComposeResultCancelled:
			feedbackMsg = @"Mail sending canceled";
			break;
		case MFMailComposeResultSaved:
			feedbackMsg = @"Mail saved";
			break;
		case MFMailComposeResultSent:
			feedbackMsg = @"Mail sent";
			break;
		case MFMailComposeResultFailed:
			feedbackMsg = @"Mail sending failed";
			break;
		default:
			feedbackMsg = @"Mail not sent";
			break;
	}
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                    message:feedbackMsg
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles: nil];
    [alert show];
//    [alert release];
    
	[self dismissViewControllerAnimated:YES completion:NULL];
}

// -------------------------------------------------------------------------------
//	messageComposeViewController:didFinishWithResult:
//  Dismisses the message composition interface when users tap Cancel or Send.
//  Proceeds to update the feedback message field with the result of the
//  operation.
// -------------------------------------------------------------------------------
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller
                 didFinishWithResult:(MessageComposeResult)result
{
	NSString *feedbackMsg;
	// Notifies users about errors associated with the interface
	switch (result)
	{
		case MessageComposeResultCancelled:
			feedbackMsg = @"MMS sending canceled";
			break;
		case MessageComposeResultSent:
			feedbackMsg = @"MMS sent";
			break;
		case MessageComposeResultFailed:
			feedbackMsg = @"MMS sending failed";
			break;
		default:
			feedbackMsg = @"MMS not sent";
			break;
	}
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                    message:feedbackMsg
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles: nil];
    [alert show];
//    [alert release];
    
	[self dismissViewControllerAnimated:YES completion:NULL];
}

@end

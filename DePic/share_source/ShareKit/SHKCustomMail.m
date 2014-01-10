//
//  SHKCustomMail.m
//  POPCard
//
//  Created by Cai DaRong on 6/15/13.
//  Copyright (c) 2013 Cai DaRong. All rights reserved.
//

#import "SHKCustomMail.h"
#import "SHKConfiguration.h"

@interface SHKCustomMail ()

@end

@implementation SHKCustomMail

@synthesize senderMail, recipientMail;

- (BOOL) sendMail
{
	MFMailComposeViewController *mailController = [[[MFMailComposeViewController alloc] init] autorelease];
	if (!mailController) {
		// e.g. no mail account registered (will show alert)
		[[SHK currentHelper] hideCurrentViewControllerAnimated:YES];
		return YES;
	}
	
    [self retain]; //must retain, because mailController does not retain its delegates. Released in callback.
	mailController.mailComposeDelegate = self;
	mailController.navigationBar.tintColor = SHKCONFIG_WITH_ARGUMENT(barTintForView:,mailController);
	
	NSString *body = self.item.text;
	BOOL isHTML = self.item.isMailHTML;
	NSString *separator = (isHTML ? @"<br/><br/>" : @"\n\n");
    
	if (body == nil)
	{
		body = @"";
		
		if (self.item.URL != nil)
		{
			NSString *urlStr = [self.item.URL.absoluteString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
			
			if (isHTML)
				body = [body stringByAppendingFormat:@"%@%@", separator, urlStr];
			else
				body = urlStr;
		}
		
		if (self.item.file)
		{
			NSString *attachedStr = SHKLocalizedString(@"Attached: %@", self.item.title ? self.item.title : self.item.file.filename);
			
			if (isHTML)
				body = [body stringByAppendingFormat:@"%@%@", separator, attachedStr];
			else
				body = attachedStr;
		}
		
		// fallback
		if (body == nil)
			body = @"";
		
		// sig
		if (self.item.mailShareWithAppSignature)
		{
			body = [body stringByAppendingString:separator];
			body = [body stringByAppendingString:SHKLocalizedString(@"Sent from %@", SHKCONFIG(appName))];
		}
	}
	
	if (self.item.file)
		[mailController addAttachmentData:self.item.file.data mimeType:self.item.file.mimeType fileName:self.item.file.filename];
	
	NSArray *toRecipients = self.item.mailToRecipients;
    if (toRecipients)
		[mailController setToRecipients:toRecipients];
	
	if (self.item.image){
        
        CGFloat jpgQuality = self.item.mailJPGQuality;
        [mailController addAttachmentData:UIImageJPEGRepresentation(self.item.image, jpgQuality) mimeType:@"image/jpeg" fileName:@"Image.jpg"];
	}
	
	[mailController setSubject:self.item.title];
	[mailController setMessageBody:body isHTML:isHTML];
	
	[[SHK currentHelper] showViewController:mailController];
	
	return YES;
}


@end

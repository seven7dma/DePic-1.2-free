
//
//  SCShareConfigurator.m
//  SplitCamera
//
//  Created by Cai DaRong on 10/2/12.
//  Copyright (c) 2012 Hongji. All rights reserved.
//

#import "SCShareConfigurator.h"

@implementation SCShareConfigurator

// Application
- (NSString*)appName {
	return @"DePic";
}

- (NSString*)appURL {
	return @"http://www.splimage.com";
}

// Facebook
- (NSString*)facebookAppId {
	return @"1416886671859876";
}

- (NSString*)facebookLocalAppId {
	return @"";
}

// Twitter
- (NSNumber*)forcePreIOS5TwitterAccess {
	return [NSNumber numberWithBool:false];
}

- (NSString*)twitterConsumerKey {
	return @"e8c6lXAW8ZeH5RE2NVr9NQ";
}

- (NSString*)twitterSecret {
	return @"G9In3L2gS7glM8sArPqZYWGLGPe53AohkUVvgltD1o";
}

- (NSString*)twitterCallbackUrl {
	return @"http://www.splimage.com";
}

- (NSNumber*)twitterUseXAuth {
	return [NSNumber numberWithInt:0];
}

- (NSString*)twitterUsername {
	return @"";
}

//Tumblr

- (NSString*)tumblrConsumerKey {
	return @"0uUXNEXrDtj0rnymPZ963lVhgvk1lu2XzkP8ellEca5H5cLPsc";
}

- (NSString*)tumblrSecret {
	return @"TFAMk7qUWTyzhFHRGXV8avQo3rgGRVeVaauovwMdxionoNSh7n";
}

// UI
- (NSString*)barStyle {
	return @"UIBarStyleBlack";
}

- (UIColor*)barTintForView:(UIViewController*)vc {
	
    if ([NSStringFromClass([vc class]) isEqualToString:@"SHKTwitter"])
        return [UIColor colorWithRed:0 green:151.0f/255 blue:222.0f/255 alpha:1];
    
    if ([NSStringFromClass([vc class]) isEqualToString:@"SHKFacebook"])
        return [UIColor colorWithRed:59.0f/255 green:89.0f/255 blue:152.0f/255 alpha:1];
    
    return nil;
}

@end

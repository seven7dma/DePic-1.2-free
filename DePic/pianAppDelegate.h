//
//  pianAppDelegate.h
//  DePic
//
//  Created by Pian Ji on 8/22/13.
//  Copyright (c) 2013 Pian Ji. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SHKSharer.h"
#import "SHKSharerDelegate.h"
#import <AdSupport/AdSupport.h>

#import "Chartboost.h"
#import "Flurry.h"


@class pianViewController;

@interface pianAppDelegate : UIResponder <UIApplicationDelegate, UINavigationControllerDelegate, SHKSharerDelegate, ChartboostDelegate>{
    
    NSTimer *logoutTimer;
    
    SHKSharerDelegate *shareDelegate;
   
}

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) UINavigationController *navController;

@end

//
//  pianAppDelegate.m
//  DePic
//
//  Created by Pian Ji on 8/22/13.
//  Copyright (c) 2013 Pian Ji. All rights reserved.
//

#import "pianAppDelegate.h"
#import "Global.h"
#import "pianViewController.h"

#import "SHK.h"
#import "SHKActivityIndicator.h"
#import "SHKSharer.h"
#import "SCShareConfigurator.h"
#import "SHKConfiguration.h"
#import "SHKFacebook.h"
#import "SHKTwitter.h"
#import "SHKTumblr.h"
#import "SHKMail.h"


@implementation pianAppDelegate
@synthesize navController,buyVC;

- (void)dealloc
{
//    [_window release];
//    [shareDelegate release];
//    [navController release];
//    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [[GlobalData sharedData] loadInitData];
    //[RevMobAds startSessionWithAppID:REVMOB_ID];
    
    [Flurry setCrashReportingEnabled:YES];
    [Flurry startSession:@"MTHHJFSHRYMPVFKTX77W"];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
//    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    // Override point for customization after application launch.
    pianViewController *viewController = [pianViewController sharedViewController];
    self.navController = [[UINavigationController alloc] initWithRootViewController:viewController];
    
    buyVC = [[BuyViewController alloc] initWithNibName:@"BuyViewController" bundle:Nil];
    //[[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"topbar_bg.png"] forBarMetrics:UIBarMetricsDefault];
    self.navController.navigationBarHidden = YES;
    
    self.window.rootViewController = self.navController;
    [self.window makeKeyAndVisible];
    
    DefaultSHKConfigurator *configurator = [[SCShareConfigurator alloc] init];
    [SHKConfiguration sharedInstanceWithConfigurator:configurator];
    shareDelegate = [[SHKSharerDelegate alloc] init];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    Chartboost *cb = [Chartboost sharedChartboost];
    
    cb.appId = @"5222abc117ba471f29000004";
    cb.appSignature = @"9bf7e590627f51dbce0fffc398da7cb46706494c";
    
    cb.delegate = self;
    
    // Begin a user session. This should be done once per boot
    [cb startSession];
    
    [cb cacheInterstitial:@"After level 1"];
    [cb cacheInterstitial:@"Pause screen"];
   
    // Cache the more apps page so it's loaded & ready
    [cb cacheMoreApps];
    
    // Pro Tip: Use code below to Print IFA (Identifier for Advertising) in Output section. iOS 6+ devices only.
    NSString* ifa = [[[NSClassFromString(@"ASIdentifierManager") sharedManager] advertisingIdentifier] UUIDString];
    ifa = [[ifa stringByReplacingOccurrencesOfString:@"-" withString:@""] lowercaseString];
    NSLog(@"IFA: %@",ifa);
    
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    [SHK logoutOfAll];
	
//	[self.navController release];
	
//	[_window release];
}

- (void)logoutOfAllServices
{
    [SHK logoutOfAll];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)orientation
{
    if (orientation == UIInterfaceOrientationPortrait)
        return YES;
    return NO;
}

// Sharer delegate
- (void)sharerStartedSending:(SHKSharer *)sharer
{
	[shareDelegate sharerStartedSending:sharer];
}

- (void)delayedLogout
{
    if (logoutTimer != nil) {
        if ([logoutTimer isValid]) {
            [logoutTimer invalidate];
        }
        logoutTimer = nil;
    }
//    logoutTimer = [[NSTimer scheduledTimerWithTimeInterval:15 target:self selector:@selector(logoutOfAllServices) userInfo:nil repeats:NO] retain];
    logoutTimer = [NSTimer scheduledTimerWithTimeInterval:15 target:self selector:@selector(logoutOfAllServices) userInfo:nil repeats:NO];
}

- (void)sharerFinishedSending:(SHKSharer *)sharer
{
    if ([sharer isKindOfClass:[SHKFacebook class]]) {
        [[SHKActivityIndicator currentIndicator] displayCompleted:@"Facebook post successful!"];
    }
    else if ([sharer isKindOfClass:[SHKTwitter class]]) {
        [[SHKActivityIndicator currentIndicator] displayCompleted:@"Twitter post successful!"];
    }
    else if ([sharer isKindOfClass:[SHKMail class]]) {
        [[SHKActivityIndicator currentIndicator] displayCompleted:@"Email sent!"];
    }else if ([sharer isKindOfClass:[SHKTumblr class]]) {
        [[SHKActivityIndicator currentIndicator] displayCompleted:@"Thumblr post successful!"];
    }
    else {
        [[SHKActivityIndicator currentIndicator] displayCompleted:@"Saved!"];
    }
    [self delayedLogout];
}

- (void)sharerAuthDidFinish:(SHKSharer *)sharer success:(BOOL)success
{
    [shareDelegate sharerAuthDidFinish:sharer success:success];
}

- (void)sharer:(SHKSharer *)sharer failedWithError:(NSError *)error shouldRelogin:(BOOL)shouldRelogin
{
    [shareDelegate sharer:sharer failedWithError:error shouldRelogin:shouldRelogin];
    [self delayedLogout];
}

- (void)sharerCancelledSending:(SHKSharer *)sharer
{
    [shareDelegate sharerCancelledSending:sharer];
    [self delayedLogout];
}

- (void)sharerShowBadCredentialsAlert:(SHKSharer *)sharer
{
    [shareDelegate sharerShowBadCredentialsAlert:sharer];
}

- (void)sharerShowOtherAuthorizationErrorAlert:(SHKSharer *)sharer
{
    [shareDelegate sharerShowOtherAuthorizationErrorAlert:sharer];
}

- (void)didDismissMoreApps {
    NSLog(@"dismissed more apps page, re-caching now");
    
    [[Chartboost sharedChartboost] cacheMoreApps];
}

- (BOOL)shouldRequestInterstitialsInFirstSession {
    return YES;
}

- (void)didFailToLoadMoreApps {
    NSLog(@"failure to load more apps");
}


- (void)proClicked{
    
}

@end

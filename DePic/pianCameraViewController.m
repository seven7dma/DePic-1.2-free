//
//  pianCameraViewController.m
//  DePic
//
//  Created by Pian Ji on 9/11/13.
//  Copyright (c) 2013 Pian Ji. All rights reserved.
//

#import "pianCameraViewController.h"

@interface pianCameraViewController ()

@end

@implementation pianCameraViewController
@synthesize originalImage;
@synthesize piandelegate;

+(id)sharedViewController{
    NSString *nibName =  IS_IPHONE5 ? @"pianCameraViewController_iPhone5" : @"pianCameraViewController";
	return [[pianCameraViewController alloc] initWithNibName:nibName bundle:nil] ;
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
    
    self.navigationController.navigationBarHidden = YES;
    

    [imageView setImage:originalImage];
    
    [scrollView setContentSize:CGSizeMake(imageView.frame.size.width + 5.0f, imageView.frame.size.height + 5.0f)];
    
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

#pragma mark delegate

-(IBAction)aMethod:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
    [self.navigationController setToolbarHidden:YES];
    if( [piandelegate respondsToSelector : @selector(actionUse:) ] )
    {
        [piandelegate actionUse:sender];
    }
}

-(IBAction)bMethod:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
    if( [piandelegate respondsToSelector : @selector(actionBack:) ] )
    {
        [piandelegate actionBack:sender];
    }
}

@end

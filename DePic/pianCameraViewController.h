//
//  pianCameraViewController.h
//  DePic
//
//  Created by Pian Ji on 9/11/13.
//  Copyright (c) 2013 Pian Ji. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol pianCameraViewDelegate;

@interface pianCameraViewController : UIViewController<UINavigationControllerDelegate>{
    IBOutlet UIImageView *imageView;
    IBOutlet UIScrollView *scrollView;
}
@property (nonatomic, assign) id<pianCameraViewDelegate> piandelegate;

@property (nonatomic, retain) UIImage *originalImage;

+(id)sharedViewController;

-(IBAction)aMethod:(id)sender;

-(IBAction)bMethod:(id)sender;

@end

@protocol pianCameraViewDelegate <NSObject>
-(void)actionBack : (id)sender;
-(void)actionUse : (id)sender;
@end

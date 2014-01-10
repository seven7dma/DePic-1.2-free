//
//  pianBackViewController.h
//  DePic
//
//  Created by Pian Ji on 9/20/13.
//  Copyright (c) 2013 Pian Ji. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GPUImage.h"
#import "Global.h"

@protocol pianBackDelegate;

@interface pianBackViewController : UIViewController<UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate>{
    NSArray* arrayFilter;
}

@property (nonatomic, assign) id<pianBackDelegate> filterDelegate;

@property (nonatomic, retain) UIImage* imageOriginal;
@property (nonatomic, retain) UIImage* imageFiltered;

@property (nonatomic, retain) IBOutlet UIScrollView *filterView;
@property (nonatomic, retain) IBOutlet UIImageView *imageView;
@property (nonatomic, retain) IBOutlet UIView *viewImage;


+(id)sharedViewController;

- (IBAction)actionDone:(id)sender;

- (IBAction)actionFilterButton:(id)sender;


@end

@protocol pianBackDelegate <NSObject>

-(void)setFileteredBackImage : (UIImage*)image;

@end

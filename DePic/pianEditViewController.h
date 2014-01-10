//
//  pianEditViewController.h
//  DePic
//
//  Created by Pian Ji on 8/22/13.
//  Copyright (c) 2013 Pian Ji. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "pianCTView.h"
#import "pianTextView.h"
#import "QBImagePickerController.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "ILColorPickerView.h"
#import "pianShareViewController.h"
#import "pianCameraViewController.h"
#import "pianBackViewController.h"
#import "Chartboost.h"

#import "Global.h"

@interface pianEditViewController : UIViewController<ChartboostDelegate, pianCTViewDelegate, pianBackDelegate, pianCameraViewDelegate, pianTextViewDelegate, QBImagePickerControllerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate, ILColorPickerViewDelegate, UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate, UIGestureRecognizerDelegate>{
    
    NSMutableArray *arrayFrameView;
    NSMutableArray *arrayCameraImage;
    
    NSArray* arrayFilter;
    
    UIImage *cameraImage;
    
    CGPoint _priorPoint;
    UIImageView *draggableImageView;
    
    int frameIndex;
    int frameCount;
    
    int textIndex;
    int textCount;
    
    int cameraIndex;
    
    NSArray *familyNames;
    NSArray *fontNames;
    
    UIImagePickerController *_pickerController;
    UIImagePickerController *_backPickerContoller;
    UIImagePickerController *_framePickerController;
    UIImagePickerController *_cameraPickerController;
    UIImagePickerController *_singlePickerController;
    
    pianCameraViewController *cameraViewController;
    
    UIButton *buttonMultilply;
    
    UIActionSheet *actionChangeBack;
    
    UIView *view_addView;
    UIView *view_buyNow;
}

@property int btnTag;
@property BOOL multiSelect;
@property BOOL isBackground;

@property (nonatomic,strong)IBOutlet UIView *view_addView;

@property (nonatomic, retain) UIImage *imageFilter;
@property (nonatomic, retain) NSMutableArray *arrayImageFilter;

@property (nonatomic, retain) pianCTView *currentFrame;
@property (nonatomic, retain) UIButton *currentFilterButton;

@property (nonatomic, assign) QBImagePickerController *multiImagePickerController;
@property (nonatomic, assign) IBOutlet ILColorPickerView *colorPicker;

@property (nonatomic, retain) IBOutlet UIView *viewTemplate;
@property (nonatomic, retain) IBOutlet UIView *viewPopup;
@property (nonatomic, retain) IBOutlet UIView *viewSlider;
@property (nonatomic, retain) IBOutlet UIView *viewTopbar;
@property (nonatomic, retain) IBOutlet UIView *viewTempBack;
@property (nonatomic, retain) IBOutlet UIView *viewTextAdjust;
@property (nonatomic, retain) IBOutlet UIView *viewWatermark;
@property (nonatomic, retain) IBOutlet UIView *viewChange;
@property (nonatomic, retain) IBOutlet UIView *viewFilter;
@property (nonatomic, retain) IBOutlet UIScrollView *scrollviewFilter;

@property (nonatomic, retain) IBOutlet UIView *viewCameraBar;
@property (nonatomic, retain) IBOutlet UIButton *btnCameraContorl;
@property (nonatomic, retain) IBOutlet UIButton *btnCameraAuto;

@property (nonatomic, retain) IBOutlet UIImageView *imgBackground;
@property (nonatomic, retain) IBOutlet UIImageView *imgTemplateBack;
@property (nonatomic, retain) IBOutlet UIImageView *imgTempBack;
@property (nonatomic, retain) IBOutlet UIImageView *imgWatermark;
@property (nonatomic, retain) IBOutlet UISlider *sliderTransparent;

@property (nonatomic, retain) IBOutlet UISlider *sliderFont;

@property (nonatomic, retain) IBOutlet UITableView *tableFont;
@property (nonatomic, strong) IBOutlet UIView *view_buyNow;

+(id)sharedEditViewController;

-(IBAction)mChangeSelect:(id)sender;

-(IBAction)mCameraSelect:(id)sender;

-(IBAction)mGallerySelect:(id)sender;

-(IBAction)actionFilter:(id)sender;

-(IBAction)actionSlider:(id)sender;

-(IBAction)actionTransparentSliderChanged:(UISlider*)sender;

- (IBAction)actionDone:(id)sender;

-(IBAction)actionShare:(id)sender;

-(IBAction)actionText:(id)sender;

-(IBAction)actionTextDone:(id)sender;

-(IBAction)actionLeft:(id)sender;

-(IBAction)actionRight:(id)sender;

-(IBAction)actionCenter:(id)sender;

-(IBAction)actionFontSliderChanged:(UISlider*)sender;

-(IBAction)actionFont:(id)sender;

-(IBAction)actionFontColor:(id)sender;

-(IBAction)actionTextPlus:(id)sender;

-(IBAction)actionPro:(id)sender;

-(IBAction)actionMore:(id)sender;

-(IBAction)actionTakePhoto:(id)sender;

-(IBAction)actionCancel:(id)sender;

-(IBAction)actionCameraDone:(id)sender;

-(IBAction)actionCameraControl:(id)sender;

-(IBAction)actionCameraAuto:(id)sender;

-(IBAction)actionChangeTemplate:(id)sender;

-(IBAction)actionChangeBackground:(id)sender;

- (IBAction)actionFilterButton:(id)sender;

@end

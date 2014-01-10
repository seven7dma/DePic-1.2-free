//
//  pianTextView.h
//  DePic
//
//  Created by Pian Ji on 9/3/13.
//  Copyright (c) 2013 Pian Ji. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol pianTextViewDelegate;

@interface pianTextView : UIView<UITextFieldDelegate>

@property (nonatomic, assign) id<pianTextViewDelegate> piandelegate;

@property (nonatomic, retain) UITextField *_tfText;
@property (nonatomic, retain) UILabel *_lblText;
@property (nonatomic, retain) UIButton *_btnClose;
@property (nonatomic, retain) UIButton *_btnResize;
@property bool bTap;

-(void)setTextBorder : (BOOL)bShow;

@end

@protocol pianTextViewDelegate <NSObject>
- (void)actionTextDelegate : (int)mTag;
@end

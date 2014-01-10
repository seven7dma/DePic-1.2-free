//
//  pianCTView.h
//  DepicPhoto
//
//  Created by PianJi on 8/3/13.
//  Copyright (c) 2013 PianJi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@protocol pianCTViewDelegate;


@interface pianCTView : UIView<UIGestureRecognizerDelegate>{

}
@property (nonatomic, assign) id<pianCTViewDelegate> piandelegate;

@property (nonatomic, retain) UIImageView *img_back;
@property (nonatomic, retain) UIButton *button;

- (void) setImage : (UIImage*)image;

- (void) moveTo:(CGPoint)destination duration:(float)secs option:(UIViewAnimationOptions)option;

@end

@protocol pianCTViewDelegate <NSObject>
- (void)actionClick:(id)sender;
@end

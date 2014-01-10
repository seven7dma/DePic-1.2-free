//
//  pianTextView.m
//  DePic
//
//  Created by Pian Ji on 9/3/13.
//  Copyright (c) 2013 Pian Ji. All rights reserved.
//

#import "pianTextView.h"
#import <QuartzCore/QuartzCore.h>
#import "Global.h"

@implementation pianTextView
@synthesize _btnClose;
@synthesize _btnResize;
@synthesize _lblText;
@synthesize _tfText;
@synthesize piandelegate;
@synthesize bTap;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        bTap = false;
        
        [self setBackgroundColor:[UIColor clearColor]];
        
        _tfText = [[UITextField alloc] initWithFrame:CGRectMake(10.0f, 10.0f, self.frame.size.width - 10.0f, self.frame.size.height - 10.0f)];
        _tfText.delegate = self;
        [_tfText setHidden:YES];
        [_tfText setBackgroundColor:[UIColor clearColor]];
        [_tfText setAutocorrectionType:UITextAutocorrectionTypeNo];
        [_tfText becomeFirstResponder];
        [self addSubview:_tfText];
        
        _lblText = [[UILabel alloc] initWithFrame:CGRectMake(10.0f, 10.0f, self.frame.size.width - 10.0f, self.frame.size.height - 10.0f)];
        [_lblText setBackgroundColor:[UIColor clearColor]];
        [_lblText setShadowColor:[UIColor blackColor]];
        [_lblText setShadowOffset:CGSizeMake(1.0f, 1.0f)];

        [self addSubview:_lblText];
        
        _btnClose = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [_btnClose setImage:[UIImage imageNamed:@"multiply.png"] forState:UIControlStateNormal];
        [_btnClose setFrame:CGRectMake(-10.0f,-10.0f, 20.0f, 20.0f)];
        [_btnClose setHidden:YES];
        [_btnClose addTarget:self action:@selector(actionDelete:) forControlEvents:UIControlEventTouchUpInside];
        [_btnClose bringSubviewToFront:self];
        [self addSubview:_btnClose];
        
        _btnResize = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [_btnResize setImage:[UIImage imageNamed:@"plus.png"] forState:UIControlStateNormal];
        //[_btnResize setFrame:CGRectMake(- 10.0f,- 10.0f, 20.0f, 20.0f)];
        [_btnResize setHidden:YES];
        //[_btnResize addTarget:self action:@selector(actionDelete:) forControlEvents:UIControlEventTouchUpInside];
        [_btnResize bringSubviewToFront:self];
        [self addSubview:_btnResize];
        
        
        UIPanGestureRecognizer *resizeTap =
        [[UIPanGestureRecognizer alloc] initWithTarget:self
                                                action:@selector(resizePanGesture:)];
        
        [_btnResize addGestureRecognizer:resizeTap];
        
//        [resizeTap release];
        
        UIPanGestureRecognizer *singleFingerTap =
        [[UIPanGestureRecognizer alloc] initWithTarget:self
                                                action:@selector(handlePanGesture:)];
        
        [self addGestureRecognizer:singleFingerTap];
        
//        [singleFingerTap release];
        
        UITapGestureRecognizer *doubleFingerTap =
        [[UITapGestureRecognizer alloc] initWithTarget:self
                                                action:@selector(textDoubleTap:)];
        doubleFingerTap.numberOfTapsRequired = 2;
        
        [self addGestureRecognizer:doubleFingerTap];
        
//        [doubleFingerTap release];
        
        UITapGestureRecognizer *singleTap =
        [[UITapGestureRecognizer alloc] initWithTarget:self
                                                action:@selector(singleTap:)];
        singleTap.numberOfTapsRequired = 1;
        
        [self addGestureRecognizer:singleTap];
        
//        [singleTap release];
        
        _lblText.layer.borderColor = [[UIColor redColor] CGColor];
        _lblText.layer.borderWidth = .0f;
        
    }
    return self;
}

-(void)actionDelete : (id)sender{
    [self removeFromSuperview];
}

-(void)setTextBorder : (BOOL)bShow{
    if (bShow) {
        _lblText.layer.borderWidth = 1.0f;
        [_btnClose setHidden:NO];
        [_btnResize setHidden:NO];
    }else{
        _lblText.layer.borderWidth = 0.0f;
        [_btnClose setHidden:YES];
        [_btnResize setHidden:YES];
    }
}

#pragma mark - tap gesture recognizer

- (void)resizePanGesture : (UIPanGestureRecognizer*)recognizer{
    CGPoint translation = [recognizer translationInView:recognizer.view];
    
    if (_lblText.frame.size.width < 20.0f) {
        
        [_lblText setFrame:CGRectMake(_lblText.frame.origin.x, _lblText.frame.origin.y, 20.0, _lblText.frame.size.height + translation.y)];
        [self setFrame:CGRectMake(self.frame.origin.x , self.frame.origin.y, _lblText.frame.size.width + 20.0f, _lblText.frame.size.height + 20.0f)];
        
        recognizer.view.center=CGPointMake(20.0f, recognizer.view.center.y+ translation.y);
        
        [recognizer setTranslation:CGPointMake(0, 0) inView:recognizer.view];
        
    }else if (_lblText.frame.size.height < 20.0f) {
        
        [_lblText setFrame:CGRectMake(_lblText.frame.origin.x, _lblText.frame.origin.y, _lblText.frame.size.width + translation.x, 20.0f)];
        [self setFrame:CGRectMake(self.frame.origin.x , self.frame.origin.y, _lblText.frame.size.width + 20.0f, _lblText.frame.size.height + 20.0f)];
        
        recognizer.view.center=CGPointMake(recognizer.view.center.x+translation.x, 20.0f);
        
        [recognizer setTranslation:CGPointMake(0, 0) inView:recognizer.view];
        
    }else {
        
        recognizer.view.center=CGPointMake(recognizer.view.center.x+translation.x, recognizer.view.center.y+ translation.y);
        
        [recognizer setTranslation:CGPointMake(0, 0) inView:recognizer.view];
        [_lblText setFrame:CGRectMake(_lblText.frame.origin.x, _lblText.frame.origin.y, _lblText.frame.size.width + translation.x, _lblText.frame.size.height + translation.y)];
        [self setFrame:CGRectMake(self.frame.origin.x , self.frame.origin.y, _lblText.frame.size.width + 20.0f, _lblText.frame.size.height + 20.0f)];
    }
    
    for (int i = 0; i < _globalData.arrayTextView.count; i++) {
        [(pianTextView*)[_globalData.arrayTextView objectAtIndex:i] setTextBorder:NO];
    }
    
    [self setTextBorder:YES];
    
}

- (void)handlePanGesture : (UIPanGestureRecognizer*)recognizer{
    CGPoint translation = [recognizer translationInView:recognizer.view];
    
    recognizer.view.center=CGPointMake(recognizer.view.center.x+translation.x, recognizer.view.center.y+ translation.y);
    
    [recognizer setTranslation:CGPointMake(0, 0) inView:recognizer.view];
    
    for (int i = 0; i < _globalData.arrayTextView.count; i++) {
        [(pianTextView*)[_globalData.arrayTextView objectAtIndex:i] setTextBorder:NO];
    }
    [self setTextBorder:YES];
}

- (void)singleTap:(UITapGestureRecognizer *)recognizer{
    bTap = !bTap;
    
    for (int i = 0; i < _globalData.arrayTextView.count; i++) {
        [(pianTextView*)[_globalData.arrayTextView objectAtIndex:i] setTextBorder:NO];
    }
    [self setTextBorder:bTap];
}

- (void)textDoubleTap:(UITapGestureRecognizer *)recognizer {
    for (int i = 0; i < _globalData.arrayTextView.count; i++) {
        [(pianTextView*)[_globalData.arrayTextView objectAtIndex:i] setTextBorder:NO];
    }    
    [self textFieldShouldReturn:_tfText];
    [self setTextBorder:YES];
}

#pragma mark - textfield delegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
   
    
    [textField resignFirstResponder];
    
//    if( [piandelegate respondsToSelector : @selector(actionTextDelegate:) ] )
//    {
//        [piandelegate actionTextDelegate:self.tag];
//    }
//    
//    [_btnResize setFrame:CGRectMake(_lblText.frame.size.width - 10.0f, _lblText.frame.size.height - 10.0f, 20.0f, 20.0f)];
//    [_lblText setLineBreakMode:NSLineBreakByTruncatingTail];
//    _lblText.numberOfLines = 0;
    
    return TRUE;
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    [_lblText setText:[textField.text stringByReplacingCharactersInRange:range withString:string]];
    [_lblText sizeToFit];
    [self setFrame:CGRectMake(self.frame.origin.x , self.frame.origin.y, _lblText.frame.size.width + 20.0f, _lblText.frame.size.height+ 20.0f)];
    [self setTextBorder:YES];
    return TRUE;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end

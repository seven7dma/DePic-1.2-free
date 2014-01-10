
//
//  pianCTView.m
//  DepicPhoto
//
//  Created by PianJi on 8/3/13.
//  Copyright (c) 2013 PianJi. All rights reserved.
//

#import "pianCTView.h"
#import "pianEditViewController.h"

@implementation pianCTView
@synthesize img_back;
@synthesize piandelegate;
@synthesize button;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
//        img_back = [[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)] autorelease];
        img_back = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)] ;
        [img_back setImage:[UIImage imageNamed:@"img_temp"]];
        img_back.userInteractionEnabled = YES;
        [self addSubview:img_back];
        
        button = [UIButton buttonWithType:UIButtonTypeCustom];
        UIImage *image = [UIImage imageNamed:@"btn_addphoto"];
        [button setImage:[UIImage imageNamed:@"btn_addphoto"] forState:UIControlStateNormal];
        
        [button setCenter:CGPointMake(self.frame.size.width/2, self.frame.size.height/2)];
        [button setFrame:CGRectMake(self.frame.size.width/2 - image.size.width/2  ,self.frame.size.height/2 - image.size.height/2, image.size.width, image.size.height)];
        
        button.tag = 100;
        
        [button addTarget:self action:@selector(aMethod:) forControlEvents:UIControlEventTouchUpInside];
        
        self.layer.shadowColor = [[UIColor blackColor] CGColor];
        self.layer.shadowOffset = CGSizeMake(5, 5);
        self.layer.shadowRadius = 5;
        self.layer.shadowOpacity = 0.5;
        [self addSubview:button];
    }
    return self;
}

- (void) setImage : (UIImage*)image{
    
    [img_back setImage:image];
    if (image !=nil) {
        if (image.size.height / self.frame.size.height >  image.size.width / self.frame.size.width) {
            [img_back setFrame:CGRectMake(0, 0, self.frame.size.width, image.size.height * self.frame.size.width / image.size.width)];
        }else{
            [img_back setFrame:CGRectMake(0, 0, image.size.width * self.frame.size.height / image.size.height, self.frame.size.height)];
        }
    }else{
        [img_back setFrame:CGRectMake(0, 0, 0, 0)];
    }
    
    [self setBackgroundColor:[UIColor clearColor]];
    [self setClipsToBounds:YES];
    
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    [panGesture setDelegate:self];
    
    /* set no of touch for pan gesture*/
    
    [panGesture setMaximumNumberOfTouches:1];
    
    /*  Add gesture to your image. */
    
    [img_back addGestureRecognizer:panGesture];
    
//    [panGesture release];
    
    UIPinchGestureRecognizer *pinch =[[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinch:)];
    [pinch setDelegate:self];
    [img_back addGestureRecognizer:pinch];
//    [pinch release];

}

#pragma mark - pinch gesture
- (void)handlePinch:(UIPinchGestureRecognizer*)recognizer{
    static CGRect initialBounds;
    
    UIView *_view = recognizer.view;
    
    if (recognizer.state == UIGestureRecognizerStateBegan)
    {
        initialBounds = _view.bounds;
    }
    CGFloat factor = [(UIPinchGestureRecognizer *)recognizer scale];
    
    CGAffineTransform zt = CGAffineTransformScale(CGAffineTransformIdentity, factor, factor);
    _view.bounds = CGRectApplyAffineTransform(initialBounds, zt);
    
    if ([recognizer state] == UIGestureRecognizerStateEnded ) {
        [self setPinchImageFit:(UIImageView*)_view];
        [self setImageFit:(UIImageView*)_view];
    }
    
    return;
}
-(void) setPinchImageFit : (UIImageView*)imageFrame{
    static CGRect initialBounds;
    
    CGFloat factor = 1.0f;
    
    
    if (imageFrame.frame.size.width < self.frame.size.width && imageFrame.frame.size.height < self.frame.size.height ) {
        if (self.frame.size.width / imageFrame.frame.size.width > self.frame.size.height / imageFrame.frame.size.height) {
            factor = self.frame.size.width / imageFrame.frame.size.width;
        }else{
            factor = self.frame.size.height / imageFrame.frame.size.height;
        }
    }else if(imageFrame.frame.size.width < self.frame.size.width){
        factor = self.frame.size.width / imageFrame.frame.size.width;
    }else if(imageFrame.frame.size.height < self.frame.size.height){
        factor = self.frame.size.height / imageFrame.frame.size.height;
    }
    
    initialBounds = imageFrame.bounds;

    CGAffineTransform zt = CGAffineTransformScale(CGAffineTransformIdentity, factor, factor);
    imageFrame.bounds = CGRectApplyAffineTransform(initialBounds, zt);
    
    if (factor > 1.0f) {
        [imageFrame setFrame:CGRectMake(0, 0, imageFrame.frame.size.width, imageFrame.frame.size.height)];
    }
    return;
}

#pragma mark - pan gesture
- (void)handlePan:(UIPanGestureRecognizer*)recognizer {
    
    CGPoint translation = [recognizer translationInView:recognizer.view];
    
    if (recognizer.view.frame.size.width == self.frame.size.width) {
        recognizer.view.center=CGPointMake(recognizer.view.center.x+0, recognizer.view.center.y+ translation.y);
    }else if (recognizer.view.frame.size.height == self.frame.size.height){
        recognizer.view.center=CGPointMake(recognizer.view.center.x+translation.x, recognizer.view.center.y+ 0);
    }else{
        recognizer.view.center=CGPointMake(recognizer.view.center.x+translation.x, recognizer.view.center.y+ translation.y);
    }
    
    [recognizer setTranslation:CGPointMake(0, 0) inView:recognizer.view];
    
    if ([recognizer state] == UIGestureRecognizerStateEnded ) {
        [self setImageFit:(UIImageView*)recognizer.view];
    }
}

-(void) setImageFit : (UIImageView*)imageFrame{
    if (imageFrame.frame.origin.x > 0) {
        if (imageFrame.frame.origin.y > 0) {
            [self moveTo:CGPointMake(0, 0) duration:.2 option:0];
        }else if(imageFrame.frame.origin.y + imageFrame.frame.size.height < self.frame.size.height){
            [self moveTo:CGPointMake(0, self.frame.size.height - imageFrame.frame.size.height) duration:.2 option:0];
        }else{
            [self moveTo:CGPointMake(0, imageFrame.frame.origin.y) duration:.2 option:0];
        }
    }else if (imageFrame.frame.origin.y > 0){
        if (imageFrame.frame.origin.x + imageFrame.frame.size.width < self.frame.size.width) {
            [self moveTo:CGPointMake(self.frame.size.width - imageFrame.frame.size.width, 0) duration:.2 option:0];
        }else{
            [self moveTo:CGPointMake(imageFrame.frame.origin.x, 0) duration:.2 option:0];
        }
    }else if (imageFrame.frame.origin.x + imageFrame.frame.size.width < self.frame.size.width){
        if (imageFrame.frame.origin.y + imageFrame.frame.size.height < self.frame.size.height) {
            [self moveTo:CGPointMake(self.frame.size.width - imageFrame.frame.size.width, self.frame.size.height - imageFrame.frame.size.height) duration:.2 option:0];
        }else{
            [self moveTo:CGPointMake(self.frame.size.width - imageFrame.frame.size.width, imageFrame.frame.origin.y) duration:.2 option:0];
        }
    }else if (imageFrame.frame.origin.y + imageFrame.frame.size.height < self.frame.size.height){
        [self moveTo:CGPointMake(imageFrame.frame.origin.x, self.frame.size.height - imageFrame.frame.size.height) duration:.2 option:0];
    }
}

- (void) moveTo:(CGPoint)destination duration:(float)secs option:(UIViewAnimationOptions)option
{
    [UIView animateWithDuration:secs delay:0.0 options:option
                     animations:^{
                         img_back.frame = CGRectMake(destination.x,destination.y, img_back.frame.size.width, img_back.frame.size.height);
                     }
                     completion:nil];
}

- (UIImage *)resizeImageToSize:(CGSize)targetSize image : (UIImage*)image
{
    UIImage *sourceImage = image;
    UIImage *newImage = nil;
    
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    
    if (CGSizeEqualToSize(imageSize, targetSize) == NO) {
        
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if (widthFactor > heightFactor)
            scaleFactor = widthFactor;
        else
            scaleFactor = heightFactor;
        
        scaledWidth  = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        // make image center aligned
        if (widthFactor < heightFactor)
        {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }
        else if (widthFactor > heightFactor)
        {
            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
        }
    }
    
    UIGraphicsBeginImageContext(CGSizeMake(scaledWidth, scaledHeight));
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width  = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    if(newImage == nil)
        NSLog(@"could not scale image");
    
    return newImage ;
}

#pragma mark delegate

-(IBAction)aMethod:(id)sender{
    if( [piandelegate respondsToSelector : @selector(actionClick:) ] )
    {
        [piandelegate actionClick:sender];
    }
}

@end

//
//  GlobalData.h
//  Kitchen Rush
//
//  Created by Xian on 7/21/13.
//  Copyright (c) 2012 HongJi Soft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "pianTextView.h"
#import "CommonMethods.h"

typedef enum
{
    FILTER_ORIGINAL     = 0,
    FILTER_BOOKSTORE,
    FILTER_CITY,
    FILTER_COUNTRY,
    FILTER_FILM,
    FILTER_FOREST,
    FILTER_LAKE,
    FILTER_MOMENT,
    FILTER_NYC,
    FILTER_TEA,
    FILTER_VINTAGE,
    FILTER_1Q84,
    FILTER_BW,
} FILTER_TYPE ;

@interface GlobalData : NSObject

@property (nonatomic, retain) pianTextView *currentTextView;
@property (nonatomic, retain) NSMutableArray *arrayTextView;

@property (nonatomic, strong) UIImage *waterMark;
@property (nonatomic, strong) UIColor *color;
@property (nonatomic, strong) NSString *font;
@property BOOL bCustomWatermark;

@property int align;
@property int size;

+ (id) sharedData;
- (void)loadInitData;

@end

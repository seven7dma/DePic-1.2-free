//
//  GlobalData.m
//  Kitchen Rush
//
//  Created by Xian on 7/21/13.
//  Copyright (c) 2012 HongJi Soft. All rights reserved.
//

#import "GlobalData.h"
#import "Global.h"

GlobalData *_globalData = nil;

@implementation GlobalData

+(id) sharedData
{
	@synchronized(self)
    {
        if (_globalData == nil)
        {
            _globalData = [[self alloc] init]; // assignment not done here
        }		
	}
	
	return _globalData;
}
//==================================================================================

+(id) allocWithZone:(NSZone *)zone
{
    @synchronized(self)
    {
        if (_globalData == nil)
        {
			_globalData = [super allocWithZone:zone];
			
			return _globalData;
        }
    }
	
    return nil; //on subsequent allocation attempts return nil
}

//==================================================================================

-(id) init
{
	if ((self = [super init])) {
		// @todo
	}
	
	return self;
}

//==================================================================================

- (id)copyWithZone:(NSZone *)zone
{
    return self;
}

-(void) loadInitData
{
    self.waterMark = [UIImage imageNamed:@"watermark_depic.png"];
    self.bCustomWatermark = TRUE;
    self.align = 2;
    self.color = [UIColor blackColor];
    self.size = 20.0;
    self.font = @"System";
    self.arrayTextView = [[NSMutableArray alloc] init];
}
@end

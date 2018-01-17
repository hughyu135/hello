//
//  VolumeColor.h
//  ClassTest
//
//  Created by SteveLin on 2015/11/27.
//  Copyright (c) 2015年 hughyu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CVolumeColor : NSObject

/*
-(void) updatePwrBuf:(float)curPwr;
-(float) getPwrMax;
-(float) getPwrMin;
-(int) getRGB:(float)curPwr;

-(int) getColor:(int)colorStrength :(int)index :(int)rgbIndex;
-(void) updateColorRefIndex;
*/

-(CVolumeColor*)init;

-(void)VolumePower:(float)power toColor:(unsigned char *) Red : (unsigned char *) Green : (unsigned char *) Blue;

@end

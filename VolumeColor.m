//
//  VolumeColor.m
//  ClassTest
//
//  Created by SteveLin on 2015/11/27.
//  Copyright (c) 2015年 hughyu. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "VolumeColor.h"

// music power buf
float CurPwrBuf[10] = {0};
const int pwrBufLen = 10;
int IndexPwrBuf = 0;

//int colorStep[5] = {51,102,153,204,255};
//int colorStepIndex = 0;

// 0: value = 0
// 1: main value[102~255] , 2: second value = main value/2,
// 3:[0~second] random%second, 4:[second~255] random%second + second

int const colorRef[24][3]= {
    //  red      ro       orange   oy       yellow   yg1      grean1   g12
    {1,0,0}, {1,3,0}, {1,2,0}, {1,4,0}, {1,1,0}, {4,1,0}, {2,1,0}, {3,1,0},
    //  grean2   g23      grean3   g3b1     blue1    b12      blue2    b23
    {0,1,0}, {0,1,3}, {0,1,2}, {0,1,4}, {0,1,1}, {0,4,1}, {0,2,1}, {0,3,1},
    //  blue3    b3p1     purple1  p12      purple2  p23      purple3  p3r
    {0,0,1}, {3,0,1}, {2,0,1}, {4,0,1}, {1,0,1}, {1,0,4}, {1,0,2}, {1,0,3}
};
int colorRefMax = 24;
int colorRefIndex = 0; // [0~23] random%24


@implementation CVolumeColor

-(CVolumeColor*) init {
    self = [super init];
    colorRefIndex = arc4random() % 24;
    
    return  self;
}


-(void) VolumePower: (float)power toColor: (unsigned char *) Red : (unsigned char *) Green : (unsigned char *) Blue {
    int colorStrength = [self getColorStrength:power];
    *Red = (unsigned char)[self getColor:colorStrength :colorRefIndex :0];
    *Green = (unsigned char)[self getColor:colorStrength :colorRefIndex :1];
    *Blue = (unsigned char)[self getColor:colorStrength :colorRefIndex :2];
    [self updateColorRefIndex];
    //*Red = *Green = *Blue = 1357;
}

-(void) updatePwrBuf:(float)curPwr;
{
    if(IndexPwrBuf >= pwrBufLen) IndexPwrBuf = 0;
    CurPwrBuf[IndexPwrBuf] = curPwr;
    IndexPwrBuf ++;
}
-(float) getPwrMax
{
    float max = CurPwrBuf[0];
    for(int i = 1; i < pwrBufLen; i ++) {
        if(max < CurPwrBuf[i]) {
            max = CurPwrBuf[i];
        }
    }
    return  max;
}
-(float) getPwrMin
{
    float min = CurPwrBuf[0];
    for(int i = 1; i < pwrBufLen; i ++) {
        if(min > CurPwrBuf[i]) {
            min = CurPwrBuf[i];
        }
    }
    return  min;
}
-(int) getColorStrength:(float)curPwr
{
    [self updatePwrBuf:curPwr];
    
    //for(int i = 0; i < pwrBufLen; i ++) { NSLog(@"pwr buf[%d]:%.2f",i,CurPwrBuf[i]); }
    
    float pwrMax = [self getPwrMax];
    float pwrMin = [self getPwrMin];
    //NSLog(@"(%f, %f)",pwrMax,pwrMin);
    
    // 102 ~ 255
    float RGB = 157*curPwr/(pwrMax-pwrMin) + 255 - (157*pwrMax)/(pwrMax - pwrMin);
    
    //NSLog(@"Color Strength:%f",RGB);
    return  (int)RGB;
}

-(int) getColor:(int)colorStrength :(int)index :(int)rgbIndex
{
    int returnColor = 0;
    switch (colorRef[index][rgbIndex]) {
        case 0:
            returnColor = 0;
            break;
        case 1:
            returnColor = colorStrength;
            break;
        case 2:
            returnColor = colorStrength/2;
            break;
        case 3:
            returnColor = arc4random() % (colorStrength/2);
            break;
        case 4:
            returnColor = arc4random() % (colorStrength/2) + (colorStrength/2);
            break;
            
        default:
            returnColor = 0;
            break;
    }
    return  returnColor;
}
-(void) updateColorRefIndex
{
    colorRefIndex += arc4random()%2 - 1;
    if( colorRefIndex < 0 )
        colorRefIndex = 23;
    if( colorRefIndex > 23 )
        colorRefIndex = 0;
}


@end


//
//  ANDialView.h
//  RealDial
//
//  Created by Alex Nichol on 3/3/13.
//  Copyright (c) 2013 Alex Nichol. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kANDialViewStopAngle 0.25

@class ANDialView;

@protocol ANDialViewDelegate <NSObject>

@optional
- (void)dialView:(ANDialView *)dailView dialedNumber:(int)number;

@end

@interface ANDialView : UIView {
    float stopAngle;
    float currentAngle;
    
    UIImageView * backgroundView;
    UIImageView * dialView;
    UIImageView * foregroundView;
    
    BOOL hasSentDigit;
    float dragStartAngle;
    float dragLastAngle;
    
    NSTimer * fallbackTimer;
    NSDate * timerLast;
    
    __weak id<ANDialViewDelegate> delegate;
}

@property (nonatomic, weak) id<ANDialViewDelegate> delegate;

- (id)initWithFrame:(CGRect)frame;
- (int)digitForAngle:(float)angle;
- (float)angleForPoint:(CGPoint)point;
- (BOOL)angle:(float)angle isOppositeStop:(float)anotherAngle;

@end

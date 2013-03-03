//
//  ANDialView.m
//  RealDial
//
//  Created by Alex Nichol on 3/3/13.
//  Copyright (c) 2013 Alex Nichol. All rights reserved.
//

#import "ANDialView.h"

@interface ANDialView (Private)

- (void)beginFallback;
- (void)fallbackMethod:(id)sender;

@end

@implementation ANDialView

@synthesize delegate;

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        backgroundView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 320)];
        foregroundView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 320)];
        dialView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 320)];
        backgroundView.image = [UIImage imageNamed:@"background"];
        foregroundView.image = [UIImage imageNamed:@"foreground"];
        dialView.image = [UIImage imageNamed:@"dial"];
        [self addSubview:backgroundView];
        [self addSubview:dialView];
        [self addSubview:foregroundView];
    }
    return self;
}

- (int)digitForAngle:(float)offsetAngle {
    CGFloat degrees = offsetAngle * 180 / M_PI;
    if (degrees < 0) {
        degrees += 360;
    }
    struct {
        float angle;
        int digit;
    } number_angles[] = {
        {335, 0},
        {305, 9},
        {276, 8},
        {246, 7},
        {216, 6},
        {187, 5},
        {155, 4},
        {125, 3},
        {97, 2},
        {67, 1},
    };
    float distance = FLT_MAX;
    int number = -1;
    for (int i = 0; i < sizeof(number_angles) / sizeof(number_angles[0]); i++) {
        if (fabsf(number_angles[i].angle - degrees) < distance) {
            distance = fabsf(number_angles[i].angle - degrees);
            number = number_angles[i].digit;
        }
    }
    return number;
}

- (float)angleForPoint:(CGPoint)point {
    CGPoint center = CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2);
    float theta = atan2f(point.y - center.y, point.x - center.x);
    if (theta < 0) return 2*M_PI + theta;
    return theta;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [fallbackTimer invalidate];
    fallbackTimer = nil;
    
    CGPoint point = [[touches anyObject] locationInView:self];
    dragStartAngle = [self angleForPoint:point] - currentAngle;
    if (dragStartAngle < 0) dragStartAngle += M_PI / 2;
    dragLastAngle = [self angleForPoint:point];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    if (hasSentDigit) return;
    
    CGPoint point = [[touches anyObject] locationInView:self];
    if (sqrt(pow(point.x - self.frame.size.width / 2, 2) + pow(point.y - self.frame.size.height / 2, 2)) < 30) {
        return;
    }
    float angle = [self angleForPoint:point];
    if ([self angle:dragLastAngle isOppositeStop:angle]) {
        hasSentDigit = YES;
        angle = kANDialViewStopAngle;
        if (angle < dragStartAngle) {
            angle += 2*M_PI;
        }
        int digit = [self digitForAngle:(angle - dragStartAngle)];
        if ([delegate respondsToSelector:@selector(dialView:dialedNumber:)]) {
            [delegate dialView:self dialedNumber:digit];
        }
        [self beginFallback];
    }
    currentAngle = angle - dragStartAngle;
    dialView.transform = CGAffineTransformMakeRotation(currentAngle);
    dragLastAngle = angle;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    if (!hasSentDigit) {
        int digit = [self digitForAngle:currentAngle];
        if ([delegate respondsToSelector:@selector(dialView:dialedNumber:)]) {
            [delegate dialView:self dialedNumber:digit];
        }
        [self beginFallback];
    }
    hasSentDigit = NO;
}

- (BOOL)angle:(float)angle isOppositeStop:(float)anotherAngle {
    BOOL angleAtop = NO;
    if (angle > 3*M_PI / 2 || angle < kANDialViewStopAngle) {
        angleAtop = YES;
    } else if (angle < M_PI / 2) {
        angleAtop = NO;
    } else {
        return NO;
    }
    BOOL angle2Atop = NO;
    if (anotherAngle > 3*M_PI / 2 || anotherAngle < kANDialViewStopAngle) {
        angle2Atop = YES;
    } else if (anotherAngle < M_PI / 2) {
        angle2Atop = NO;
    } else {
        return NO;
    }
    if (angle2Atop != angleAtop) {
        return YES;
    }
    return NO;
}

#pragma mark - Private -

- (void)beginFallback {
    if (fallbackTimer) return;
    fallbackTimer = [NSTimer scheduledTimerWithTimeInterval:(1.0 / 60.0)
                                                     target:self
                                                   selector:@selector(fallbackMethod:)
                                                   userInfo:nil
                                                    repeats:YES];
    timerLast = [NSDate date];
}

- (void)fallbackMethod:(id)sender {
    // who knows what to do here? not me
    NSDate * now = [NSDate date];
    NSTimeInterval delay = [now timeIntervalSinceDate:timerLast];
    timerLast = now;
    float jump = M_PI * currentAngle;
    if (jump > M_PI * M_PI / 1.5) {
        jump = M_PI * M_PI / 1.5;
    }
    currentAngle -= jump * delay;
    if (currentAngle <= 0) {
        currentAngle = 0;
        [fallbackTimer invalidate];
        fallbackTimer = nil;
    }
    dialView.transform = CGAffineTransformMakeRotation(currentAngle);
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

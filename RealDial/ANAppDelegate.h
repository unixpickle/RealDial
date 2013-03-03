//
//  ANAppDelegate.h
//  RealDial
//
//  Created by Alex Nichol on 3/3/13.
//  Copyright (c) 2013 Alex Nichol. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ANDialView.h"

@interface ANAppDelegate : UIResponder <UIApplicationDelegate, ANDialViewDelegate> {
    ANDialView * dialView;
    UILabel * numberLabel;
    UIButton * clearButton;
}

@property (strong, nonatomic) UIWindow * window;

- (void)clearPressed:(id)sender;

@end

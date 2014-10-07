//
//  RoboTestViewController.h
//  UTWHackathon
//
//  Created by Michael Smith on 10/7/14.
//  Copyright (c) 2014 TradeStation. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <RobotKit/RobotKit.h>

@protocol CalibrateFieldDelegate <NSObject>

- (void)setSide0:(RKLocatorData *)side0Location;
- (void)setSide1:(RKLocatorData *)side1Location;

@end

@interface RoboTestViewController : UIViewController

@property (weak, nonatomic) id<CalibrateFieldDelegate> delegate;

@end

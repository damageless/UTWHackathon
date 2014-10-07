//
//  RobotControl.h
//  UTWHackathon
//
//  Created by Adam Gessel on 10/7/14.
//  Copyright (c) 2014 TradeStation. All rights reserved.
//

@protocol RobotControl <NSObject>

- (void) stop;
- (CGPoint) getLocation;
- (void) moveForward;

@end
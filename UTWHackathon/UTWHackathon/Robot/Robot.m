//
//  Robot.m
//  UTWHackathon
//
//  Created by Adam Gessel on 10/7/14.
//  Copyright (c) 2014 TradeStation. All rights reserved.
//

#import "Robot.h"

@implementation Robot

#define VELOCITY 0.4

-(RKLocatorPosition) getLocation
{
    return _locatorData.position;
}

-(void)setLocatorData:(RKLocatorData *)locatorData
{
    _locatorData = locatorData;
	[[NSNotificationCenter defaultCenter] postNotificationName:RobotMoveNotification object:nil];
    [self checkShouldStop];
}

-(void)checkShouldStop
{
    if ((_state == Forward && _locatorData.position.x > _destination) ||
        (_state == Backward && _locatorData.position.x < _destination))
    {
        // stop
        [RKRollCommand sendStop];
        _state = Stop;
    }
}

-(void)move: (int) x
{
    _destination = x;
    if (x - self.locatorData.position.x > 0) {
        // forward
        [RKRollCommand sendCommandWithHeading:0.0 velocity:VELOCITY];
        _state = Forward;
    } else {
        // backward
        [RKRollCommand sendCommandWithHeading:180.0 velocity:VELOCITY];
        _state = Backward;
    }
}

-(void)setCenter
{
    [RKConfigureLocatorCommand sendCommandForFlag:RKConfigureLocatorRotateWithCalibrateFlagOn newX:0 newY:0 newYaw:0];
    NSLog(@"New center set.");
}

@end

//
//  Robot.m
//  UTWHackathon
//
//  Created by Adam Gessel on 10/7/14.
//  Copyright (c) 2014 TradeStation. All rights reserved.
//

#import "Robot.h"

@implementation Robot

#define VELOCITY 0.3
#define CORRECTION_AMOUNT 10

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
    if ((_state == Forward && _locatorData.position.y > _destination-CORRECTION_AMOUNT) ||
        (_state == Backward && _locatorData.position.y < _destination+CORRECTION_AMOUNT))
    {
        // stop
        [RKRollCommand sendStop];
        _state = Stop;
    }
}

-(void)move: (NSInteger) x
{
    _destination = x;
    if (x - self.locatorData.position.y > 0) {
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

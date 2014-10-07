//
//  Robot.h
//  UTWHackathon
//
//  Created by Adam Gessel on 10/7/14.
//  Copyright (c) 2014 TradeStation. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RobotKit/RobotKit.h>

typedef enum {
    Forward,
    Backward,
    Stop = 0
} State;

@interface Robot : NSObject
@property (strong, nonatomic) RKQuaternionData* quaternion;
@property (strong, nonatomic) RKAccelerometerData* accelerometerData;
@property (strong, nonatomic) RKLocatorData* locatorData;
@property (assign, nonatomic) BOOL isOnline;
@property (assign, nonatomic) State state;
@property (assign, nonatomic) NSInteger destination;

-(void) move: (NSInteger) x;
-(void) setCenter;
-(RKLocatorPosition) getLocation;

@end

//
//  Robot.h
//  UTWHackathon
//
//  Created by Adam Gessel on 10/7/14.
//  Copyright (c) 2014 TradeStation. All rights reserved.
//
#import <Foundation/Foundation.h>

@interface Robot : NSObject {
}

@property (assign, nonatomic) RKQuaternionData* quaternion;
@property (assign, nonatomic) RKAccelerometerData* accelerometerData;
@property (assign, nonatomic) RKLocatorData* locatorData;
@property (assign, nonatomic) BOOL isOnline;

@end
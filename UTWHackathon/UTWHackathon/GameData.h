//
//  GameData.h
//  UTWHackathon
//
//  Created by Scott Larson on 10/7/14.
//  Copyright (c) 2014 TradeStation. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreFoundation/CoreFoundation.h>
#import <RobotKit/RobotKit.h>

@interface GameData : NSObject
           
           
@property (copy, nonatomic) NSString *team0Name;
@property (copy, nonatomic) NSString *team1Name;

@property (strong, nonatomic) RKLocatorData *side0Location;
@property (strong, nonatomic) RKLocatorData *side1Location;
@property (readonly, nonatomic) RKLocatorPosition *fieldCenterPosition;


@end

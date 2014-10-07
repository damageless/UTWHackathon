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

@property (copy, nonatomic) NSString *gameName;
@property (copy, nonatomic) NSString *gameId;

@property (copy, nonatomic) NSString *team0Name;
@property (copy, nonatomic) UIColor *team0Color;

@property (copy, nonatomic) NSString *team1Name;
@property (copy, nonatomic) UIColor *team1Color;

- (GameData *)initWithDictionary:(NSDictionary *)dict;

@end

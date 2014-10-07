//
//  GamePlay.h
//  UTWHackathon
//
//  Created by Kekoa Vincent on 10/7/14.
//  Copyright (c) 2014 TradeStation. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GamePlay : NSObject

@property (strong, nonatomic) NSString *playDescription;
@property (strong, nonatomic) NSString *locationDescription;
@property (strong, nonatomic) NSNumber *down;
@property (strong, nonatomic) NSNumber *distance;
@property (strong, nonatomic) NSNumber *yardLine;
@property (strong, nonatomic) NSString *possession;
@property (strong, nonatomic) NSNumber *scoreHome;
@property (strong, nonatomic) NSNumber *scoreAway;
@property (strong, nonatomic) NSNumber *quarter;
@property (strong, nonatomic) NSString *type;
@property (strong, nonatomic) NSString *specialType;

@end

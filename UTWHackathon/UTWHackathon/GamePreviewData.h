//
//  GamePreviewData.h
//  UTWHackathon
//
//  Created by Joe on 10/7/14.
//  Copyright (c) 2014 TradeStation. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GamePreviewData : NSObject

@property(strong, nonatomic) NSString *gameName;
@property(strong, nonatomic) NSString *gameId;
@property(strong, nonatomic) NSString *gameDate;

- (GamePreviewData *)initWithDictionary:(NSDictionary *)dict;

@end

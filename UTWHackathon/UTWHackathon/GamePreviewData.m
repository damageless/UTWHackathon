//
//  GamePreviewData.m
//  UTWHackathon
//
//  Created by Joe on 10/7/14.
//  Copyright (c) 2014 TradeStation. All rights reserved.
//

#import "GamePreviewData.h"

@implementation GamePreviewData

- (GamePreviewData *)initWithDictionary:(NSDictionary *)dict
{
    self.gameName = [dict objectForKey:@"name"];
    self.gameId = [dict objectForKey:@"id"];
    self.gameDate = [dict objectForKey:@"date"];
    
    return self;
}

@end

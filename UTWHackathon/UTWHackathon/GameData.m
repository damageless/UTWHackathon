//
//  GameData.m
//  UTWHackathon
//
//  Created by Scott Larson on 10/7/14.
//  Copyright (c) 2014 TradeStation. All rights reserved.
//

#import "GameData.h"

@implementation GameData

- (GameData *)initWithDictionary:(NSDictionary *)dict
{
    for (NSArray *array in dict) {
        NSLog(@"object: %@", array);
    }
/*
    self.gameName = [dict objectForKey:@"name"];
    @property (copy, nonatomic) NSString *team0Name;
    @property (copy, nonatomic) UIColor *team0Color;
    @property (strong, nonatomic) RKLocatorData *side0Location;
    
    @property (copy, nonatomic) NSString *team1Name;
    @property (copy, nonatomic) UIColor *team1Color;
    @property (strong, nonatomic) RKLocatorData *side1Location;
    
    @property (readonly, nonatomic) RKLocatorPosition *fieldCenterPosition;
*/
    return self;
}

- (RKLocatorPosition *)fieldCenterLocation
{
    if (self.side0Location && self.side0Location) {
        
        
    }
    
    return nil;
}


@end

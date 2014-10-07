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
    NSDictionary *teams = [dict objectForKey:@"teams"];

    NSDictionary *homeTeam = [teams objectForKey:@"home"];
    self.team0Name = [homeTeam objectForKey:@"name"];
    NSString *color = [homeTeam objectForKey:@"color"];
    self.team0Color = [self colorFromHexString:color];
    
    NSDictionary *awayTeam = [teams objectForKey:@"away"];
    self.team1Name = [awayTeam objectForKey:@"name"];
    color = [awayTeam objectForKey:@"color"];
    self.team1Color = [self colorFromHexString:color];
    
    return self;
}

- (UIColor *)colorFromHexString:(NSString *)hexString
{
    unsigned rgbValue = 0;
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    [scanner setScanLocation:1]; // bypass '#' character
    [scanner scanHexInt:&rgbValue];
    
    return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0 green:((rgbValue & 0xFF00) >> 8)/255.0 blue:(rgbValue & 0xFF)/255.0 alpha:1.0];
}

@end

//
//  AppDelegate.h
//  UTWHackathon
//
//  Created by Adam Gessel on 10/7/14.
//  Copyright (c) 2014 TradeStation. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <RobotKit/RobotKit.h>

BOOL robotOnline = NO;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

-(void)setupRobotConnection;
-(void)handleRobotOnline;

@end


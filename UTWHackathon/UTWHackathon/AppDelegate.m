//
//  AppDelegate.m
//  UTWHackathon
//
//  Created by Adam Gessel on 10/7/14.
//  Copyright (c) 2014 TradeStation. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleRobotOnline) name:RKDeviceConnectionOnlineNotification object:nil];
    _robot = [[Robot alloc] init];
    NSLog(@"Testing");
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:RKDeviceConnectionOnlineNotification object:nil]; [RKRGBLEDOutputCommand sendCommandWithRed:0.0 green:0.0 blue:0.0]; [[RKRobotProvider sharedRobotProvider] closeRobotConnection];
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
     
-(void)handleRobotOnline {
    NSLog(@"Robot is online.");
    [self sendSetDataStreamingCommand];
    [[RKDeviceMessenger sharedMessenger] addDataStreamingObserver:self selector:@selector(handleAsyncData:)];
}

-(void)sendSetDataStreamingCommand {
    RKDataStreamingMask mask = RKDataStreamingMaskAccelerometerFilteredAll | RKDataStreamingMaskQuaternionAll | RKDataStreamingMaskLocatorAll;
    
    uint16_t divisor = 40;
    uint16_t packetFrames = 1;
    uint8_t count = 0;
    
    [RKSetDataStreamingCommand sendCommandWithSampleRateDivisor:divisor
                                                   packetFrames:packetFrames
                                                     sensorMask:mask
                                                    packetCount:count];
}

- (void)handleAsyncData:(RKDeviceAsyncData *)asyncData
{
    if ([asyncData isKindOfClass:[RKDeviceSensorsAsyncData class]]) {
        
        RKDeviceSensorsAsyncData *sensorsAsyncData = (RKDeviceSensorsAsyncData *)asyncData;
        RKDeviceSensorsData *sensorsData = [sensorsAsyncData.dataFrames lastObject];
        RKQuaternionData *quaternionData = sensorsData.quaternionData;
        
        self.robot.quaternion = quaternionData;
        self.robot.accelerometerData = sensorsData.accelerometerData;
        self.robot.locatorData = sensorsData.locatorData;
        

//        NSLog(@"Quaternion data: %f, %f, %f, %f", quaternionData.quaternions.q0, quaternionData.quaternions.q1, quaternionData.quaternions.q2, quaternionData.quaternions.q3);
    }
}

@end

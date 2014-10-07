//
//  ViewController.m
//  SensorStreaming
//
//  Created by Brian Smith on 03/28/12.
//  Copyright (c) 2011 Orbotix, Inc. All rights reserved.
//

#import "ViewController.h"
#import "RobotKit/RobotKit.h"

@implementation ViewController

@synthesize xValueLabel;
@synthesize yValueLabel;
@synthesize zValueLabel;
@synthesize pitchValueLabel;
@synthesize rollValueLabel;
@synthesize yawValueLabel;
@synthesize q0ValueLabel;
@synthesize q1ValueLabel;
@synthesize q2ValueLabel;
@synthesize q3ValueLabel;

- (void)dealloc
{
    [xValueLabel release];
    [yValueLabel release];
    [zValueLabel release];
    [pitchValueLabel release];
    [rollValueLabel release];
    [yawValueLabel release];
    [q0ValueLabel release];
    [q1ValueLabel release];
    [q2ValueLabel release];
    [q3ValueLabel release];
    [super dealloc];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.

    /*Register for application lifecycle notifications so we known when to connect and disconnect from the robot*/
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(appDidBecomeActive:) 
                                                 name:UIApplicationDidBecomeActiveNotification 
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(appWillResignActive:)
                                                 name:UIApplicationWillResignActiveNotification
                                               object:nil];

    /*Only start the blinking loop when the view loads*/
    robotOnline = NO;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.xValueLabel = nil;
    self.yValueLabel = nil;
    self.zValueLabel = nil;
    self.pitchValueLabel = nil;
    self.rollValueLabel = nil;
    self.yawValueLabel = nil;
    self.q0ValueLabel = nil;
    self.q1ValueLabel = nil;
    self.q2ValueLabel = nil;
    self.q3ValueLabel = nil;
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}

-(void)appWillResignActive:(NSNotification*)notification {
    /*When the application is entering the background we need to close the connection to the robot*/
    [[NSNotificationCenter defaultCenter] removeObserver:self name:RKDeviceConnectionOnlineNotification object:nil];
    
    // Turn off data streaming
    [RKSetDataStreamingCommand sendCommandWithSampleRateDivisor:0 
                                                   packetFrames:0 
                                                     sensorMask:RKDataStreamingMaskOff 
                                                    packetCount:0];
    // Unregister for async data packets
    [[RKDeviceMessenger sharedMessenger] removeDataStreamingObserver:self];
    
    // Restore stabilization (the control unit)
    [RKStabilizationCommand sendCommandWithState:RKStabilizationStateOn];
    
    // Turn off Back LED
    [RKBackLEDOutputCommand sendCommandWithBrightness:0.0f];
    
    // Close the connection
    [[RKRobotProvider sharedRobotProvider] closeRobotConnection];
    
    robotOnline = NO;
}

-(void)appDidBecomeActive:(NSNotification*)notification {
    /*When the application becomes active after entering the background we try to connect to the robot*/
    [self setupRobotConnection];
}

- (void)handleRobotOnline {
    /*The robot is now online, we can begin sending commands*/
    if(!robotOnline) {
        
        [RKSetDataStreamingCommand sendCommandStopStreaming];
        // Start streaming sensor data
        ////First turn off stabilization so the drive mechanism does not move.
        [RKStabilizationCommand sendCommandWithState:RKStabilizationStateOff];
        // Turn on the Back LED for reference
        [RKBackLEDOutputCommand sendCommandWithBrightness:1.0f];
        
        [self sendSetDataStreamingCommand];
        
        ////Register for asynchronise data streaming packets
        [[RKDeviceMessenger sharedMessenger] addDataStreamingObserver:self selector:@selector(handleAsyncData:)];
    }
    robotOnline = YES;
}

-(void)sendSetDataStreamingCommand {
    
    // Requesting the Accelerometer X, Y, and Z filtered (in Gs)
    //            the IMU Angles roll, pitch, and yaw (in degrees)
    //            the Quaternion data q0, q1, q2, and q3 (in 1/10000) of a Q
    RKDataStreamingMask mask =  RKDataStreamingMaskAccelerometerFilteredAll |
                                RKDataStreamingMaskIMUAnglesFilteredAll   |
                                RKDataStreamingMaskQuaternionAll;
    
    // Note: If your ball has Firmware < 1.20 then these Quaternions
    //       will simply show up as zeros.
    
    // Sphero samples this data at 400 Hz.  The divisor sets the sample
    // rate you want it to store frames of data.  In this case 400Hz/40 = 10Hz
    uint16_t divisor = 40;
    
    // Packet frames is the number of frames Sphero will store before it sends
    // an async data packet to the iOS device
    uint16_t packetFrames = 1;
    
    // Count is the number of async data packets Sphero will send you before
    // it stops.  Set a count of 0 for infinite data streaming.
    uint8_t count = 0;
    
    // Send command to Sphero
    [RKSetDataStreamingCommand sendCommandWithSampleRateDivisor:divisor
                                                   packetFrames:packetFrames
                                                     sensorMask:mask
                                                    packetCount:count];

}

- (void)handleAsyncData:(RKDeviceAsyncData *)asyncData
{
    // Need to check which type of async data is received as this method will be called for
    // data streaming packets and sleep notification packets. We are going to ingnore the sleep
    // notifications.
    if ([asyncData isKindOfClass:[RKDeviceSensorsAsyncData class]]) {
        
        // Received sensor data, so display it to the user.
        RKDeviceSensorsAsyncData *sensorsAsyncData = (RKDeviceSensorsAsyncData *)asyncData;
        RKDeviceSensorsData *sensorsData = [sensorsAsyncData.dataFrames lastObject];
        RKAccelerometerData *accelerometerData = sensorsData.accelerometerData;
        RKAttitudeData *attitudeData = sensorsData.attitudeData;
        RKQuaternionData *quaternionData = sensorsData.quaternionData;
        
        // Print data to the text fields
        self.xValueLabel.text = [NSString stringWithFormat:@"%.6f", accelerometerData.acceleration.x];
        self.yValueLabel.text = [NSString stringWithFormat:@"%.6f", accelerometerData.acceleration.y];
        self.zValueLabel.text = [NSString stringWithFormat:@"%.6f", accelerometerData.acceleration.z];
        self.pitchValueLabel.text = [NSString stringWithFormat:@"%.0f", attitudeData.pitch];
        self.rollValueLabel.text = [NSString stringWithFormat:@"%.0f", attitudeData.roll];
        self.yawValueLabel.text = [NSString stringWithFormat:@"%.0f", attitudeData.yaw];
        self.q0ValueLabel.text = [NSString stringWithFormat:@"%.6f", quaternionData.quaternions.q0];
        self.q1ValueLabel.text = [NSString stringWithFormat:@"%.6f", quaternionData.quaternions.q1];
        self.q2ValueLabel.text = [NSString stringWithFormat:@"%.6f", quaternionData.quaternions.q2];
        self.q3ValueLabel.text = [NSString stringWithFormat:@"%.6f", quaternionData.quaternions.q3];
    }
}

-(void)setupRobotConnection {
    /*Try to connect to the robot*/
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleRobotOnline) name:RKDeviceConnectionOnlineNotification object:nil];
    [[RKRobotProvider sharedRobotProvider] openRobotConnection];        
    
}

@end

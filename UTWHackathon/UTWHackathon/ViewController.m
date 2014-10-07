//
//  ViewController.m
//  UTWHackathon
//
//  Created by Adam Gessel on 10/7/14.
//  Copyright (c) 2014 TradeStation. All rights reserved.
//

#import "ViewController.h"
#import "CalibrateFieldViewController.h"
#import "GameSelectionViewController.h"
#import <RobotKit/RobotKit.h>
#import "SocketRocket/SRWebSocket.h"
#import "Robot/Robot.h"
#import "RoboTestViewController.h"

@interface ViewController () <CalibrateFieldDelegate, GameSelectionDelegate>

@property (weak, nonatomic) IBOutlet UIButton *calibrateFieldButton;

- (IBAction)calibrateFieldButtonTapped:(id)sender;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleRobotOnline) name:RKDeviceConnectionOnlineNotification object:nil];
    [self connectToRobot];
}

-(void)connectToRobot
{
    [self.robotConnectedLabel setText:@"Connecting to Robot..."];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleRobotOnline) name:RKDeviceConnectionOnlineNotification object:nil];
    if ([[RKRobotProvider sharedRobotProvider] isRobotUnderControl])
    {
        [[RKRobotProvider sharedRobotProvider] openRobotConnection];
    }else
    {
        [[RKRobotProvider sharedRobotProvider] controlConnectedRobot];
    }
}

- (void) handleRobotOnline {
    [self.robotConnectedLabel setText:@"Robot is connected"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)gameSelectionButtonButtonTapped:(id)sender
{
    GameSelectionViewController *gameSelectionVC = (GameSelectionViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"GameSelection"];
    gameSelectionVC.delegate = self;
    
    [self.navigationController pushViewController:gameSelectionVC animated:YES];
}

- (IBAction)testSpheroButtonTapped:(id)sender
{
    RoboTestViewController *roboTestVC = (RoboTestViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"RoboTest"];
    
    [self.navigationController pushViewController:roboTestVC animated:YES];
}

- (IBAction)calibrateFieldButtonTapped:(id)sender
{
    CalibrateFieldViewController *calibrateFieldVC = (CalibrateFieldViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"CalibrateField"];
    calibrateFieldVC.delegate = self;
    
    
    
    [self.navigationController pushViewController:calibrateFieldVC animated:YES];
}


@end

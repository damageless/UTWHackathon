//
//  ViewController.m
//  UTWHackathon
//
//  Created by Adam Gessel on 10/7/14.
//  Copyright (c) 2014 TradeStation. All rights reserved.
//

#import "ViewController.h"
#import "GameSelectionViewController.h"
#import <RobotKit/RobotKit.h>
#import "Robot/Robot.h"
#import "AFNetworking.h"
#import "RoboTestViewController.h"
#import "GameData.h"
#import "GamePlay.h"
#import "GameViewController.h"

@interface ViewController () <GameSelectionDelegate>

@property (strong, nonatomic) GameData *currentGameData;

@property (weak, nonatomic) IBOutlet UILabel *currentGameLabel;
@property (weak, nonatomic) IBOutlet UIButton *startButton;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleRobotOnline) name:RKDeviceConnectionOnlineNotification object:nil];
    [self connectToRobot];
    
    self.startButton.layer.cornerRadius = 20;
	
	self.startButton.enabled = NO;
}

- (void)setCurrentGameData:(GameData *)currentGameData
{
	_currentGameData = currentGameData;
	self.startButton.enabled = currentGameData != nil;
}

-(void)connectToRobot
{
    [self.robotConnectedLabel setText:@"Connecting to Robot..."];
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

- (IBAction)testSpheroButtonTapped:(id)sender
{
    RoboTestViewController *roboTestVC = (RoboTestViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"RoboTest"];

    [self.navigationController pushViewController:roboTestVC animated:YES];
}

- (IBAction)gameSelectionButtonTapped:(id)sender
{
    GameSelectionViewController *controller = (GameSelectionViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"GameSelection"];
    controller.delegate = self;
    
    [self.navigationController pushViewController:controller animated:YES];
}

- (IBAction)startButtonPressed:(id)sender
{
    GameViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"GameView"];
    controller.gameData = self.currentGameData;
    
    controller.currentGameData = self.currentGameData;
    [self.navigationController pushViewController:controller animated:YES];
}


#pragma mark - GameSelectionDelegate

- (void)selectedGameData:(GameData *)gameData
{
    self.currentGameData = gameData;
    [self.currentGameLabel setText:gameData.gameName];
}

- (NSString *)currentGameName
{
    if (self.currentGameData.gameName) {
        return self.currentGameData.gameName;
    }
    
    return nil;
}


@end

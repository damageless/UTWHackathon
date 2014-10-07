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

@interface ViewController () <GameSelectionDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleRobotOnline) name:RKDeviceConnectionOnlineNotification object:nil];
    [self connectToRobot];
    
    [self openStreamingConnection];
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
    
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)openStreamingConnection
{
    NSString *url = @"http://spherosport.herokuapp.com";
    NSLog(@"Opening streaming connection...");
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    SRWebSocket *socket = [[SRWebSocket alloc] initWithURLRequest:request];
    socket.delegate = self;
    
    [socket open];
    //[socket send:@""];
    
    //TODO: close socket
    //[socket close];
}
    
#pragma mark - SRWebSocketDelegate
    
- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message
{
    NSLog(@"received streaming message: %@", message);
}

//optional:
//- (void)webSocketDidOpen:(SRWebSocket *)webSocket;
//- (void)webSocket:(SRWebSocket *)webSocket didFailWithError:(NSError *)error;
//- (void)webSocket:(SRWebSocket *)webSocket didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean;

@end

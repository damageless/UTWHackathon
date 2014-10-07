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
#import "Robot/Robot.h"
#import "AFNetworking.h"

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
    
    [self openStreamingConnection];
    [self getGameList];
}

- (void)getGameList
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:@"http://spherosport.herokuapp.com/games" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
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

- (IBAction)calibrateFieldButtonTapped:(id)sender
{
    CalibrateFieldViewController *calibrateFieldVC = (CalibrateFieldViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"CalibrateField"];
    calibrateFieldVC.delegate = self;
    
    
    
    [self.navigationController pushViewController:calibrateFieldVC animated:YES];
}

- (void)openStreamingConnection
{
    NSString *url = @"http://spherosport.herokuapp.com/games";
    NSLog(@"Making server request");
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

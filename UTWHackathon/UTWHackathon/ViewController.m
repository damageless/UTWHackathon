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

@property (strong, nonatomic) SRWebSocket *webSocket;
@property (strong, nonatomic) GameData *currentGameData;

@property (weak, nonatomic) IBOutlet UILabel *currentGameLabel;
@property (nonatomic, copy) GamePlayCallback playCallback;
@property (weak, nonatomic) IBOutlet UIButton *startButton;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleRobotOnline) name:RKDeviceConnectionOnlineNotification object:nil];
    [self connectToRobot];
    
    [self openStreamingConnection];
    
    self.startButton.layer.cornerRadius = 20;
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
    
    [self.navigationController pushViewController:controller animated:YES];
    
    [self startGameStream:self.currentGameData.gameId callback:^(GamePlay* play) {
        [controller setPlay:play];
    }];
}

- (void)openStreamingConnection
{
    NSString *url = @"ws://spherosport.herokuapp.com/stream";
    NSLog(@"Making server request");
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    SRWebSocket *socket = [[SRWebSocket alloc] initWithURLRequest:request];
    socket.delegate = self;
    
    [socket open];
}

- (void)startGameStream:(NSString *)gameId callback:(GamePlayCallback)block
{
    if (self.webSocket) {
        self.playCallback = block;
        
        NSDictionary *startCommand = @{
                                       @"command": @"start",
                                       @"game_id": gameId,
                                       @"speed": @2
                                       
                                       };
        NSError *error;
        NSData *data = [NSJSONSerialization dataWithJSONObject:startCommand options:0 error:&error];
        [self.webSocket send:data];
        
    }
}

- (void)stopGameStream
{
    if (self.webSocket) {
        NSDictionary *stopCommand = @{
                                       @"command": @"stop",
                                       };
        NSError *error;
        NSData *data = [NSJSONSerialization dataWithJSONObject:stopCommand options:0 error:&error];
        [self.webSocket send:data];
        
    }
    
    self.playCallback = nil;
}
    
#pragma mark - SRWebSocketDelegate
    
- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message
{
    
    NSError *error;
    NSDictionary *object = [NSJSONSerialization
                             JSONObjectWithData:[message dataUsingEncoding:NSUTF8StringEncoding]
                             options:0
                             error:&error];
    
    if (!error) {
        GamePlay *play = [[GamePlay alloc] init];
        play.playDescription = object[@"result_description"];
        play.locationDescription = object[@"location_description"];
        play.scoreAway = object[@"away_score"];
        play.scoreHome = object[@"home_score"];
        play.quarter = object[@"quarter"];
        play.down = object[@"down"];
        play.distance = object[@"distance"];
        play.yardLine = object[@"yardLine"];
        play.possession = object[@"posession"];
        play.type = object[@"type"];
        play.specialType = object[@"special_type"];
        
        if (self.playCallback) {
            self.playCallback(play);
        }
        

    }
    

}

- (void)webSocket:(SRWebSocket *)webSocket didFailWithError:(NSError *)error
{
    NSLog(@"socket failed with error: %@", error);
}

- (void)webSocketDidOpen:(SRWebSocket *)webSocket
{
    self.webSocket = webSocket;
    //TODO: close socket
    //[socket close];

}
//optional:
//- (void)webSocketDidOpen:(SRWebSocket *)webSocket;
//- (void)webSocket:(SRWebSocket *)webSocket didFailWithError:(NSError *)error;
//- (void)webSocket:(SRWebSocket *)webSocket didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean;

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

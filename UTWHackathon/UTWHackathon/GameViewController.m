//
//  GameViewController.m
//  UTWHackathon
//
//  Created by Joe on 10/7/14.
//  Copyright (c) 2014 TradeStation. All rights reserved.
//

#import "GameViewController.h"
#import "AppDelegate.h"
#import "GamePlay.h"

@interface GameViewController ()

@property (readonly, nonatomic) Robot* robot;
@property (weak, nonatomic) IBOutlet UILabel *homeLabel;
@property (weak, nonatomic) IBOutlet UILabel *homeScoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *guestLabel;
@property (weak, nonatomic) IBOutlet UILabel *guestScoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *playStatusLabel;

@property (strong, nonatomic) SRWebSocket *webSocket;
@property (nonatomic, copy) GamePlayCallback playCallback;

- (void)startGameStream:(NSString *)gameId callback:(GamePlayCallback)block;
- (void)stopGameStream;

@end

#define UIColorFromRGB(rgbValue) \
[UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0x00FF00) >>  8))/255.0 \
blue:((float)((rgbValue & 0x0000FF) >>  0))/255.0 \
alpha:1.0]

@implementation GameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.homeLabel.text = self.currentGameData.team0Name;
    self.guestLabel.text = self.currentGameData.team1Name;
    
    [self openStreamingConnection];
/*    [self startGameStream:self.currentGameData.gameId callback:^(GamePlay* play) {
        NSLog(@"Received Play: %@", play);
        self.playStatusLabel.text = play.
    }];*/

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

- (Robot*)robot
{
    return [(AppDelegate *)[[UIApplication sharedApplication] delegate] robot];
}


- (void)startGameStream:(NSString *)gameId callback:(GamePlayCallback)block
{

    if (self.webSocket){
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

- (void)setPlay:(GamePlay *)play
{
    NSLog(@"Received Play: %@", play);
    if (self.webSocket) {
        NSDictionary *stopCommand = @{
                                      @"command": @"stop",
                                      };
        NSError *error;
        NSData *data = [NSJSONSerialization dataWithJSONObject:stopCommand options:0 error:&error];
        [self.webSocket send:data];
        
    }
    
    if ([play.possession isEqualToString:@"home"]) {
        [self.robot setColor:self.gameData.team0Color];
    } else {
        [self.robot setColor:self.gameData.team1Color];
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

@end

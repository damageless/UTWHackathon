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
@property (weak, nonatomic) IBOutlet UIImageView *homePossessionIcon;
@property (weak, nonatomic) IBOutlet UIImageView *guestPossessionIcon;
@property (weak, nonatomic) IBOutlet UILabel *homeScoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *guestLabel;
@property (weak, nonatomic) IBOutlet UILabel *guestScoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *playStatusLabel;
@property (weak, nonatomic) IBOutlet UILabel *yardlineLabel;

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
    self.homeScoreLabel.text = @"0";
    self.guestLabel.text = self.currentGameData.team1Name;
    self.guestScoreLabel.text = @"0";
    self.homePossessionIcon.hidden = YES;
    self.guestPossessionIcon.hidden = YES;
    
    [self openStreamingConnection];

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
                                       @"speed": @5
                                       
                                       };
        NSError *error;
        NSData *data = [NSJSONSerialization dataWithJSONObject:startCommand options:0 error:&error];
        [self.webSocket send:data];
        
    }
}

- (void)stopGameStream
{
    
    self.playCallback = nil;
    
    if (self.webSocket) {
        NSDictionary *stopCommand = @{
                                      @"command": @"stop",
                                      };
        NSError *error;
        NSData *data = [NSJSONSerialization dataWithJSONObject:stopCommand options:0 error:&error];
        [self.webSocket send:data];
        
    }
}


#pragma mark - SRWebSocketDelegate

- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message
{
    
    NSError *error;
    NSDictionary *object = [NSJSONSerialization
                            JSONObjectWithData:[message dataUsingEncoding:NSUTF8StringEncoding]
                            options:0
                            error:&error];
    NSLog(@"message: %@", object);
    
    if (!error) {
        GamePlay *play = [[GamePlay alloc] init];
        play.playDescription = object[@"result_description"];
        play.locationDescription = object[@"location_description"];
        play.scoreAway = object[@"away_score"];
        play.scoreHome = object[@"home_score"];
        play.quarter = object[@"quarter"];
        play.down = object[@"down"];
        play.distance = object[@"distance"];
        play.yardLine = object[@"yard_line"];
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
    
    [self startGameStream:self.currentGameData.gameId callback:^(GamePlay* play) {
        NSLog(@"Received Play: %@", play);
        if (play.scoreHome != nil) {
            self.homeScoreLabel.text = play.scoreHome.stringValue;
        }
        if (play.scoreAway != nil) {
            self.guestScoreLabel.text = play.scoreAway.stringValue;
        }
        if (play.playDescription != nil) {
            self.playStatusLabel.text = play.playDescription;
        }
        if (play.locationDescription != nil) {
            self.yardlineLabel.text = play.locationDescription;
        }
        else {
            self.yardlineLabel.text = @"";
        }
        
        if ([play.possession isEqualToString:@"home"]) {
            [self.robot setColor:self.gameData.team0Color];
            self.homePossessionIcon.hidden = NO;
            self.guestPossessionIcon.hidden = YES;
        } else {
            [self.robot setColor:self.gameData.team1Color];
            self.homePossessionIcon.hidden = YES;
            self.guestPossessionIcon.hidden = NO;

        }
		
		
		UIColor* teamColor;
		if ([play.possession isEqualToString:@"home"]) {
			teamColor = self.gameData.team0Color;
		} else {
			teamColor = self.gameData.team1Color;
		}
		
        [self.robot move:[play.yardLine integerValue]];
		
		if ([play.specialType isEqualToString:@"touchdown"]){
			[self touchdown:teamColor];
		}
    }];

	
}

- (void)touchdown:(UIColor*)color
{
	UIColor* defaultColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:1];
	float delay = 0.3;
	[self.robot performSelector:@selector(setColor:) withObject:defaultColor afterDelay:delay];
	[self.robot performSelector:@selector(setColor:) withObject:color afterDelay:delay*2];
	[self.robot performSelector:@selector(setColor:) withObject:defaultColor afterDelay:delay*3];
	[self.robot performSelector:@selector(setColor:) withObject:color afterDelay:delay*4];
	[self.robot performSelector:@selector(setColor:) withObject:defaultColor afterDelay:delay*5];
	[self.robot performSelector:@selector(setColor:) withObject:color afterDelay:delay*6];
	[self.robot performSelector:@selector(setColor:) withObject:defaultColor afterDelay:delay*7];
	[self.robot performSelector:@selector(setColor:) withObject:color afterDelay:delay*8];
	[self.robot performSelector:@selector(setColor:) withObject:defaultColor afterDelay:delay*9];
	[self.robot performSelector:@selector(setColor:) withObject:color afterDelay:delay*10];
	[self.robot performSelector:@selector(setColor:) withObject:defaultColor afterDelay:delay*11];
	[self.robot performSelector:@selector(setColor:) withObject:color afterDelay:delay*12];
}
//optional:
//- (void)webSocketDidOpen:(SRWebSocket *)webSocket;
//- (void)webSocket:(SRWebSocket *)webSocket didFailWithError:(NSError *)error;
//- (void)webSocket:(SRWebSocket *)webSocket didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean;

@end

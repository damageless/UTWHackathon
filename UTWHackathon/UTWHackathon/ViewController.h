//
//  ViewController.h
//  UTWHackathon
//
//  Created by Adam Gessel on 10/7/14.
//  Copyright (c) 2014 TradeStation. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SRWebSocket.h"
#import "GamePlay.h"

typedef void (^GamePlayCallback)(GamePlay*);

@interface ViewController : UIViewController <SRWebSocketDelegate>
@property (weak, nonatomic) IBOutlet UILabel *robotConnectedLabel;
- (void)handleRobotOnline;

- (void)startGameStream:(NSString *)gameId callback:(GamePlayCallback)block;
- (void)stopGameStream;

@end


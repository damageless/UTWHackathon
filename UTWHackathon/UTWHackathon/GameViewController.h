//
//  GameViewController.h
//  UTWHackathon
//
//  Created by Joe on 10/7/14.
//  Copyright (c) 2014 TradeStation. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SRWebSocket.h"
#import "GameData.h"
#import "GamePlay.h"

typedef void (^GamePlayCallback)(GamePlay*);

@interface GameViewController : UIViewController <SRWebSocketDelegate>

@property (strong, nonatomic) GameData *currentGameData;

@end

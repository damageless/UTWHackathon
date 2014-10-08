//
//  GameViewController.h
//  UTWHackathon
//
//  Created by Joe on 10/7/14.
//  Copyright (c) 2014 TradeStation. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GamePlay.h"
#import "GameData.h"


@interface GameViewController : UIViewController

@property (strong, nonatomic) GameData* gameData;

- (void)setPlay:(GamePlay*)play;
@property (strong, nonatomic) GameData *currentGameData;

@end

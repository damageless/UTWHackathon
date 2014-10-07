//
//  GameSelectionViewController.h
//  UTWHackathon
//
//  Created by Scott Larson on 10/7/14.
//  Copyright (c) 2014 TradeStation. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GameData.h"

@protocol GameSelectionDelegate <NSObject>

- (void)selectedGameData:(GameData *)gameData;
- (NSString *)currentGameName;

@end

@interface GameSelectionViewController : UIViewController

@property (weak, nonatomic) id<GameSelectionDelegate> delegate;

@end

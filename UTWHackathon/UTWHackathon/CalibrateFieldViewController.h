//
//  CalibrateFieldViewController.h
//  UTWHackathon
//
//  Created by Scott Larson on 10/7/14.
//  Copyright (c) 2014 TradeStation. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CalibrateFieldDelegate <NSObject>


@end

@interface CalibrateFieldViewController : UIViewController

@property (weak, nonatomic) id<CalibrateFieldDelegate> delegate;

@end

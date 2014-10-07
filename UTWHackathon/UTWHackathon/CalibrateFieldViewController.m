//
//  CalibrateFieldViewController.m
//  UTWHackathon
//
//  Created by Scott Larson on 10/7/14.
//  Copyright (c) 2014 TradeStation. All rights reserved.
//

#import "CalibrateFieldViewController.h"

@interface CalibrateFieldViewController ()

@property (weak, nonatomic) IBOutlet UIButton *dismissButton;

@end

@implementation CalibrateFieldViewController

- (IBAction)dismissButtonTapped:(id)sender
{
    if ([self.delegate shouldDismissCalibrateFieldView]) {
        [self.delegate dismissCalibrateFieldView];
    }
}

@end

//
//  RoboTestViewController.m
//  UTWHackathon
//
//  Created by Michael Smith on 10/7/14.
//  Copyright (c) 2014 TradeStation. All rights reserved.
//

#import "RoboTestViewController.h"
#import <RobotKit/RobotKit.h>
#import "AppDelegate.h"

@interface RoboTestViewController ()
@property (weak, nonatomic) IBOutlet UIButton *forwardButton;
@property (weak, nonatomic) IBOutlet UIButton *backwardButton;
@property (weak, nonatomic) IBOutlet UIButton *stopButton;
@property (weak, nonatomic) IBOutlet UIButton *redColorButton;
@property (weak, nonatomic) IBOutlet UIButton *blueColorButton;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UIButton *goButton;
@property (weak, nonatomic) IBOutlet UITextField *destinationField;

@end

@implementation RoboTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	[self.forwardButton addTarget:self action:@selector(forwardButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
	[self.backwardButton addTarget:self action:@selector(backwardButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
	[self.stopButton addTarget:self action:@selector(stopButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
	[self.redColorButton addTarget:self action:@selector(redColorButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
	[self.blueColorButton addTarget:self action:@selector(blueColorButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
	
	[self.goButton addTarget:self action:@selector(goButtonPressed) forControlEvents:UIControlEventTouchUpInside];
}


- (IBAction)forwardButtonPressed:(id)sender {
    [RKRollCommand sendCommandWithHeading:0.0 velocity:0.5];
    [self performSelector:@selector(stop) withObject:nil afterDelay:0.4];
}
- (IBAction)stopButtonPressed:(id)sender {
    [self stop];
}

- (void)stop {
    [RKRollCommand sendStop];
}

- (IBAction)backwardButtonPressed:(id)sender {
    [RKRollCommand sendCommandWithHeading:180.0 velocity:0.5];
    [self performSelector:@selector(stop) withObject:nil afterDelay:0.4];
}
- (IBAction)redColorButtonPressed:(id)sender {
	[RKRGBLEDOutputCommand sendCommandWithRed:1.0 green :0.0 blue :0.0];
}
- (IBAction)blueColorButtonPressed:(id)sender {
	[RKRGBLEDOutputCommand sendCommandWithRed:0.0 green :0.0 blue :1.0];
}


- (void)goButtonPressed
{
	NSInteger dest = [self.destinationField.text integerValue];
	Robot* robo = ((AppDelegate*)[UIApplication sharedApplication]).robot;
	[robo move:dest];
	
}
@end

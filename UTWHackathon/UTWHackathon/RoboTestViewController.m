//
//  RoboTestViewController.m
//  UTWHackathon
//
//  Created by Michael Smith on 10/7/14.
//  Copyright (c) 2014 TradeStation. All rights reserved.
//

#import "RoboTestViewController.h"

@interface RoboTestViewController ()
@property (weak, nonatomic) IBOutlet UIButton *forwardButton;
@property (weak, nonatomic) IBOutlet UIButton *backwardButton;
@property (weak, nonatomic) IBOutlet UIButton *stopButton;
@property (weak, nonatomic) IBOutlet UIButton *redColorButton;
@property (weak, nonatomic) IBOutlet UIButton *blueColorButton;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;

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
	
}


- (IBAction)forwardButtonPressed:(id)sender {
	
}
- (IBAction)stopButtonPressed:(id)sender {
	
}
- (IBAction)backwardButtonPressed:(id)sender {
	
}
- (IBAction)redColorButtonPressed:(id)sender {
	
}
- (IBAction)blueColorButtonPressed:(id)sender {
	
}

@end

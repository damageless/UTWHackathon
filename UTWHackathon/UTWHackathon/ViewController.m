//
//  ViewController.m
//  UTWHackathon
//
//  Created by Adam Gessel on 10/7/14.
//  Copyright (c) 2014 TradeStation. All rights reserved.
//

#import "ViewController.h"
#import "CalibrateFieldViewController.h"
#import "GameSelectionViewController.h"

@interface ViewController () <CalibrateFieldDelegate, GameSelectionDelegate>

@property (weak, nonatomic) IBOutlet UIButton *calibrateFieldButton;

- (IBAction)calibrateFieldButtonTapped:(id)sender;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)gameSelectionButtonButtonTapped:(id)sender
{
    GameSelectionViewController *gameSelectionVC = (GameSelectionViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"GameSelection"];
    gameSelectionVC.delegate = self;
    
    [self.navigationController pushViewController:gameSelectionVC animated:YES];
}

- (IBAction)calibrateFieldButtonTapped:(id)sender
{
    CalibrateFieldViewController *calibrateFieldVC = (CalibrateFieldViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"CalibrateField"];
    calibrateFieldVC.delegate = self;
    
    
    
    [self.navigationController pushViewController:calibrateFieldVC animated:YES];
}


@end

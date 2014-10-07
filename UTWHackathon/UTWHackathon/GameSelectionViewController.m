//
//  GameSelectionViewController.m
//  UTWHackathon
//
//  Created by Scott Larson on 10/7/14.
//  Copyright (c) 2014 TradeStation. All rights reserved.
//

#import "GameSelectionViewController.h"
#import <RobotKit/RobotKit.h>
#import "AFNetworking.h"
#import "GamePreviewData.h"

@interface GameSelectionViewController ()

@property (strong, nonatomic) NSMutableArray *gamePreviewList;

@end

@implementation GameSelectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [RKRGBLEDOutputCommand sendCommandWithRed:0.0 green :1.0 blue :0.0];
    [self getGameList];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)getGameList
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:@"http://spherosport.herokuapp.com/games" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        for (NSDictionary *dict in responseObject) {
            GamePreviewData *preview = [[GamePreviewData alloc] initWithDictionary:dict];
            [self.gamePreviewList addObject:preview];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

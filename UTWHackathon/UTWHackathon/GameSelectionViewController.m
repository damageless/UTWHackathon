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
#import "GameData.h"

@interface GameSelectionViewController () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) NSMutableArray *gamePreviewList;
@property (strong, nonatomic) GameData *gameData;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation GameSelectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [RKRGBLEDOutputCommand sendCommandWithRed:0.0 green :1.0 blue :0.0];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.gamePreviewList = [NSMutableArray array];
    [self getGameList];
    
    [self getGameInfo:@"FFC97706-E3B3-4224-B602-DD7EBF9D32A6"];
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
        NSArray *games = [responseObject objectForKey:@"games"];
        for (NSDictionary *dict in games) {
            GamePreviewData *preview = [[GamePreviewData alloc] initWithDictionary:dict];
            [self.gamePreviewList addObject:preview];
        }
        
        [self didFinishFetchingGameList];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

- (void)getGameInfo:(NSString *)gameId
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString *url = [NSString stringWithFormat:@"http://spherosport.herokuapp.com/game/%@", gameId];
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        self.gameData = [[GameData alloc] initWithDictionary:responseObject];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

- (void)didFinishFetchingGameList
{
    [self.tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.gamePreviewList.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellReuseIdentifier = @"gameCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellReuseIdentifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellReuseIdentifier];
    }
    
    GamePreviewData *gamePreview = [self.gamePreviewList objectAtIndex:indexPath.row];
    
    cell.textLabel.text = gamePreview.gameName;
    
    return cell;
}

@end

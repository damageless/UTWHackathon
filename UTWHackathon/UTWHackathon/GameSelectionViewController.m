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

@interface GameSelectionViewController () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) NSMutableArray *gamePreviewList;
@property (strong, nonatomic) GameData *gameData;
@property (copy, nonatomic) NSString *currentGameName;

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
    
    if ([self.delegate currentGameName]) {
        self.currentGameName = [self.delegate currentGameName];
    }
    
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

- (void)getGameInfo:(NSString *)gameId withGameName:(NSString *)gameName
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString *url = [NSString stringWithFormat:@"http://spherosport.herokuapp.com/game/%@", gameId];
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        self.gameData = [[GameData alloc] initWithDictionary:responseObject];
        self.gameData.gameName = gameName;
        
        [self.delegate selectedGameData:self.gameData];
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
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    
    GamePreviewData *gamePreview = [self.gamePreviewList objectAtIndex:indexPath.row];
    
    cell.textLabel.text = gamePreview.gameName;
    
    if ([gamePreview.gameName isEqualToString:self.currentGameName]) {
        cell.selected = YES;
    }
    else {
        cell.selected = NO;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    GamePreviewData *previewData = [self.gamePreviewList objectAtIndex:indexPath.row];
    
    self.currentGameName = previewData.gameName;
    [self.tableView reloadData];
    [self getGameInfo:previewData.gameId withGameName:previewData.gameName];
}

@end

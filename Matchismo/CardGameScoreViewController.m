//
//  CardGameScoreViewController.m
//  Matchismo
//
//  Created by Floyd Christofoli on 9/28/13.
//  Copyright (c) 2013 Floyd Christofoli. All rights reserved.
//

#import "CardGameScoreViewController.h"

#import "GameScore.h"
#import "ScoresManager.h"

@interface CardGameScoreViewController ()
@property (strong, nonatomic) NSArray* topScores;
@end

@implementation CardGameScoreViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.topScores = [[ScoresManager sharedInstance] getTopScores];
    // Sort by top score.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.topScores.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    @try {
        static NSString *CellIdentifier = @"ScoreCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];

        GameScore* score = self.topScores[indexPath.row];
        cell.textLabel.text = [NSString stringWithFormat:@"Score: %d Flips: %d", score.score, score.flips];
        cell.detailTextLabel.text = [NSString stringWithFormat:@"Date: %@", score.endDate];
        
        return cell;
    }
    @catch (NSException * e) {
        NSLog(@"Exception: %@", e);
    }
}

@end

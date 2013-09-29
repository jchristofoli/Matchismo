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
    
    self.topScores = [self.topScores sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
        GameScore *first = (GameScore*)a;
        GameScore *second = (GameScore*)b;
        
        if (first.score == second.score)
            return first.flips >= second.flips;
        else
            return first.score < second.score;
    }];
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
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateStyle:NSDateFormatterLongStyle];
        [dateFormatter setTimeStyle:NSDateFormatterMediumStyle];
        [dateFormatter setLocale:[NSLocale currentLocale]];

        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", [dateFormatter stringFromDate:score.endDate]];
        
        return cell;
    }
    @catch (NSException * e) {
        NSLog(@"Exception: %@", e);
    }
}

@end

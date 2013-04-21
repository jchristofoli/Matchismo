//
//  PlayingCard.m
//  Matchismo
//
//  Created by Floyd Christofoli on 4/21/13.
//  Copyright (c) 2013 Floyd Christofoli. All rights reserved.
//

#import "PlayingCard.h"

@implementation PlayingCard

@synthesize suit = _suit;
@synthesize rank = _rank;

+ (NSArray *) rankStrings
{
    return @[@"?", @"A", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"10", @"J", @"Q", @"K"];
}

+ (NSArray *)validSuits
{
    return @[@"♠", @"♥", @"♦", @"♣"];
}

+ (NSUInteger)maxRank
{
    return [self rankStrings].count - 1;
}

- (void) setRank:(NSUInteger)rank
{
    if (rank <= [PlayingCard maxRank])
    {
        _rank = rank;
    }
}

- (NSString *) contents
{
    return [[PlayingCard rankStrings] [self.rank] stringByAppendingString:self.suit];
}

- (void) setSuit:(NSString *)suit
{
    if ([[PlayingCard validSuits] containsObject:suit])
    {
        _suit = suit;
    }
}

- (NSString *)suit
{
    return _suit ? _suit : @"?";
}

@end

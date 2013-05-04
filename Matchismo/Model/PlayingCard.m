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

- (id)copyWithZone:(NSZone *)zone {
    PlayingCard *playingCard = [super copyWithZone:zone];
    playingCard->_suit = [self.suit copyWithZone:zone];
    playingCard->_rank = self.rank;
    return playingCard;
}

- (void) setRank:(NSUInteger)rank
{
    if (rank <= [[self class] maxRank])
    {
        _rank = rank;
    }
}

- (NSString *) contents
{
    return [[[self class] rankStrings] [self.rank] stringByAppendingString:self.suit];
}

- (void) setSuit:(NSString *)suit
{
    if ([[[self class] validSuits] containsObject:suit])
    {
        _suit = suit;
    }
}

- (NSString *)suit
{
    return _suit ? _suit : @"?";
}

- (NSString *) description
{
    return self.contents;
}

- (int)match:(NSArray *)otherCards
{
    int score = 0;
    
    for (id otherCard in otherCards)
    {
        if ([otherCard isKindOfClass:[self class]])
        {
            PlayingCard *otherPlayingCard = (PlayingCard*)otherCard;
            if ([otherPlayingCard.suit isEqualToString:self.suit])
            {
                score += 1;
            }
            else if (otherPlayingCard.rank == self.rank)
            {
                score += 4;
            }
        }
    }

    return score;
}

@end

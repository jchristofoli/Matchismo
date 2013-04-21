//
//  Card.m
//  Matchismo
//
//  Created by Floyd Christofoli on 4/21/13.
//  Copyright (c) 2013 Floyd Christofoli. All rights reserved.
//

#import "Card.h"

@interface Card()

@end

@implementation Card

- (BOOL) isFaceUp
{
    return _faceUp;
}

- (BOOL) isUnplayable
{
    return _unplayable;
}

- (int)match:(NSArray *)otherCards
{
    int score = 0;
    
    for (Card *card in otherCards)
    {
        if ([card.contents isEqualToString:self.contents])
        {
            score++;
        }
    }
    return 0;
}

@end

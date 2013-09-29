//
//  GameScore.m
//  Matchismo
//
//  Created by Floyd Christofoli on 9/28/13.
//  Copyright (c) 2013 Floyd Christofoli. All rights reserved.
//

#import "GameScore.h"

@implementation GameScore

#define END_DATE_KEY (@"END_DATE")
#define FLIPS_KEY (@"FLIPS")
#define SCORE_KEY (@"SCORE")

- (id)initFromPropertyList: (NSDictionary*)propertyList
{
    if (![propertyList isKindOfClass:[NSDictionary class]])
        return nil;

    self = [super init];
    if (self) {
        id scoreId = propertyList[SCORE_KEY];
        _score = [scoreId isKindOfClass:[NSNumber class]] ? [scoreId integerValue] : 0;
        
        id flipsId = propertyList[FLIPS_KEY];
        _flips = [flipsId isKindOfClass:[NSNumber class]] ? [flipsId integerValue] : 0;

        _endDate = propertyList[END_DATE_KEY];
    }
    return self;
}

- (id)asPropertyList
{
    return @{END_DATE_KEY : self.endDate, FLIPS_KEY : @(self.flips), SCORE_KEY : @(self.score)};
}

@end

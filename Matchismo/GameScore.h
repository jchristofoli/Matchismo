//
//  GameScore.h
//  Matchismo
//
//  Created by Floyd Christofoli on 9/28/13.
//  Copyright (c) 2013 Floyd Christofoli. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GameScore : NSObject

@property (nonatomic) NSInteger score;
@property (nonatomic) NSInteger flips;
@property (strong, nonatomic) NSDate* endDate;

- (id)initFromPropertyList: (NSDictionary*)propertyList;
- (id)asPropertyList;

@end

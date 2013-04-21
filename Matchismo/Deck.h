//
//  Deck.h
//  Matchismo
//
//  Created by Floyd Christofoli on 4/21/13.
//  Copyright (c) 2013 Floyd Christofoli. All rights reserved.
//

@class Card;

#import <Foundation/Foundation.h>

@interface Deck : NSObject

- (void)addCard:(Card *)card atTop:(BOOL)atTop;

- (Card *)drawRandomCard;

@end

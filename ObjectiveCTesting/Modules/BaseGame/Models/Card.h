//
//  Card.h
//  ObjectiveCTesting
//
//  Created by Svilen Kirov on 16/08/2022.
//
#import <Foundation/Foundation.h>

#ifndef Card_h
#define Card_h

@interface Card : NSObject

@property (strong, nonatomic) NSString *contents;
@property (nonatomic) BOOL isChosen;
@property (nonatomic) BOOL isMatched;

- (int)match:(NSArray *)otherCards;

@end
#endif /* Card_h */

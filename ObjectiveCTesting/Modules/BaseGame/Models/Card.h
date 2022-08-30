//
//  Card.h
//  ObjectiveCTesting
//
//  Created by Svilen Kirov on 16/08/2022.
//

NS_ASSUME_NONNULL_BEGIN

@interface Card : NSObject

@property (strong, nonatomic) NSString *contents;
@property (nonatomic) BOOL isChosen;
@property (nonatomic) BOOL isMatched;

@end

NS_ASSUME_NONNULL_END

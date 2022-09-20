//
//  Card.h
//  ObjectiveCTesting
//
//  Created by Svilen Kirov on 16/08/2022.
//

NS_ASSUME_NONNULL_BEGIN

/// Base class used to define the common behaviour for other `Card` objects.
@interface Card : NSObject

/// Shows whether the `Card` is chosen.
@property (nonatomic) BOOL isChosen;
/// Shows whether the `Card` is matched.
@property (nonatomic) BOOL isMatched;

@end

NS_ASSUME_NONNULL_END

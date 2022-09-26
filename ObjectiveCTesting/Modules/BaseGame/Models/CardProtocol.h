//
//  Card.h
//  ObjectiveCTesting
//
//  Created by Svilen Kirov on 16/08/2022.
//

NS_ASSUME_NONNULL_BEGIN

/// Protocol used to define the common behaviour for `Card` objects.
@protocol CardProtocol <NSObject>

/// Shows whether the `Card` is selected.
@property (nonatomic) BOOL isSelected;
/// Shows whether the `Card` is matched.
@property (nonatomic) BOOL isMatched;

@end

NS_ASSUME_NONNULL_END

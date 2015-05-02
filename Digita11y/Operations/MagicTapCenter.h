#import <Foundation/Foundation.h>

@protocol MagicTapProtocol
- (int)magicTapPriority;
- (BOOL)magicTapStart;
- (BOOL)magicTapPause;
@end

@interface MagicTapCenter : NSObject
+ (MagicTapCenter *)sharedInstance;
- (void)registerObserver:(id<MagicTapProtocol>)observer;
- (void)deRegisterObserver:(id<MagicTapProtocol>)observer;
- (BOOL)execute;
@end

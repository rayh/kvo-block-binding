#import <Foundation/Foundation.h>

typedef void (^KVOBindingBlock)(NSDictionary *change);

@interface KVOBlockBinding : NSObject
@property (nonatomic, retain) NSString *keyPath;
@property (nonatomic, copy) KVOBindingBlock block;
@property (nonatomic, assign) id observed;
@end

@interface NSObject (KVOBlockBinding)

/*
 * Observe the keypath with the provided block while the returned object is retained
 *
 * @param keyPath The keypath of the property to observe using KVO
 * @param options The ORd set of NSKeyValueObservingOptions
 * @param block the block that should be invoked when the keyPath changes
 * @return An object that should be retained while the observation is needed
 */
-(id)addObserverForKeyPath:(NSString*)keyPath 
                                 options:(NSKeyValueObservingOptions)options 
                                   block:(KVOBindingBlock)block;

/*
 * Same as above, except the default options are set to NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld
 *
 * @param keyPath The keypath of the property to observe using KVO
 * @param block the block that should be invoked when the keyPath changes
 * @return An object that should be retained while the observation is needed
 */
-(id)addObserverForKeyPath:(NSString*)keyPath 
                                   block:(KVOBindingBlock)block;

@end

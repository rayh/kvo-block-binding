#import <Foundation/Foundation.h>

typedef void (^KVOBindingBlock)(NSDictionary *change);

@interface KVOBlockBinding : NSObject {
    BOOL valid;
}
@property (nonatomic, retain) NSString *keyPath;
@property (nonatomic, copy) KVOBindingBlock block;
@property (nonatomic, assign) id observed;

/**
 * If a reference to the binding is kept by the caller to addObserver... then it can use this method to selectively just 
 * remove this binding, and leave all others for the same keypath intact
 */
- (void)invalidate;

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
- (KVOBlockBinding*)addObserverForKeyPath:(NSString*)keyPath 
                                  options:(NSKeyValueObservingOptions)options 
                                    block:(KVOBindingBlock)block;

/*
 * Same as above, except the default options are set to NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld
 *
 * @param keyPath The keypath of the property to observe using KVO
 * @param block the block that should be invoked when the keyPath changes
 * @return An object that should be retained while the observation is needed
 */
- (KVOBlockBinding*)addObserverForKeyPath:(NSString*)keyPath 
                                    block:(KVOBindingBlock)block;

/**
 * Remove all block-based observers for the specified keypath on this object.
 *
 * @param keyPath The keypath of the property from which to remove observers
 */
- (void)removeBlockBasedObserverForKeyPath:(NSString*)keyPath;

/**
 * Remove all block-based observers from this object.  This does not affect traditional KVO observers.
 */
- (void)removeAllBlockBasedObservers;

@end

#import <Foundation/Foundation.h>

typedef void (^KVOBindingBlock)(NSDictionary *change);

@interface KVOBlockBinding : NSObject {
    BOOL valid;
}
@property (nonatomic, assign) id owner;
@property (nonatomic, retain) NSString *keyPath;
@property (nonatomic, copy) KVOBindingBlock block;
@property (nonatomic, assign) id observed;

/**
 * If a reference to the binding is kept by the caller to addObserver... then it can use this method to selectively just 
 * remove this binding, and leave all others for the same keypath intact
 */
- (void)invalidate;

/**
 * Invoke the callback block directly.  This can be used to force your UI to update after setting up the binding
 */
- (void)invoke;

@end

@interface NSObject (KVOBlockBinding)

/**
 * Observe the keypath with the provided block while the returned object is retained
 *
 * @param keyPath The keypath of the property to observe using KVO
 * @param owner The owner of this binding, used to unbind all observers for a particular owner
 * @param options The ORd set of NSKeyValueObservingOptions
 * @param block the block that should be invoked when the keyPath changes
 * @return An object that should be retained while the observation is needed
 */
- (KVOBlockBinding*)addObserverForKeyPath:(NSString*)keyPath 
                                    owner:(id)owner
                                  options:(NSKeyValueObservingOptions)options 
                                    block:(KVOBindingBlock)block;

/**
 * Same as above, except the default options are set to NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld
 *
 * @param keyPath The keypath of the property to observe using KVO
 * @param owner The owner of this binding, used to unbind all observers for a particular owner
 * @param block the block that should be invoked when the keyPath changes
 * @return An object that should be retained while the observation is needed
 */
- (KVOBlockBinding*)addObserverForKeyPath:(NSString*)keyPath 
                                    owner:(id)owner
                                    block:(KVOBindingBlock)block;

/**
 * Remove all block-based observers for the specified keypath on this object.
 *
 * @param keyPath The keypath of the property from which to remove observers
 */
- (void)removeAllBlockBasedObserversForKeyPath:(NSString*)keyPath;

/**
 * Remove all block-based observers from this object.  This does not affect traditional KVO observers.
 */
- (void)removeAllBlockBasedObservers;


/**
 * Remove all block-based observers for the given owner, this should be called in dealloc to make sure that all bindings for an object are
 * discarded
 */
- (void)removeAllBlockBasedObserversForOwner:(id)owner;

@end

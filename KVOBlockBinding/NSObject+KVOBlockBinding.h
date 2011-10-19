#import <Foundation/Foundation.h>

typedef void (^WSObservationBlock)(id observed, NSDictionary *change);

@interface WSObservationBinding : NSObject {
    BOOL valid;
}
@property (nonatomic, assign) id owner;
@property (nonatomic, retain) NSString *keyPath;
@property (nonatomic, copy) WSObservationBlock block;
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

@interface NSObject (WSObservation)

- (void)removeAllObservationsOn:(id)object;
- (void)removeAllObservations;
- (WSObservationBinding*)observe:(id)object 
                         keyPath:(NSString *)keyPath
                         options:(NSKeyValueObservingOptions)options 
                           block:(WSObservationBlock)block;

- (WSObservationBinding*)observe:(id)object 
                         keyPath:(NSString *)keyPath
                           block:(WSObservationBlock)block;
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
- (WSObservationBinding*)addObserverForKeyPath:(NSString*)keyPath 
                                         owner:(id)owner
                                       options:(NSKeyValueObservingOptions)options 
                                         block:(WSObservationBlock)block;

/**
 * Same as above, except the default options are set to NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld
 *
 * @param keyPath The keypath of the property to observe using KVO
 * @param owner The owner of this binding, used to unbind all observers for a particular owner
 * @param block the block that should be invoked when the keyPath changes
 * @return An object that should be retained while the observation is needed
 */
- (WSObservationBinding*)addObserverForKeyPath:(NSString*)keyPath 
                                         owner:(id)owner
                                         block:(WSObservationBlock)block;

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

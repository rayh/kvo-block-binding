#import <Foundation/Foundation.h>

typedef void (^WSObservationBlock)(id observed, NSDictionary *change);

@interface WSObservationBinding : NSObject

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

/**
 * Remove all block-based observers for the specified object.
 *
 * @param object the object to stop observing
 */
- (void)removeAllObservationsOn:(id)object;

/**
 * Remove all block-based observerations.  This does not affect traditional KVO observers.
 */
- (void)removeAllObservations;


/**
 * Remove all block-based observers for the specified object and keypath.
 *
 * @param object the object to stop observing
 * @param keyPath The keypath of the property from which to remove observers
 */
- (void)removeAllObserverationsOn:(id)object keyPath:(NSString*)keyPath;

/**
 * Observe the keypath with the provided block while the returned object is retained
 *
 * @param object The object to observe
 * @param keyPath The keypath of the property to observe using KVO
 * @param options The ORd set of NSKeyValueObservingOptions
 * @param block the block that should be invoked when the keyPath changes
 * @return An object representing the binding, this does NOT need to be retained
 */
- (WSObservationBinding*)observe:(id)object 
                         keyPath:(NSString *)keyPath
                         options:(NSKeyValueObservingOptions)options 
                           block:(WSObservationBlock)block;

/**
 * Same as above, except the default options are set to NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld
 *
 * @param object The object to observe
 * @param keyPath The keypath of the property to observe using KVO
 * @param block the block that should be invoked when the keyPath changes
 * @return An object representing the binding, this does NOT need to be retained
 */
- (WSObservationBinding*)observe:(id)object 
                         keyPath:(NSString *)keyPath
                           block:(WSObservationBlock)block;

/**
 * Sets up keypath binding between the source and target objects.  
 *
 * @param source The source object to observe
 * @param sourcePath The keypath of the property to observe on the source using KVO
 * @param target The target object to observe
 * @param targetPath The keypath of the property to observe on the target using KVO
 * @return An array containing the binding and it's reverse, if specified. This does NOT need to be retained
 */
- (NSMutableArray *) bind:(id)source keyPath:(NSString *)sourcePath to:(id) target keyPath:(NSString *)targetPath addReverseBinding:(BOOL)addReverseBinding;
@end

@interface NSObject (KVOBlockBinding)

/**
 * Observe the keypath with the provided block while the returned object is retained
 *
 * @param keyPath The keypath of the property to observe using KVO
 * @param owner The owner of this binding, used to unbind all observers for a particular owner
 * @param options The ORd set of NSKeyValueObservingOptions
 * @param block the block that should be invoked when the keyPath changes
 * @return An object representing the binding, this does NOT need to be retained
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
 * @return An object representing the binding, this does NOT need to be retained
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

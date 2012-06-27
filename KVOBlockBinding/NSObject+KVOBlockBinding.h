#import <Foundation/Foundation.h>
#import "WSObservationBinding.h"


/** 
 This interface is deprecated in favour of WSObservation
 **/
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

//
//  NSObject+WSObservation.h
//  Local
//
//  Created by Ray Hilton on 27/06/12.
//  Copyright (c) 2012 Wirestorm Pty Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WSObservationBinding.h"
#import "EXTKeyPathCoding.h"

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

@end

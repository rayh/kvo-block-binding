//
//  WSObservationBinding.h
//  Local
//
//  Created by Ray Hilton on 27/06/12.
//  Copyright (c) 2012 Wirestorm Pty Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^WSObservationBlock)(id observed, NSDictionary *change);

@interface WSObservationBinding : NSObject
@property (nonatomic, assign) BOOL valid;
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
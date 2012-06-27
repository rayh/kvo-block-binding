//
//  NSObject+WSKeyPathBinding.h
//  Local
//
//  Created by Ray Hilton on 27/06/12.
//  Copyright (c) 2012 Wirestorm Pty Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (WSKeyPathBinding)
/**
 * Sets up keypath binding between the source and target objects.  
 *
 * @param source The source object to observe
 * @param sourcePath The keypath of the property to observe on the source using KVO
 * @param target The target object to observe
 * @param targetPath The keypath of the property to observe on the target using KVO
 * @return An array containing the binding and it's reverse, if specified. This does NOT need to be retained
 */
- (void)bindSourceKeyPath:(NSString *)sourcePath 
                       to:(id)target
            targetKeyPath:(NSString *)targetPath
           reverseMapping:(BOOL)reverseMapping;

- (void)unbindAllKeyPaths;

- (void)unbindKeyPath:(NSString*)keyPath;
@end

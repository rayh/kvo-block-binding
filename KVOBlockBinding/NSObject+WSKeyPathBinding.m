//
//  NSObject+WSKeyPathBinding.m
//  Local
//
//  Created by Ray Hilton on 27/06/12.
//  Copyright (c) 2012 Wirestorm Pty Ltd. All rights reserved.
//

#import "NSObject+WSKeyPathBinding.h"
#import "NSObject+WSObservation.h"
#import <objc/runtime.h>


#define ASSOCIATED_OBJ_BINDINGS_KEY @"rayh_block_based_bindings"

@implementation NSObject (WSKeyPathBinding)

-(NSMutableArray*)allKeyPathBindings
{
	NSMutableArray *objects = objc_getAssociatedObject(self, ASSOCIATED_OBJ_BINDINGS_KEY);
    if(!objects) {
        objects = [NSMutableArray array];
        objc_setAssociatedObject(self, ASSOCIATED_OBJ_BINDINGS_KEY, objects, OBJC_ASSOCIATION_RETAIN);
    }
    
    return objects;
}


- (void)bindSourceKeyPath:(NSString *)sourcePath to:(id)target targetKeyPath:(NSString *)targetPath reverseMapping:(BOOL)reverseMapping
{
    [[self allKeyPathBindings] addObject:[self observe:self keyPath:sourcePath block:^(id observed, NSDictionary *change) {
        [target setValue:[change valueForKey:NSKeyValueChangeNewKey] forKey:targetPath];
    }]];
    
    if(reverseMapping)
    {
        [[self allKeyPathBindings] addObject:[self observe:target keyPath:targetPath block:^(id observed, NSDictionary *change) {
            [self setValue:[change valueForKey:NSKeyValueChangeNewKey] forKey:sourcePath];
        }]];
    }
}

- (void)unbindKeyPath:(NSString *)keyPath
{
    NSArray *bindings = [self allKeyPathBindings];
    for(WSObservationBinding *binding in bindings)
    {
        if([binding.keyPath isEqualToString:keyPath])
        {
            [binding invalidate];
            binding.block = nil;
            [[self allKeyPathBindings] removeObject:binding];
        }
    }
}

- (void)unbindAllKeyPaths
{
    for(WSObservationBinding *binding in [self allKeyPathBindings])
    {
        [binding invalidate];
        binding.block = nil;
    }
    
    [[self allKeyPathBindings] removeAllObjects];
}
@end

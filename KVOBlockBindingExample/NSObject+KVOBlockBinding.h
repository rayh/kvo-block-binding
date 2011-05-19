#import <Foundation/Foundation.h>

typedef void (^KVOBindingBlock)(NSDictionary *change);

@interface KVOBlockBinding : NSObject
@property (nonatomic, retain) NSString *keyPath;
@property (nonatomic, copy) KVOBindingBlock block;
@property (nonatomic, assign) id observed;
@end

@interface NSObject (KVOBlockBinding)

-(KVOBlockBinding*)addObserverForKeyPath:(NSString*)keyPath 
                                 options:(NSKeyValueObservingOptions)options 
                                   block:(KVOBindingBlock)block;

-(KVOBlockBinding*)addObserverForKeyPath:(NSString*)keyPath 
                                   block:(KVOBindingBlock)block;

@end

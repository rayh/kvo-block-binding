## Bind blocks to properties using KVO

This repo contains a simple category, NSObject+KVOBlockBinding, and an example project.  The category adds methods for observing a keypath using a block:

`
-(KVOBlockBinding*)addObserverForKeyPath:(NSString*)keyPath
                                 options:(NSKeyValueObservingOptions)options
                                   block:(KVOBindingBlock)block;`
`

`
-(KVOBlockBinding*)addObserverForKeyPath:(NSString*)keyPath 
                                   block:(KVOBindingBlock)block;
`

The second method simply calls the first with the default observing options of NSKeyValueObservingOptionNew & NSKeyValueObservingOptionOld

To remove the bindings, there are two methods

`
- (void)removeBlockBasedObserverForKeyPath:(NSString*)keyPath;
`

`
- (void)removeAllBlockBasedObservers;
`

Which will remove all observers for a particular keypath, or all observers on the object respectively.

Also, unlike the normal addObserver methods for KVO, these ones return an object that can be stored (assign or weak) by the caller.  This object has a single method, `invalidate`, which allows the caller to selectively remove a particular binding without affecting any others on the same object.

The example project shows a typical use case of binding a model object's properies to a couple of UILabels and using both `invalidate` and `remove*` methods to control observation.

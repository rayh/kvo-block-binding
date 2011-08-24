## Bind blocks to properties using KVO

This repo contains a simple category, NSObject+KVOBlockBinding, and an example project.  The category adds methods for observing a keypath using a block:

`
-(KVOBlockBinding*)addObserverForKeyPath:(NSString*)keyPath
                                   owner:(id)owner
                                 options:(NSKeyValueObservingOptions)options
                                   block:(KVOBindingBlock)block;`
`

`
-(KVOBlockBinding*)addObserverForKeyPath:(NSString*)keyPath 
                                   owner:(id)owner
                                   block:(KVOBindingBlock)block;
`

The keyPath is the standard ObjectiveC of referencing properties within an object tree (e.g. @"some.path.to.property").  The owner is the object that manages the blocks so that it can remove them all when the object is deallocd.  The options are the same as you would pass for the traditional KVO methods.  The second method simply calls the first with the default observing options of NSKeyValueObservingOptionNew & NSKeyValueObservingOptionOld

To remove the bindings, there are three methods:

This will remove all observers for the owner that was specified when adding:

`
- (void)removeAllBlockBasedObserversForOwner:(id)owner;
`

This will remove all observers for a particular keypath:

`
- (void)removeAllBlockBasedObserversForKeyPath:(NSString*)keyPath;
`

And this will remove ALL block-based observers on the receiver

`
- (void)removeAllBlockBasedObservers;
`

Also, unlike the normal addObserver methods for KVO, these ones return an object that can be stored (assign or weak) by the caller.  This object has a single method, `invalidate`, which allows the caller to selectively remove a particular binding without affecting any others on the same object.

The example project shows a typical use case of binding a model object's properies to a couple of UILabels and using both `invalidate` and `remove*` methods to control observation.

# Bind blocks to properties using KVO

This repo contains a simple category, NSObject+WSObservation, and an example project.  The category adds methods for observing a keypath using a block:


    - (WSObservationBinding*)observe:(id)object 
                             keyPath:(NSString *)keyPath
                             options:(NSKeyValueObservingOptions)options 
                               block:(WSObservationBlock)block;

    - (WSObservationBinding*)observe:(id)object 
                             keyPath:(NSString *)keyPath
                               block:(WSObservationBlock)block;


The observer is the receiver of the message. The object is the object to observe. The keyPath is the standard ObjectiveC of referencing properties within an object tree (e.g. `@"some.path.to.property"`). The options are the same as you would pass for the traditional KVO methods.  The second method simply calls the first with the default observing options of `NSKeyValueObservingOptionNew & NSKeyValueObservingOptionOld`

To remove the bindings, there are three methods:

This will remove all observations on the specified object for the receiver of the message:


    - (void)removeAllObservationsOn:(id)object;


This will remove all observations on the receiver on a specified object for a particular keypath:


    - (void)removeAllObserverationsOn:(id)object keyPath:(NSString*)keyPath;


And this will remove ALL block-based observations on the receiver


    - (void)removeAllObservations;


Also, unlike the normal addObserver methods for KVO, these ones return an object that can be stored (assign or weak) by the caller.  This object has method, `invalidate`, which allows the caller to selectively remove a particular binding without affecting any others on the same object.

There is also an `invoke` method that will force the binding block to execute.

The example project shows a typical use case of binding a model object's properties to a couple of UILabels and using both `invalidate` and `remove*` methods to control observation.

## Refactor Safe Keypaths

The repo also contains code from Justin Spahr-Summers' [libextobjc](https://github.com/jspahrsummers/libextobjc) library to allow refactor safe keypaths. Using a string like `@"some.path.to.property"` could lead to issues when the property name changes and the compiler is not giving any warnings telling you that your KVO binding just broke.

     [self observe:self keyPath:@keypath(self.value) block:^(ViewController* observed, NSDictionary *change) {
         self.label.text = [NSString stringWithFormat:@"%f", observed.value];
     }];
     
     [self observe:self keyPath:@keypath(self, value) block:^(ViewController* observed, NSDictionary *change) {
         self.label.text = [NSString stringWithFormat:@"%f", observed.value];
     }];
     
     [self observe:self keyPath:@keypath(self, container.value) block:^(MyObject* observed, NSDictionary *change) {
         self.label.text = [NSString stringWithFormat:@"%f", observed.value];
     }];
     
     [self observe:self.container keyPath:@keypath(self.container, value) block:^(MyObject. observed, NSDictionary *change) {
         self.containerLabel.text = [NSString stringWithFormat:@"%f", observed.value];
     }];

# License

## Contains code from libextobjc

Released under the MIT License. See the
[LICENSE](https://github.com/jspahrsummers/libextobjc/blob/master/LICENSE.md)
file for more information.
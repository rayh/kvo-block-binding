#import "KVOBlockBindingViewController.h"
#import "ExampleModel.h"
#import "NSObject+KVOBlockBinding.h"

@implementation KVOBlockBindingViewController
@synthesize model;
@synthesize label1Binding;
@synthesize label2Binding;

- (void)dealloc
{
    self.model = nil;
    [super dealloc];
}

-(void)bindObservers 
{
    self.label1Binding = [self.model addObserverForKeyPath:@"exampleValue1" block:^(NSDictionary *change) {
        label1.text = [NSString stringWithFormat:@"%d", self.model.exampleValue1];
    }];
    
    self.label2Binding = [self.model addObserverForKeyPath:@"exampleValue2" block:^(NSDictionary *change) {
        label2.text = [NSString stringWithFormat:@"%@ -> %@", [change valueForKey:NSKeyValueChangeOldKey] , [change valueForKey:NSKeyValueChangeNewKey]];
    }];
}
		
-(void)viewDidLoad 
{
    self.model = [[[ExampleModel alloc] init] autorelease];
    self.model.exampleValue1 = 0;
    self.model.exampleValue2 = 0;

    label1.text = @"0";
    label2.text = @"0";
    
    [self bindObservers];
}


-(IBAction)pressMeButtonPressed:(id)sender 
{
    self.model.exampleValue1+=1;
    self.model.exampleValue2+=2;
}

-(IBAction)stopObservingButtonPressed:(UIButton*)sender 
{
    if(self.label1Binding) {
        self.label1Binding = nil;
        self.label2Binding = nil;
        [sender setTitle:@"Start Observing" forState:UIControlStateNormal];
    } else {
        [self bindObservers];
        [sender setTitle:@"Stop Observing" forState:UIControlStateNormal];
    }
}

@end

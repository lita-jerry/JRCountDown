//
//  secondViewController.m
//  JRCountDownButton
//

#import "secondViewController.h"
#import "NSObject+JRCountDown.h"

@interface secondViewController ()
@property (weak, nonatomic) IBOutlet UILabel *showLabel;

@end

@implementation secondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)buttonClick:(UIButton *)sender {
    __weak __typeof(self)weakSelf = self;
    [[self.showLabel jr_configureWithCountDownTime:5.f intervalTime:0.01 whileExecutingBlock:^(NSObject* selfInstance, CGFloat SurplusSec) {
        [(UIButton *)selfInstance setEnabled:NO];
        [weakSelf.showLabel setText:[NSString stringWithFormat:@"You still have %.2f seconds to buy it", SurplusSec]];
    } completionBlock:^(NSObject* selfInstance){
        [(UIButton *)selfInstance setEnabled:YES];
        NSLog(@"countdown start");
        [self performSelectorOnMainThread:@selector(completion) withObject:nil waitUntilDone:YES];
    }] jr_start];
}

- (void)completion{
    [self.showLabel setText:@"buy it now"];
}

@end


#import "NativeSecondVC.h"

@interface NativeSecondVC ()

@end

@implementation NativeSecondVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}


- (IBAction)clickDismiss:(UIButton *)sender {
    if (self.navigationController != nil) {
        [self.navigationController popViewControllerAnimated:YES];
    }else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

@end

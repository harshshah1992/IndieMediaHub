//
//  SplashScreenVC.m
//  JackPotz


#import "SplashScreenVC.h"
#import "LoginVC.h"

@interface SplashScreenVC ()
@property (strong, nonatomic) IBOutlet UIImageView *imgSplash;

@end

@implementation SplashScreenVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    if([[UIScreen mainScreen] bounds].size.height==568) {
        self.imgSplash.image=[UIImage imageNamed:@"Default-568h.png"];
    }else   if([[UIScreen mainScreen] bounds].size.height==667) {
        self.imgSplash.image=[UIImage imageNamed:@"Default-667h@2x.png"];
    }else   if([[UIScreen mainScreen] bounds].size.height==736) {
        self.imgSplash.image=[UIImage imageNamed:@"Default-736h@3x.png"];
    }else {
        self.imgSplash.image=[UIImage imageNamed:@"Default.png"];
    }
    
    self.navigationController.navigationBarHidden = YES;
    int64_t delayInSeconds = 2.0;//delay
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^{
        [self pushtoNextScreen];
    });
    
}

//-(void)viewWillDisappear:(BOOL)animated{
//    
//    self.navigationController.navigationBarHidden = NO;
//
//}

-(void) pushtoNextScreen {
    LoginVC *loginObj =[CustomUtility getViewController:@"LoginVC"];
    [self.navigationController pushViewController:loginObj animated:YES];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

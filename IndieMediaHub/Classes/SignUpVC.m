//
//  SignUpVC.m
//  IndieMediaHub
//
//  Created by harsh on 24/10/15.
//  Copyright (c) 2015 harsh. All rights reserved.
//

#import "SignUpVC.h"

@interface SignUpVC ()
@property (strong, nonatomic) IBOutlet CustomScrollView *signupScrollView;

@end

@implementation SignUpVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.signupScrollView setContentSize:CGSizeMake(320, 680)];
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

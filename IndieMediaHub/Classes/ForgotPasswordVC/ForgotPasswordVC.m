//
//  ForgotPasswordVC.m
//  Gambay
//
//  Created by trainee on 9/12/15.
//  Copyright (c) 2015 www. All rights reserved.
//

#import "ForgotPasswordVC.h"
#import "LoginVC.h"

@interface ForgotPasswordVC ()

@property (strong , nonatomic)UIButton *leftButton;
@property (strong , nonatomic)IBOutlet UITextField *txtEmail;
@property (strong , nonatomic)IBOutlet CustomScrollView *forgotPwdScrollView;

@end

@implementation ForgotPasswordVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:NO];
    [self.forgotPwdScrollView setContentSize:CGSizeMake(320, 590)];
    [self addNavigationBar];
}

-(void)addNavigationBar
{
    self.title = @"G A M B A Y*";
    self.navigationItem.hidesBackButton = YES;
    
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                       target:nil action:nil];
    negativeSpacer.width = -16;
    
    self.leftButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [self.leftButton setImage:[UIImage imageNamed:@"btn_back_normal.png"] forState:UIControlStateNormal];
    [self.leftButton setImage:[UIImage imageNamed:@"btn_back_highlighted.png"] forState:UIControlStateHighlighted];
    self.leftButton.frame=CGRectMake(2, 2, 30 , 30);
    [self.leftButton addTarget:self action:@selector(pushToLogin) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backNavigationButton=[[UIBarButtonItem alloc]initWithCustomView:self.leftButton];
    [self.navigationItem setLeftBarButtonItems:[NSArray arrayWithObjects:negativeSpacer,backNavigationButton, nil] animated:YES];
    
    self.navigationController.navigationBar.translucent = NO;
}

- (void)pushToLogin {
   
    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
}

#pragma mark - Text Field Delegates
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if (textField == self.txtEmail) {
        //on next click cursor will go to password text field
        [self.txtEmail resignFirstResponder];
    }
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if ([string isEqualToString:@" "]) {
        return NO;
    } else {
        return YES;
    }
    
}

#pragma mark - Button Actions 
- (IBAction)btnSubmitClick:(id)sender {
    
    if ([self.txtEmail.text length] == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Please enter Email" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alert showWithCompletion:^(UIAlertView *alertView, NSInteger buttonIndex) {
            if (buttonIndex == 0) {
                [self.txtEmail becomeFirstResponder];
            }
        }];
    } else if (![[HBValidations sharedInstance] isEmailValid:self.txtEmail.text]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Please enter valid Email" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alert showWithCompletion:^(UIAlertView *alertView, NSInteger buttonIndex) {
            if (buttonIndex == 0) {
                [self.txtEmail becomeFirstResponder];
            }
        }];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Password reset successfully" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alert showWithCompletion:^(UIAlertView *alertView, NSInteger buttonIndex) {
            if (buttonIndex == 0) {
                UINavigationController *navController = [CustomUtility getViewController:@"LoginVC"];
                [self.navigationController pushViewController:navController animated:YES];
            }
        }];
    }
}
- (IBAction)btnForgotPasswordClicked:(id)sender {
    if ([self.txtForgotPassword.text length] == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Please enter Email" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alert showWithCompletion:^(UIAlertView *alertView, NSInteger buttonIndex) {
            if (buttonIndex == 0) {
                [self.txtForgotPassword becomeFirstResponder];
            }
        }];
    } else if (![[HBValidations sharedInstance] isEmailValid:self.txtForgotPassword.text]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Please enter valid Email" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alert showWithCompletion:^(UIAlertView *alertView, NSInteger buttonIndex) {
            if (buttonIndex == 0) {
                [self.txtForgotPassword becomeFirstResponder];
            }
        }];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Password reset successfully" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alert showWithCompletion:^(UIAlertView *alertView, NSInteger buttonIndex) {
            if (buttonIndex == 0) {
                UINavigationController *navController = [CustomUtility getViewController:@"LoginVC"];
                [self.navigationController pushViewController:navController animated:YES];
            }
        }];
    }
}
@end

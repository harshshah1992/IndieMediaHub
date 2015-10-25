//
//  LoginVC.m
//  Gambay
//
//  Created by trainee on 9/12/15.
//  Copyright (c) 2015 www. All rights reserved.
//

#import "LoginVC.h"
#import "ForgotPasswordVC.h"

@interface LoginVC ()

@property (strong , nonatomic)IBOutlet CustomScrollView *loginScrollView;
@property (strong , nonatomic)IBOutlet UITextField *txtEmail;
@property (strong , nonatomic)IBOutlet UITextField *txtPassword;

@end

@implementation LoginVC

#pragma mark - View Life Cycle Delegates
- (void)viewDidLoad {
    [super viewDidLoad];
  
    //to set navigation title
    self.title = @"G A M B A Y*";
    
    //since navigation bar was hidden in previous screen so to show it in this screen
    self.navigationController.navigationBarHidden = YES;
    
    self.navigationItem.hidesBackButton = YES;
    
    //to set scroll content size
    [self.loginScrollView setContentSize:CGSizeMake(320, 680)];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:NO];
    [self.navigationController setNavigationBarHidden:YES];
}

#pragma mark - Text Field Delegates


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if (textField == self.txtEmail) {
        [self becomeFirstResponder:self.txtPassword andBecomelastResponder:self.txtEmail];
    } else if (textField == self.txtPassword){
        [self.txtPassword resignFirstResponder];
    }
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    //dont allow space in textfield
    if ([string isEqualToString:@" "]) {
        return NO;
    } else {
       return YES;
    }
    
}

#pragma mark - Button Action 
- (IBAction)btnSignInClick:(id)sender {
    
    if ([self.txtEmail.text length] == 0) {
        [self showAlertViewWithMessage:@"Please enter Email" textFieldBecomeFirstResponder:self.txtEmail];
    } else if (![[HBValidations sharedInstance] isEmailValid:self.txtEmail.text]){
        [self showAlertViewWithMessage:@"Please enter valid Email" textFieldBecomeFirstResponder:self.txtEmail];
    } else if ([self.txtPassword.text length] == 0){
        [self showAlertViewWithMessage:@"Please enter Password" textFieldBecomeFirstResponder:self.txtPassword];
    } else {
        [self.txtEmail resignFirstResponder];
        [self.txtPassword resignFirstResponder];
        //        [self pushToSidePannel];
    }
}

- (IBAction)btnForgotPasswordClick:(id)sender {
    
    UIViewController *vc = [CustomUtility getViewController:@"ForgotPasswordVC"];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - reusable methods

- (IBAction)pushToChangePws:(id)sender {
    UIViewController *vc = [CustomUtility getViewController:@"ChangePasswordVC"];
    [self.navigationController pushViewController:vc animated:YES];
}
- (IBAction)pushToRegister:(id)sender {
    UIViewController *vc = [CustomUtility getViewController:@"SignUpVC"];
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)pushToSidePannel {
    /*
    WalkThroughVC*contentVC = [[WalkThroughVC alloc] initWithNibName:@"WalkThroughVC" bundle:nil];
    UINavigationController* contentNavigationController = [[UINavigationController alloc] initWithRootViewController:contentVC];
    SideMenuVC *menuVC = [[SideMenuVC alloc] initWithNibName:@"SideMenuVC" bundle:nil];
    
    MVYSideMenuOptions *options = [[MVYSideMenuOptions alloc] init];
    options.contentViewScale = 1.0;
    options.contentViewOpacity = 0.4;
    options.shadowOpacity = 0.0;
    MVYSideMenuController *sideMenuController = [[MVYSideMenuController alloc] initWithMenuViewController:menuVC contentViewController:contentNavigationController options:options];
    sideMenuController.menuFrame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    [self.navigationController setNavigationBarHidden:YES];
    [self.navigationController pushViewController:sideMenuController animated:YES];*/
    
}

- (void) becomeFirstResponder:(UITextField *)firstResponder andBecomelastResponder:(UITextField *)lastResponder {
    [firstResponder becomeFirstResponder];
    [lastResponder resignFirstResponder];
    
}

- (void)showAlertViewWithMessage:(NSString *)stringMessage textFieldBecomeFirstResponder:(UITextField *)txtField {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:stringMessage delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
    [alert showWithCompletion:^(UIAlertView *alertView, NSInteger buttonIndex) {
        if (buttonIndex == 0) {
            [txtField becomeFirstResponder];
        }
    }];
}

- (void) viewWillDisappear:(BOOL)animated {
    //[self.navigationController setNavigationBarHidden:NO];
}



@end

//
//  IAPHelper.m
//  //
// Created by Manikanta Chintapalli on 9/3/15.
//


#import "IAPHelper.h"
#import <StoreKit/StoreKit.h>
#import "AppDelegate.h"
#import "MBProgressHUD.h"

NSString *const IAPHelperProductPurchasedNotification = @"IAPHelperProductPurchasedNotification";


@interface IAPHelper () <SKProductsRequestDelegate, SKPaymentTransactionObserver>

@property (strong , nonatomic)  SKProductsRequest * productsRequest;
@property (strong , nonatomic)  RequestProductsCompletionHandler completionHandler;
@property (strong , nonatomic)  BuyProductCompletionHandler buyingHandler;
@property (strong , nonatomic)  RestoreProductCompletionHandler restoreHandler;
@property (strong , nonatomic)  NSSet * productIdentifiers;
@property (strong , nonatomic)  NSMutableSet * purchasedProductIdentifiers;
@property (strong , nonatomic)  UIActivityIndicatorView *indicator;
@property (strong , nonatomic)   UIView *viewIndicator;

@end


@implementation IAPHelper
- (id)initWithProductIdentifiers:(NSSet *)productIdentifiers {
    
    if ((self = [super init])) {
        // Store product identifiers
        self.productIdentifiers = productIdentifiers;
        // Check for previously purchased products
        self.purchasedProductIdentifiers = [NSMutableSet set];
        for (NSString * productIdentifier in self.productIdentifiers) {
            BOOL productPurchased = [[NSUserDefaults standardUserDefaults] boolForKey:productIdentifier];
            if (productPurchased) {
                [self.purchasedProductIdentifiers addObject:productIdentifier];
                NSLog(@"Previously purchased: %@", productIdentifier);
            } else {
                NSLog(@"Not purchased: %@", productIdentifier);
            }
        }
        // Add self as transaction observer
        [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    }
    return self;
}

- (void)requestProductsWithCompletionHandler:(RequestProductsCompletionHandler)completionHandler {
       [self showHud];
    // 1
    self.completionHandler = [completionHandler copy];
    
    // 2
   self.productsRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:self.productIdentifiers];
    self.productsRequest.delegate = self;
    [self.productsRequest start];
    
}
- (BOOL)productPurchased:(NSString *)productIdentifier {
    return [self.purchasedProductIdentifiers containsObject:productIdentifier];
}

-(void)buyNonConsumableProduct:(SKProduct *)product withCompletion:(BuyProductCompletionHandler)completionHandler{
    [self showHud];
    self.buyingHandler = [completionHandler copy];
    NSLog(@"Buying %@...", product.productIdentifier);
    SKPayment * payment = [SKPayment paymentWithProduct:product];
    [[SKPaymentQueue defaultQueue] addPayment:payment];
}

#pragma mark - SKProductsRequestDelegate

- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response {
    
    NSLog(@"Loaded list of products...");
    self.productsRequest = nil;
    
    NSArray * skProducts = response.products;
    for (SKProduct * skProduct in skProducts) {
        NSLog(@"Found product: %@ %@ %0.2f",
              skProduct.productIdentifier,
              skProduct.localizedTitle,
              skProduct.price.floatValue);
    }
    
    self.completionHandler(YES, skProducts);
    self.completionHandler = nil;
        [self hideHud];
    
}

- (void)request:(SKRequest *)request didFailWithError:(NSError *)error {
    
    NSLog(@"Failed to load list of products.");
    self.productsRequest = nil;
    self.completionHandler(NO, nil);
    self.completionHandler = nil;
        [self hideHud];
}

#pragma mark SKPaymentTransactionOBserver

- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions
{
    for (SKPaymentTransaction * transaction in transactions) {
        switch (transaction.transactionState)
        {
            case SKPaymentTransactionStatePurchased:
                [self completeTransaction:transaction];
                break;
            case SKPaymentTransactionStateFailed:
                [self failedTransaction:transaction];
                break;
            case SKPaymentTransactionStateRestored:
                [self restoreTransaction:transaction];
                break;
            case SKPaymentTransactionStatePurchasing:
                break;
            default:
                break;
        }
    }
}

- (void)completeTransaction:(SKPaymentTransaction *)transaction {
    NSLog(@"completeTransaction...");
    [self provideContentForProductIdentifier:transaction.payment.productIdentifier];
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
    self.buyingHandler(YES, transaction);
    self.buyingHandler = nil;
    [self hideHud];
}

- (void)restoreTransaction:(SKPaymentTransaction *)transaction {
    NSLog(@"restoreTransaction...");
        [self provideContentForProductIdentifier:transaction.originalTransaction.payment.productIdentifier];
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
}

- (void)failedTransaction:(SKPaymentTransaction *)transaction {
    NSLog(@"failedTransaction...");
    if (transaction.error.code != SKErrorPaymentCancelled)
    {
        NSLog(@"Transaction error: %@", transaction.error.localizedDescription);
    }
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
   self.buyingHandler(NO, transaction);
   self.buyingHandler = nil;
        [self hideHud];
}



- (void)provideContentForProductIdentifier:(NSString *)productIdentifier {
    [self.purchasedProductIdentifiers addObject:productIdentifier];
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:productIdentifier];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [[NSNotificationCenter defaultCenter] postNotificationName:IAPHelperProductPurchasedNotification object:productIdentifier userInfo:nil];
}

#pragma restore methods

-(void)restoreNonConsumableProductswithCompletion:(RestoreProductCompletionHandler)completionHandler{
    [self showHud];
    self.restoreHandler = [completionHandler copy];
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    [[SKPaymentQueue defaultQueue] restoreCompletedTransactions];
}


- (void)paymentQueue:(SKPaymentQueue *)queue restoreCompletedTransactionsFailedWithError:(NSError *)error {
    NSLog(@"%@",error);
    self.restoreHandler(NO, nil);
    self.restoreHandler = nil;
    [self hideHud];
}



- (void) paymentQueueRestoreCompletedTransactionsFinished:(SKPaymentQueue *)queue
{
    self.restoreHandler(YES, queue);
    self.restoreHandler = nil;
    [self hideHud];

}

// Progress HUD

- (void)showHud{
     UIViewController *viewController = [[UIApplication sharedApplication].delegate window].rootViewController;
    [MBProgressHUD showHUDAddedTo:viewController.view animated:YES];
    [viewController.view setUserInteractionEnabled:NO];
    
}
- (void)hideHud{
    UIViewController *viewController = [[UIApplication sharedApplication].delegate window].rootViewController;
     [MBProgressHUD hideHUDForView:viewController.view animated:YES];
    [viewController.view setUserInteractionEnabled:YES];
}

@end
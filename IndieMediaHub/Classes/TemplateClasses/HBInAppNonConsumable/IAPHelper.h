//
//  IAPHelper.h
//
//
// Created by Manikanta Chintapalli on 9/3/15.
//

#import <StoreKit/StoreKit.h>

UIKIT_EXTERN NSString *const IAPHelperProductPurchasedNotification;

typedef void (^RequestProductsCompletionHandler)(BOOL success, NSArray * products);
//for buy a product
typedef void (^BuyProductCompletionHandler)(BOOL success, SKPaymentTransaction * transaction);
typedef void (^RestoreProductCompletionHandler)(BOOL success, SKPaymentQueue * paymentQueue);


@interface IAPHelper : NSObject

- (id)initWithProductIdentifiers:(NSSet *)productIdentifiers;
- (void)requestProductsWithCompletionHandler:(RequestProductsCompletionHandler)completionHandler;
- (void)buyNonConsumableProduct:(SKProduct *)product withCompletion:(BuyProductCompletionHandler)completionHandler;
- (void)restoreNonConsumableProductswithCompletion:(RestoreProductCompletionHandler)completionHandler;
- (BOOL)productPurchased:(NSString *)productIdentifier;

@end
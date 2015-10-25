//
//  IAPHelper.h
//
//
// Created by Manikanta Chintapalli on 9/3/15.
//

#import <StoreKit/StoreKit.h>

UIKIT_EXTERN NSString *const IAPHelperProductPurchasedNotification;

typedef void (^RequestProductsCompletionHandler)(BOOL success, NSArray * products);
typedef void (^BuyProductCompletionHandler)(BOOL success, SKPaymentTransaction * transaction);
typedef void (^RestoreProductCompletionHandler)(BOOL success, SKPaymentQueue * paymentQueue);


@interface IAPHelper : NSObject

- (id)initWithProductIdentifiers:(NSSet *)productIdentifiers;
//To request valid products we are using this method
- (void)requestProductsWithCompletionHandler:(RequestProductsCompletionHandler)completionHandler;
//To buy a product we can use this method
- (void)buyNonConsumableProduct:(SKProduct *)product withCompletion:(BuyProductCompletionHandler)completionHandler;
//To restore complete products we have we can use this method
- (void)restoreNonConsumableProductswithCompletion:(RestoreProductCompletionHandler)completionHandler;
//To know product purchased or not we can use this method
- (BOOL)productPurchased:(NSString *)productIdentifier;
@end
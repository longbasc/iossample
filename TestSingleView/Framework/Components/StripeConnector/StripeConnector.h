//
//  StripeConnector.h
//  Research
//
//  Created by APAC Dev on 4/21/15.
//  Copyright (c) 2015 APAC Dev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/*
 StripeConnector connect with Malevia Server and process Stripe-related operations
 */

@interface StripeConnector : NSObject
{
    NSString* serverURL;
    NSString* pubKey;
    
    NSString* currentStripeUserID;
    NSString* currentCardUserID;
}

#pragma mark MAIN
- (void) setupInitWithKey:(NSString*)aKey andServerURL:(NSString*)aUrl;

#pragma mark MAIN - compo
- (void) createCardOfStripeUserID:(NSString*)userId number:(NSString*)number name:(NSString*)name expMonth:(int)expMonth expYear:(int)expYear cvc:(NSString*)cvc onDone:(void(^)(id))onDone onError:(void(^)(id))onError;

#pragma mark MAIN - stripe lib
- (void) tokenizeCardNumber:(NSString*)number name:(NSString*)name expMonth:(int)expMonth expYear:(int)expYear cvc:(NSString*)cvc onDone:(void(^)(id))onDone onError:(void(^)(id))onError;

#pragma mark MAIN - malevia connect api
- (void) createStripeUserWithCustomerID:(NSString*)customerID email:(NSString*)email description:(NSString*)description onDone:(void(^)(id))onDone onError:(void(^)(id))onError;
- (void) getStripeUserID:(NSString*)userId onDone:(void(^)(id))onDone onError:(void(^)(id))onError;

- (void) getCardsOfStripeUserID:(NSString*)userId onDone:(void(^)(id))onDone onError:(void(^)(id))onError;
- (void) createCardOfStripeUserID:(NSString*)userId cardToken:(NSString*)cardtoken onDone:(void(^)(id))onDone onError:(void(^)(id))onError;

- (void) updateCardOfStripeUserID:(NSString*)userId cardID:(NSString*)cardId name:(NSString*)name expMonth:(int)expMonth expYear:(int)expYear
                           onDone:(void(^)(id))onDone onError:(void(^)(id))onError;
- (void) removeCardOfStripeUserID:(NSString*)userId cardID:(NSString*)cardId onDone:(void(^)(id))onDone onError:(void(^)(id))onError;

- (void) chargeStripeUserID:(NSString*)userId cardID:(NSString*)cardId amount:(NSInteger)amount currency:(NSString*)currency onDone:(void(^)(id))onDone onError:(void(^)(id))onError;

@end

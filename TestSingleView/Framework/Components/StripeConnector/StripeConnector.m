//
//  StripeConnector.m
//  Research
//
//  Created by APAC Dev on 4/21/15.
//  Copyright (c) 2015 APAC Dev. All rights reserved.
//

#import "Stripe.h"
//#import <Stripe/Stripe.h>
#import "StripeConnector.h"

#define API_CREATE_STRIPE_USER                              @"gateway.php?controller=stripe.create_stripe_user"
#define API_GET_STRIPE_USER                                 @"gateway.php?controller=stripe.get_stripe_user"
#define API_GET_CARDS                                       @"gateway.php?controller=stripe.get_cards"
#define API_CREATE_CARD                                     @"gateway.php?controller=stripe.create_card"
#define API_UPDATE_CARD                                     @"gateway.php?controller=stripe.update_card"
#define API_DELETE_CARD                                     @"gateway.php?controller=stripe.delete_card"
#define API_CHARGE                                          @"gateway.php?controller=stripe.charge"

@interface StripeConnector ()

#pragma mark PRIVATE
- (void) doPostToEndPoint:(NSString*)point params:(id)params onDone:(void(^)(id))onDone onError:(void(^)(id))onError;
@end


@implementation StripeConnector

#pragma mark MAIN
- (void) setupInitWithKey:(NSString*)aKey andServerURL:(NSString*)aUrl
{
    serverURL = aUrl;
    pubKey = aKey;
}

#pragma mark MAIN - compo
- (void) createCardOfStripeUserID:(NSString*)userId number:(NSString*)number name:(NSString*)name expMonth:(int)expMonth expYear:(int)expYear cvc:(NSString*)cvc onDone:(void(^)(id))onDone onError:(void(^)(id))onError
{
    [self tokenizeCardNumber:number name:name expMonth:expMonth expYear:expYear cvc:cvc onDone:^(id objToken) {
        
        [self createCardOfStripeUserID:userId cardToken:[objToken objectForKey:@"tokenId"] onDone:onDone onError:onError];
    
    } onError:onError];
}

#pragma mark MAIN - stripe lib
- (void) tokenizeCardNumber:(NSString*)number name:(NSString*)name expMonth:(int)expMonth expYear:(int)expYear cvc:(NSString*)cvc onDone:(void(^)(id))onDone onError:(void(^)(id))onError
{
    [Stripe setDefaultPublishableKey:pubKey];
    
    STPCard *card = [[STPCard alloc] init];
    card.name = name;
    card.number = number;
    card.expMonth = expMonth;
    card.expYear = expYear;
    card.cvc = cvc;
    [[STPAPIClient sharedClient] createTokenWithCard:card
                                          completion:^(STPToken *token, NSError *error) {
                                              if (error)
                                              {
                                                  if (onError) onError([NSError errorWithDomain:@"StripeConnector" code:0 userInfo:@{NSLocalizedDescriptionKey:@"Tokenize failed"}]);
                                              }
                                              else
                                              {
                                                  if (onDone) onDone(@{@"tokenId":token.tokenId});
                                              }
                                          }];
}

#pragma mark MAIN - malevia connect api
- (void) createStripeUserWithCustomerID:(NSString*)customerID email:(NSString*)email description:(NSString*)description onDone:(void(^)(id))onDone onError:(void(^)(id))onError
{
    [self doPostToEndPoint:API_CREATE_STRIPE_USER params:@{@"Email":email,@"Description":description,@"CustomerID":customerID} onDone:onDone onError:onError];
}

- (void) getStripeUserID:(NSString*)userId onDone:(void(^)(id))onDone onError:(void(^)(id))onError
{
    [self doPostToEndPoint:API_GET_STRIPE_USER params:@{@"StripeUserID":userId} onDone:onDone onError:onError];
}

- (void) getCardsOfStripeUserID:(NSString*)userId onDone:(void(^)(id))onDone onError:(void(^)(id))onError
{
    [self doPostToEndPoint:API_GET_CARDS params:@{@"StripeUserID":userId} onDone:onDone onError:onError];
}

- (void) createCardOfStripeUserID:(NSString*)userId cardToken:(NSString*)cardtoken onDone:(void(^)(id))onDone onError:(void(^)(id))onError
{
    [self doPostToEndPoint:API_CREATE_CARD params:@{@"StripeUserID":userId,@"Source":cardtoken} onDone:onDone onError:onError];
}

- (void) updateCardOfStripeUserID:(NSString*)userId cardID:(NSString*)cardId name:(NSString*)name expMonth:(int)expMonth expYear:(int)expYear
                           onDone:(void(^)(id))onDone onError:(void(^)(id))onError
{
    [self doPostToEndPoint:API_UPDATE_CARD params:@{@"StripeUserID":userId,@"CardID":cardId,@"Name":name,@"ExpMonth":[NSNumber numberWithInt:expMonth],@"ExpYear":[NSNumber numberWithInt:expYear]} onDone:onDone onError:onError];
}

- (void) removeCardOfStripeUserID:(NSString*)userId cardID:(NSString*)cardId onDone:(void(^)(id))onDone onError:(void(^)(id))onError
{
    [self doPostToEndPoint:API_DELETE_CARD params:@{@"StripeUserID":userId,@"CardID":cardId} onDone:onDone onError:onError];
}

- (void) chargeStripeUserID:(NSString*)userId cardID:(NSString*)cardId amount:(NSInteger)amount currency:(NSString*)currency onDone:(void(^)(id))onDone onError:(void(^)(id))onError
{
    [self doPostToEndPoint:API_CHARGE params:@{@"StripeUserID":userId,@"CardID":cardId,@"Amount":[NSNumber numberWithInteger:amount],@"Curreny":currency} onDone:onDone onError:onError];
}

#pragma mark PRIVATE
- (void) doPostToEndPoint:(NSString*)point params:(id)params onDone:(void(^)(id))onDone onError:(void(^)(id))onError
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",serverURL,point]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    request.HTTPMethod = @"POST";
    NSString *body     = @"";
    for (NSString* key in [params allKeys])
    {
        body = [body stringByAppendingFormat:@"&%@=%@",key,[params objectForKey:key]];
    }
    if ([body hasPrefix:@"&"])
    {
        body = [body substringFromIndex:1];
    }
    request.HTTPBody   = [body dataUsingEncoding:NSUTF8StringEncoding];
    
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response,NSData *data,NSError *error){
                               if (error)
                               {
                                   if (onError) onError(error);
                               }
                               else
                               {
                                   id response = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:NULL];
                                   if ([[response objectForKey:@"status"] intValue] == 200)
                                   {
                                       if (onDone)
                                       {
                                           onDone(response);
                                       }
                                   }
                                   else
                                   {
                                       if (onError)
                                       {
                                           onError([NSError errorWithDomain:@"StripeConnector" code:0 userInfo:@{NSLocalizedDescriptionKey:[response objectForKey:@"message"]}]);
                                       }
                                   }
                               }
                           }];
}

@end

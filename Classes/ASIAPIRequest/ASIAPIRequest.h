//
//  ASIAPIRequest.h
//  Part of ASIHTTPRequest -> http://allseeing-i.com/ASIHTTPRequest
//
//  Created by akisute (Masashi Ono) on 29/12/2010.
//  Copyright 2010 Masashi Ono. All rights reserved.
//


#import "ASIFormDataRequest.h"


// Dirty extern hack to run the code on both Mac/iPhone...
#if defined UIKIT_EXTERN
#define __PRIVATE_ASI_EXTERN UIKIT_EXTERN
#elif defined APPKIT_EXTERN
#define __PRIVATE_ASI_EXTERN APPKIT_EXTERN
#else
#define __PRIVATE_ASI_EXTERN extern
#endif

__PRIVATE_ASI_EXTERN NSString const *APIGetRequestFinishedNotification;
__PRIVATE_ASI_EXTERN NSString const *APIGetRequestFailedNotification;
__PRIVATE_ASI_EXTERN NSString const *APIPostRequestFinishedNotification;
__PRIVATE_ASI_EXTERN NSString const *APIPostRequestFailedNotification;
__PRIVATE_ASI_EXTERN NSString const *APIPutRequestFinishedNotification;
__PRIVATE_ASI_EXTERN NSString const *APIPutRequestFailedNotification;
__PRIVATE_ASI_EXTERN NSString const *APIDeleteRequestFinishedNotification;
__PRIVATE_ASI_EXTERN NSString const *APIDeleteRequestFailedNotification;


@interface ASIAPIRequest : ASIFormDataRequest {
@private
	NSString *getRequestFinishedNotificationName;
	NSString *getRequestFailedNotificationName;
	NSString *postRequestFinishedNotificationName;
	NSString *postRequestFailedNotificationName;
	NSString *putRequestFinishedNotificationName;
	NSString *putRequestFailedNotificationName;
	NSString *deleteRequestFinishedNotificationName;
	NSString *deleteRequestFailedNotificationName;
    
	NSMutableArray *queryStringParameters;
    
	NSInteger tag;
}

#pragma mark Methods to override

// Override these methods in subclasses to do some post-request jobs
// such as parsing the response body into Core Data model objects.
// - These methods are called in the same thread of this request
//   so that they don't block the UI thread.
//   (Just make sure not to do any UI related jobs here!)
- (void)getRequestFinished;
- (void)getRequestFailedWithError:(NSError *)theError;
- (void)postRequestFinished;
- (void)postRequestFailedWithError:(NSError *)theError;
- (void)putRequestFinished;
- (void)putRequestFailedWithError:(NSError *)theError;
- (void)deleteRequestFinished;
- (void)deleteRequestFailedWithError:(NSError *)theError;

#pragma mark Creating GET querystring parameters

// Parameters that will be appended to the URL as query string
@property (nonatomic, retain) NSMutableArray *queryStringParameters;
// Add a GET variable to the request
- (void)addGetValue:(id <NSObject>)value forKey:(NSString *)key;
// Set a GET variable for this request, clearing any others with the same key
- (void)setGetValue:(id <NSObject>)value forKey:(NSString *)key;

#pragma mark Notification settings

@property (nonatomic, copy) NSString *getRequestFinishedNotificationName;
@property (nonatomic, copy) NSString *getRequestFailedNotificationName;
@property (nonatomic, copy) NSString *postRequestFinishedNotificationName;
@property (nonatomic, copy) NSString *postRequestFailedNotificationName;
@property (nonatomic, copy) NSString *putRequestFinishedNotificationName;
@property (nonatomic, copy) NSString *putRequestFailedNotificationName;
@property (nonatomic, copy) NSString *deleteRequestFinishedNotificationName;
@property (nonatomic, copy) NSString *deleteRequestFailedNotificationName;

#pragma mark Request/response utilities

// Tag value. You can use this property to specify requests
@property (nonatomic, assign) NSInteger tag;

@end

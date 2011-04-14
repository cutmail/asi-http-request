//
//	ASIAPIRequest.m
//	Part of ASIHTTPRequest -> http://allseeing-i.com/ASIHTTPRequest
//
//	Created by akisute (Masashi Ono) on 29/12/2010.
//	Copyright 2010 Masashi Ono. All rights reserved.
//


#import "ASIAPIRequest.h"


NSString const *APIGetRequestFinishedNotification = @"APIGetRequestFinishedNotification";
NSString const *APIGetRequestFailedNotification = @"APIGetRequestFailedNotification";
NSString const *APIPostRequestFinishedNotification = @"APIPostRequestFinishedNotification";
NSString const *APIPostRequestFailedNotification = @"APIPostRequestFailedNotification";
NSString const *APIPutRequestFinishedNotification = @"APIPutRequestFinishedNotification";
NSString const *APIPutRequestFailedNotification = @"APIPutRequestFailedNotification";
NSString const *APIDeleteRequestFinishedNotification = @"APIDeleteRequestFinishedNotification";
NSString const *APIDeleteRequestFailedNotification = @"APIDeleteRequestFailedNotification";


// Private interface
@interface ASIAPIRequest()
- (void)__buildURLEncodedQueryStringParameters;
- (void)__postNotificationWithName:(NSString *)notificationName;
@end


#pragma mark -


@implementation ASIAPIRequest


#pragma mark Init/dealloc


- (void) dealloc {
	[getRequestFinishedNotificationName release];
	[getRequestFailedNotificationName release];
	[postRequestFinishedNotificationName release];
	[postRequestFailedNotificationName release];
	[putRequestFinishedNotificationName release];
	[putRequestFailedNotificationName release];
	[deleteRequestFinishedNotificationName release];
	[deleteRequestFailedNotificationName release];
    
	[queryStringParameters release];
	[super dealloc];
}


#pragma mark Methods to override


- (void)getRequestFinished {}
- (void)getRequestFailedWithError:(NSError *)theError {}
- (void)postRequestFinished {}
- (void)postRequestFailedWithError:(NSError *)theError {}
- (void)putRequestFinished {}
- (void)putRequestFailedWithError:(NSError *)theError {}
- (void)deleteRequestFinished {}
- (void)deleteRequestFailedWithError:(NSError *)theError {}


#pragma mark Starting request


- (void)startSynchronous {
	[self __buildURLEncodedQueryStringParameters];
	[super startSynchronous];
}

- (void)startAsynchronous {
	[self __buildURLEncodedQueryStringParameters];
	[super startAsynchronous];
}


#pragma mark Creating GET querystring parameters


// Most of the part of this function comes from the ASIFormDataRequest's "setup request" section.
	
@synthesize queryStringParameters;

- (void)addGetValue:(id <NSObject>)value forKey:(NSString *)key {
	// Modified from the original ASIFormDataRequest's addPostValue:forKey:
	// - If the given key is nil, do nothing.
	// - If the string description of the given value is nil, treat it as a blank string.
	if (!key) {
		return;
	}
	NSString *valueString = [value description];
	if (!valueString) {
		valueString = @"";
	}
	
	if (!self.queryStringParameters) {
		self.queryStringParameters = [NSMutableArray array];
	}
	[self.queryStringParameters addObject:[NSDictionary dictionaryWithObjectsAndKeys:valueString,@"value",key,@"key",nil]];
}

- (void)setGetValue:(id <NSObject>)value forKey:(NSString *)key {
	// Remove any existing value
	NSUInteger i;
	for (i=0; i<[self.queryStringParameters count]; i++) {
		NSDictionary *val = [self.queryStringParameters objectAtIndex:i];
		if ([[val objectForKey:@"key"] isEqualToString:key]) {
			[self.queryStringParameters removeObjectAtIndex:i];
			i--;
		}
	}
	[self addGetValue:value forKey:key];
}


#pragma mark Notification settings


@synthesize getRequestFinishedNotificationName;
@synthesize getRequestFailedNotificationName;
@synthesize postRequestFinishedNotificationName;
@synthesize postRequestFailedNotificationName;
@synthesize putRequestFinishedNotificationName;
@synthesize putRequestFailedNotificationName;
@synthesize deleteRequestFinishedNotificationName;
@synthesize deleteRequestFailedNotificationName;


#pragma mark Request/response utilities


@synthesize tag;


#pragma mark ASIHTTPRequest


- (void)requestFinished {
	// 1. Let subclasses do their custom jobs in xxxRequestFinished method
	// 2. Once the custom jobs are done, call super implementation to notifity delegates and completion blocks
	// 3. Post a NSNotification on the main thread
	if ([self.requestMethod isEqualToString:@"GET"]) {
		[self getRequestFinished];
		[super requestFinished];
		[self performSelectorOnMainThread:@selector(__postNotificationWithName:)
							   withObject:(self.getRequestFinishedNotificationName) ? self.getRequestFinishedNotificationName : APIGetRequestFinishedNotification
							waitUntilDone:[NSThread isMainThread]];
	} else if ([self.requestMethod isEqualToString:@"POST"]) {
		[self postRequestFinished];
		[super requestFinished];
		[self performSelectorOnMainThread:@selector(__postNotificationWithName:)
							   withObject:(self.postRequestFinishedNotificationName) ? self.postRequestFinishedNotificationName : APIPostRequestFinishedNotification
							waitUntilDone:[NSThread isMainThread]];
	} else if ([self.requestMethod isEqualToString:@"PUT"]) {
		[self putRequestFinished];
		[super requestFinished];
		[self performSelectorOnMainThread:@selector(__postNotificationWithName:)
							   withObject:(self.putRequestFinishedNotificationName) ? self.putRequestFinishedNotificationName : APIPutRequestFinishedNotification
							waitUntilDone:[NSThread isMainThread]];
	} else if ([self.requestMethod isEqualToString:@"DELETE"]) {
		[self deleteRequestFinished];
		[super requestFinished];
		[self performSelectorOnMainThread:@selector(__postNotificationWithName:)
							   withObject:(self.deleteRequestFinishedNotificationName) ? self.deleteRequestFinishedNotificationName : APIDeleteRequestFinishedNotification
							waitUntilDone:[NSThread isMainThread]];
	} else {
		[super requestFinished];
	}
}

- (void)failWithError:(NSError *)theError {
	// 1. Let subclasses do their custom jobs in xxxRequestFailed method
	// 2. Once the custom jobs are done, call super implementation to notifity delegates and completion blocks
	// 3. Post a NSNotification on the main thread
	if ([self.requestMethod isEqualToString:@"GET"]) {
		[self getRequestFailedWithError:theError];
		[super failWithError:theError];
		[self performSelectorOnMainThread:@selector(__postNotificationWithName:)
							   withObject:(self.getRequestFailedNotificationName) ? self.getRequestFailedNotificationName : APIGetRequestFailedNotification
							waitUntilDone:[NSThread isMainThread]];
	} else if ([self.requestMethod isEqualToString:@"POST"]) {
		[self postRequestFailedWithError:theError];
		[super failWithError:theError];
		[self performSelectorOnMainThread:@selector(__postNotificationWithName:)
							   withObject:(self.postRequestFailedNotificationName) ? self.postRequestFailedNotificationName : APIPostRequestFailedNotification
							waitUntilDone:[NSThread isMainThread]];
	} else if ([self.requestMethod isEqualToString:@"PUT"]) {
		[self putRequestFailedWithError:theError];
		[super failWithError:theError];
		[self performSelectorOnMainThread:@selector(__postNotificationWithName:)
							   withObject:(self.putRequestFailedNotificationName) ? self.putRequestFailedNotificationName : APIPutRequestFailedNotification
							waitUntilDone:[NSThread isMainThread]];
	} else if ([self.requestMethod isEqualToString:@"DELETE"]) {
		[self deleteRequestFailedWithError:theError];
		[super failWithError:theError];
		[self performSelectorOnMainThread:@selector(__postNotificationWithName:)
							   withObject:(self.deleteRequestFailedNotificationName) ? self.deleteRequestFailedNotificationName : APIDeleteRequestFailedNotification
							waitUntilDone:[NSThread isMainThread]];
	} else {
		[super failWithError:theError];
	}
}


#pragma mark Private method


- (void)__buildURLEncodedQueryStringParameters {
	NSMutableString *buffer = [[[self.url absoluteString] mutableCopy] autorelease];
	NSString *currentQuery = [self.url query];
	NSUInteger i=0;
	for (NSDictionary *val in self.queryStringParameters) {
		NSString *data = [NSString stringWithFormat:@"%@%@=%@", (i==0 && [currentQuery length]==0 ? @"?" : @"&"), [self encodeURL:[val objectForKey:@"key"]], [self encodeURL:[val objectForKey:@"value"]]]; 
		[buffer appendString:data];
		i++;
	}
	self.url = [NSURL URLWithString:buffer];
}

/* ALWAYS CALLED ON MAIN THREAD! */
- (void)__postNotificationWithName:(NSString *)notificationName {
	[[NSNotificationCenter defaultCenter] postNotificationName:notificationName
														object:self
													  userInfo:[NSDictionary dictionaryWithObject:self forKey:@"request"]];
}

@end

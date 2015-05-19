//
//  IDWebServiceManager.h
//  IDVersion:1.0
//  Copyright (c) 2014 ID Developer Team
//  By Prashant
//

#import <Foundation/Foundation.h>

#import "IDWebService.h"

@class IDWebServiceManager;

// Create block for service manager
typedef void(^IDWSManager)(NSError *IDError, IDWebServiceManager * IDWSManager);


@interface IDWebServiceManager : IDWebService

@property (nonatomic, weak)   NSString *IDMessage;
@property (nonatomic, assign) BOOL IDStatus;
@property (nonatomic, weak)   NSArray *IDResult;


#pragma mark =>Call Service Method
+(void)IDWSManager:(NSMutableDictionary *)setData IDServiceURL:(NSString *)IDServiceURL IDCurrentView:(UIView*)IDCurrentView IDIsRequestGET:(BOOL)IDIsRequestGET IDIsLoader:(BOOL)IDIsLoader callback:(IDWSManager)callback;
@end

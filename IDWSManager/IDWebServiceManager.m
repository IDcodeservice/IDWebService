//
//  IDWebServiceManager.m
//  IDVersion:1.0
//  Copyright (c) 2014 ID Developer Team
//  By Prashant
//

#import "IDWebServiceManager.h"

@implementation IDWebServiceManager


+(void)IDWSManager:(NSMutableDictionary *)setData IDServiceURL:(NSString *)IDServiceURL IDCurrentView:(UIView*)IDCurrentView IDIsRequestGET:(BOOL)IDIsRequestGET IDIsLoader:(BOOL)IDIsLoader callback:(IDWSManager)callback
{
    IDWebRequestManager *IDWRManager = [[IDWebRequestManager alloc] init];
    IDWRManager.IDBaseURL = IDBaseURL;
    IDWRManager.IDServiceURL= IDServiceURL;
    IDWRManager.IDSetData = setData;
    
    IDWRManager.IDRequestType=(IDIsRequestGET==TRUE)?0:1;
    //Note: IDRequestType=> IDIsRequestGET==True  for GET request
    //Note: IDRequestType=> IDIsRequestGET==False for POST request
    
    IDWRManager.IDIsLoader=IDIsLoader;
    IDWRManager.IDCurrentView=IDCurrentView;
    
    IDWRManager.IDRequestSuccessBlock=^(IDWebRequestManager *RequestData){
        NSLog(@"%@:%@",@"SM response", RequestData.IDResponseData);
        callback(nil, [IDWebServiceManager parserResult:RequestData]);
    };
    IDWRManager.IDRequestFailureBlock=^(IDWebRequestManager * RequestData){
        callback(RequestData.IDResponseData, nil);
    };
    [[IDWebRequestManager sharedInstance] ActiveOperation:IDWRManager];
}

+(IDWebServiceManager *)parserResult:(IDWebRequestManager *)RequestData
{
    IDWebServiceManager *IDWSManager = [[IDWebServiceManager alloc]init];
//    IDWSManager.IDMessage  =[RequestData.IDResponseData objectForKey:@"Message"];
//    IDWSManager.IDStatus   =[[RequestData.IDResponseData objectForKey:@"Status"] integerValue] == 1 ? TRUE : FALSE;
//    IDWSManager.IDResult =[RequestData.IDResponseData objectForKey:@"Result"];
    IDWSManager.IDResult =RequestData.IDResponseData;
    return IDWSManager;
}
@end

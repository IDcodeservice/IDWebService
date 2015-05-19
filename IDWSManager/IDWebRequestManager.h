//
//  IDWebRequestManager.h
//  IDVersion:1.0
//  Copyright (c) 2014 ID Developer Team
//  By Prashant
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class  IDWebRequestManager;

typedef enum {
    RequestTypeGet=0,
    RequestTypePost,
}RequestType;


// Create Block for success & failure and send RequestData
typedef void (^RequestSuccessCallback)(IDWebRequestManager *request);
typedef void (^RequestFailureCallback)(IDWebRequestManager *request);


@interface IDWebRequestManager : NSObject
{
    NSOperationQueue *queue;
}

@property (nonatomic,weak) NSString *IDBaseURL;
@property (nonatomic,weak) NSString *IDServiceURL;

@property (nonatomic,assign) RequestType IDRequestType;

@property (nonatomic,strong) NSMutableDictionary *IDSetData;

@property (nonatomic,strong) id IDResponseData;
@property (nonatomic,assign) BOOL IDIsLoader;

@property (nonatomic,strong) UIView *IDCurrentView;

// Create Block @property
@property (nonatomic,copy) RequestSuccessCallback IDRequestSuccessBlock;
@property (nonatomic,copy) RequestFailureCallback IDRequestFailureBlock;


@property (strong,nonatomic) UIActivityIndicatorView *AIView;


+ (id)sharedInstance;

-(void)makeRequest:(IDWebRequestManager *)requestData;
-(void)ActiveOperation:(IDWebRequestManager *)requestData;
@end

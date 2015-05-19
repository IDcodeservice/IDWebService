//
//  IDWebRequestManager.m
//  IDVersion:1.0
//  Copyright (c) 2014 ID Developer Team
//  By Prashant
//

#import "IDWebRequestManager.h"

@implementation IDWebRequestManager
@synthesize IDBaseURL;
@synthesize IDServiceURL;
@synthesize IDSetData;
@synthesize IDIsLoader;
@synthesize AIView;

static IDWebRequestManager *sharedInstance = nil;
+ (IDWebRequestManager *)sharedInstance
{
    if (sharedInstance == nil) {
        sharedInstance = [[super allocWithZone:NULL] init];
    }
    return sharedInstance;
}

-(id)init
{
    self=[super init];
    
    if (self)
    {
        self.IDBaseURL = @"";
        self.IDServiceURL = @"";
        self.IDSetData=nil;
        self.IDResponseData=nil;
        self.IDRequestFailureBlock=nil;
        self.IDRequestSuccessBlock=nil;
    }
    return self;
}

-(void)ActiveOperation:(IDWebRequestManager *)requestData
{
    if (requestData.IDIsLoader)
    {
        [self startAI:requestData.IDCurrentView];
    }
    [NSThread detachNewThreadSelector:@selector(makeRequest:) toTarget:self withObject:requestData];
}

-(void)makeRequest:(IDWebRequestManager *)requestData
{
    NSURLResponse * response = nil;
    NSError *error;
    NSMutableURLRequest * request;
    
    if(requestData.IDRequestType == RequestTypeGet){
        request=[self makeRequestForGet:requestData];
    }else{
        request=[self makeRequestForPost:requestData];
    }
    
    NSData * data = [NSURLConnection sendSynchronousRequest:request
                                          returningResponse:&response
                                                      error:&error];
    if (error == nil)
    {
        NSDictionary *responseDic;
        
        responseDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
        if (error == nil){
            requestData.IDResponseData=responseDic;
            if(requestData.IDRequestSuccessBlock)
            {
                requestData.IDRequestSuccessBlock(requestData);
            }
            [self stopAI:requestData.IDCurrentView];
        }
        else{
            if(requestData.IDRequestFailureBlock)
                requestData.IDRequestFailureBlock(requestData);
            
            NSLog(@"JSON Response:%@",error.localizedDescription);
            [self showError:error.localizedDescription];
            [self stopAI:requestData.IDCurrentView];
        }
    }
    else{
        if(requestData.IDRequestFailureBlock)
            requestData.IDRequestFailureBlock(requestData);
        
        NSLog(@"NSURLConnection Response:%@",error.localizedDescription);
        [self showError:error.localizedDescription];
        [self stopAI:requestData.IDCurrentView];
    }
}

-(NSMutableURLRequest*)makeRequestForGet:(IDWebRequestManager *)requestData {
    
    NSURL *requestURL = [self createRequestUrl:requestData];
    NSLog(@"%@:%@",@"SM Get requestURL",requestURL);
    
    // Create the request
    NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:requestURL];
    return request;
}

-(NSMutableURLRequest*)makeRequestForPost:(IDWebRequestManager *)requestData {
    
    NSURL *requestURL = [self createRequestUrl:requestData];
    NSLog(@"%@:%@",@"SM Post requestURL",requestURL);
    
    // Create the request
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:requestURL];
    
    // Specify that it will be a POST request
    [request setHTTPMethod:@"POST"];
    
    NSData *posting = [[self makeKeyUsingDictionary:requestData.IDSetData] dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:posting];
    return request;
}

-(NSURL *)createRequestUrl:(IDWebRequestManager *)requestData
{
    NSMutableString *urlStr=[[NSMutableString alloc]initWithString:@""];
    
    if(requestData.IDRequestType == RequestTypeGet){
        [urlStr appendFormat:@"%@%@%@%@",requestData.IDBaseURL,requestData.IDServiceURL,@"?",[self makeKeyUsingDictionary:requestData.IDSetData]];
    }else{
        [urlStr appendFormat:@"%@%@",requestData.IDBaseURL,requestData.IDServiceURL];
    }
    NSURL * url = [NSURL URLWithString:[urlStr stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding]];
    return url;
}

-(NSMutableString*) makeKeyUsingDictionary:(NSDictionary*)SetDataDic
{
    NSMutableString *ps;   //parameter string
    ps=[[NSMutableString alloc]initWithString:@""];
    NSArray *dicKeyArray = [SetDataDic allKeys];
    
    if (dicKeyArray.count!=0)
    {
        int i=0;
        for (NSString *key in dicKeyArray)
        {
            if(i == 0){
                [ps appendFormat:@"%@=%@",key,[SetDataDic objectForKey:key]];
            }
            else{
                [ps appendFormat:@"&%@=%@",key,[SetDataDic objectForKey:key]];
            }
            i++;
        }
    }
    return ps;
}

-(void)showError:(NSString*)error
{
    UIAlertView* al=[[UIAlertView alloc]initWithTitle:@"Error" message:error delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [al show];
}


- (void)startAI:(UIView *)IDCurrentView
{
    AIView=[[UIActivityIndicatorView alloc]init];
    CGRect screenBounds = [UIScreen mainScreen].bounds ;
    CGFloat w = CGRectGetWidth(screenBounds)  ;
    CGFloat h = CGRectGetHeight(screenBounds) ;
    
    if (AIView)
    {
        CGFloat AIViewW=w/3;
        CGFloat AIViewH=h/7;
        AIView.bounds = CGRectMake(0, 0,AIViewW,AIViewH);
        AIView.hidesWhenStopped = YES;
        AIView.activityIndicatorViewStyle=UIActivityIndicatorViewStyleWhiteLarge;
        AIView.color=[UIColor blackColor];
        // display it in the center of your view
        AIView.center = CGPointMake(w/2,h/2);
        AIView.backgroundColor=[UIColor colorWithRed:207/255.0 green:207/255.0 blue:204/255.0 alpha:1.0];
       AIView.layer.borderWidth=1.0f;
       AIView.layer.cornerRadius=10.0f;
        
        CGFloat PWH=AIViewH/4;
        UILabel *PWL=[[UILabel alloc]initWithFrame:CGRectMake(0,(AIViewH-PWH)-0,AIViewW,PWH)];
        PWL.backgroundColor=[UIColor darkGrayColor];
        PWL.text=@"Please Wait...";
        PWL.textAlignment=NSTextAlignmentCenter;
        PWL.textColor=[UIColor whiteColor];
        PWL.font=[UIFont boldSystemFontOfSize:13.0];
        PWL.clipsToBounds=TRUE;
        UIBezierPath *maskPath;
        maskPath = [UIBezierPath bezierPathWithRoundedRect:PWL.bounds
                                         byRoundingCorners:(UIRectCornerBottomLeft|UIRectCornerBottomRight)
                                               cornerRadii:CGSizeMake(10.0, 10.0)];
        
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.frame = PWL.bounds;
        maskLayer.path = maskPath.CGPath;
        PWL.layer.mask = maskLayer;
        
        [AIView addSubview:PWL];
        [IDCurrentView addSubview:AIView];
        IDCurrentView.userInteractionEnabled=false;
        AIView.userInteractionEnabled=false;
        [AIView startAnimating];
        IDCurrentView.alpha=0.9f;
    }
}

-(void)stopAI:(UIView *)IDCurrentView
{
    [AIView stopAnimating];
    [AIView removeFromSuperview];
    IDCurrentView.userInteractionEnabled=true;
    IDCurrentView.alpha=1.0f;
}
@end

IDWebServiceManager class is using for GET/POST web service request with JSON response in Objective C. you can easily use IDWebServiceManager class in your project.

Summary
Name:			IDWebServiceManager
Language:		Objective C
Description:		GET/POST web service request with JSON response
Request:		GET/POST
Response:		JSON



Step:1
IDWSManager folder drop in your project


Step:2
//Class installation
Import IDWebServiceManager.h in your class or pch file


Step:3
//Set Baseurl & service url
In IDWebService Class,
Set IDBaseURL
Set IDServiceURls


Step:4
//Call methode
IDWSManager=>		set Post Data Dictionary or nil  	
IDServiceURL=>		set IDServiceURL from IDWebService.h Class 
IDCurrentView=>		set Current View(self.view)
IDIsRequestGET=>	set Yes->Get Service & NO->Post Service
IDIsLoader=>		set Yes/No for show loader
IDError=>		Get Response->error
IDWSManager=>		Get Response->result

Example: How to call IDWSManager function?

-(void)callService
{
    [IDWebServiceManager IDWSManager:nil IDServiceURL:IDServiceURl IDCurrentView:self.view IDIsRequestGET:YES IDIsLoader:YES callback:^(NSError *IDError, IDWebServiceManager *IDWSManager) {
        if (IDError)
        {
            NSLog(@"error==>%@",IDError);
        }
        else
        {
            NSLog(@"IDResult===>%@",IDWSManager.IDResult);
        }
    }];
}


If You have any issue, you can mail on idcodeservice@gmail.com.



Cheers,
IDCodeService

 
 


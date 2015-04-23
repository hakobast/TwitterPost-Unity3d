//
//  UnityTweeter.m
//  Unity-iPhone
//
//  Created by Hakob on 8/20/14.
//
//

#import "UnityTweeter.h"
#import <Social/Social.h>
#import "UnityAppController.h"

@implementation UnityTweeter

@synthesize gameObject;

-(void)delegateName:(NSString *)delegate Tweet:(NSString *)text URL:(NSString *)url IMG:(NSString *)img;
{
    NSMutableString *unityMsg = [[NSMutableString alloc]init];
    
    NSLog(@"::OBJECTIVE C:: OBJ %@, Delegate %@, Text %@",gameObject,delegate,text);
    if([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
    {
        SLComposeViewController *tweetSheet =
        [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
        [tweetSheet setInitialText:text];
        if(url.length > 0)
        {
            [tweetSheet addURL:[NSURL URLWithString:url]];
        }
        if(img.length > 0)
        {
            NSData* data = [[NSData alloc] initWithBase64EncodedString:img options:0];
            UIImage* image = [UIImage imageWithData:data];
            
            [tweetSheet addImage:image];
        }
        
        tweetSheet.completionHandler = ^(SLComposeViewControllerResult result) {
            switch(result) {
                case SLComposeViewControllerResultCancelled:
                    [unityMsg appendString:@"0,Cancel,"];
                    [unityMsg appendString:text];
                    break;
                case SLComposeViewControllerResultDone:
                    [unityMsg appendString:@"1,Send,"];
                    [unityMsg appendString:text];
                    break;
            }
            UnitySendMessage([gameObject UTF8String], [delegate UTF8String], [unityMsg UTF8String]);
        };
        
        [[UIApplication sharedApplication].keyWindow.rootViewController
         presentViewController:tweetSheet animated:YES completion:nil];
    }
    else
    {
        [unityMsg appendString:@"0,No Account,"];
        [unityMsg appendString:text];
        UnitySendMessage([gameObject UTF8String], [delegate UTF8String], [unityMsg UTF8String]);
        
        NSMutableString *alertText = [@"You can't send a tweet right now, make sure " mutableCopy];
        [alertText appendString:@"your device has an internet connection and you have "];
        [alertText appendString:@"at least one Twitter account setup"];
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Sorry" message:alertText
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
        [alertView show];
    }
    
    
}

@end


static UnityTweeter *unityTweeter;

// Converts C style string to NSString
NSString* CreateNSString (const char* string)
{
	if (string)
		return [NSString stringWithUTF8String: string];
	else
		return [NSString stringWithUTF8String: ""];
}

// Helper method to create C string copy
char* MakeStringCopy (const char* string)
{
	if (string == NULL)
		return NULL;
	
	char* res = (char*)malloc(strlen(string) + 1);
	strcpy(res, string);
	return res;
}

extern "C"
{
    void _init(const char *gameObject)
    {
        if(unityTweeter == nil)
            unityTweeter = [[UnityTweeter alloc]init];
        
        unityTweeter.gameObject = CreateNSString(gameObject);
        printf("::C:: INITED");
    }
    
    void _postTweet(const char *text, const char *url, const char *img, const char *delegateName)
    {
        if(unityTweeter == nil)
            unityTweeter = [[UnityTweeter alloc]init];
        
        printf("::C:: POST TO TWEET");
        [unityTweeter delegateName:CreateNSString(delegateName) Tweet:CreateNSString(text)
                               URL:CreateNSString(url) IMG:CreateNSString(img)];
    }
}
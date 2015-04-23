//
//  UnityTweeter.h
//  Unity-iPhone
//
//  Created by Hakob on 8/20/14.
//
//

#import <Foundation/Foundation.h>

@interface UnityTweeter : NSObject

@property (strong) NSString *gameObject;

-(void)delegateName:(NSString *)delegate Tweet:(NSString *)text URL:(NSString *)url IMG:(NSString *)img;

@end
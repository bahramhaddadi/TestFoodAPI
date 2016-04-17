//
//  UIImage+Extentions.m
//  TestFoodAPI
//
//  Created by Bahram Haddadi on 2016-03-22.
//  Copyright © 2016 Bahram Haddadi. All rights reserved.
//

#import "UIImage+Extentions.h"

@implementation UIImage (Extentions)

+(void)loadImage:(NSString*)url complition:(ImageLoadCallBack)complition{
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:url]]];
        complition(image,nil);
    });
}

-(void)cacheByName:(NSString*)name{
    NSString *documentsPath = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).firstObject;
    NSString *destinationPath = [documentsPath stringByAppendingString:name];
    [UIImagePNGRepresentation(self) writeToFile:destinationPath atomically:YES];
}

@end

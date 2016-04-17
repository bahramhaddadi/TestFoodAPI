//
//  ImageCacheManager.m
//  TestFoodAPI
//
//  Created by Bahram Haddadi on 2016-03-22.
//  Copyright © 2016 Bahram Haddadi. All rights reserved.
//

#import "ImageCacheManager.h"
@interface ImageCacheManager()
@property (strong,nonatomic) NSMutableArray *files;
@end

@implementation ImageCacheManager

+(ImageCacheManager*)sharedInstance{
    static ImageCacheManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[ImageCacheManager alloc] init];
    });
    
    return manager;
}

-(ImageCacheManager *)init{
    self = [super init];
    if (self) {
        NSString *documentsPath = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).firstObject;
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSMutableArray *dirContents = [[fileManager contentsOfDirectoryAtPath:documentsPath error:nil] mutableCopy];
        
        for (NSString *file in dirContents) {
//            NSLog(@"file name :  %@",file);
            if([file containsString:@".jpg"] || [file containsString:@".png"]){
//                NSLog(@"%@ needs to check for deletion",file);
                
                NSError *error = nil;
                NSDictionary* attrs = [fileManager attributesOfItemAtPath:[NSString stringWithFormat:@"%@/%@", documentsPath, file] error:&error];
                NSDate *creationDate = attrs[NSFileCreationDate];
                if([creationDate compare:[[NSDate date] dateByAddingTimeInterval:-10*24*60*60]] == NSOrderedAscending){
                    NSError *error;
                    BOOL success = [fileManager removeItemAtPath:[NSString stringWithFormat:@"%@/%@", documentsPath, file] error:&error];
                    if (!success) {
                        NSLog(@"Cannot delete file %@",file);
                    }
                    //[dirContents removeObject:file]; //should I really delete or refetch the whole
                }
            }
        }
        //refetch file list after delete operation
        dirContents = [[fileManager contentsOfDirectoryAtPath:documentsPath error:nil] mutableCopy];
        self.files = [dirContents mutableCopy];
    }
    return self;
}

-(void)loadImage:(NSString*)url complition:(ImageLoadCallBack)complition{
    if(url.length==0){
        complition([UIImage imageNamed:@"placeholder"],nil);
        return;
    }
    
    NSString* fileName = [url stringByReplacingOccurrencesOfString:@"/" withString:@"_"];
    for(NSString *filePath in self.files){
        if([filePath isEqualToString:fileName]){
            NSLog(@"found in cache : %@",url);
            NSString *documentsPath = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).firstObject;
            NSString *destinationPath = [NSString stringWithFormat:@"%@/%@",documentsPath,fileName];
            UIImage *image = [UIImage imageNamed:destinationPath];
            complition(image,nil);
            return;
        }
    }
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:url]]];
        NSLog(@"load file : %@",url);
        [self.files addObject:fileName];
        [self cacheImage:image name:fileName];
        complition(image,nil);
    });
}

-(void)cacheImage:(UIImage*)image name:(NSString*)name{
    NSString *documentsPath = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).firstObject;
    NSString *destinationPath = [NSString stringWithFormat:@"%@/%@",documentsPath,name];
    [UIImagePNGRepresentation(image) writeToFile:destinationPath atomically:YES];
    NSLog(@"saved in cache : %@",name);
}


@end

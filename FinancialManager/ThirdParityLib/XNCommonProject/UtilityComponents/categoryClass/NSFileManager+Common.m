//
//  NSFileManager+XL.m
//  XL
//
//  Created by czh0766 on 12-8-20.
//
//

#import "NSFileManager+Common.h"

@implementation NSFileManager (Common)

+(NSString*) pathInDocuments:(NSString*)path {
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* path0 = [paths objectAtIndex:0];
    return path ? [path0 stringByAppendingPathComponent:path] : path0;
}

+(NSString *)pathInLibrary:(NSString *)path {
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString* path0 = [paths objectAtIndex:0];
    return path ? [path0 stringByAppendingPathComponent:path] : path0;
}

+(NSString *)pathInLibraryCaches:(NSString *)path {
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString* path0 = [paths objectAtIndex:0];
    return path ? [path0 stringByAppendingPathComponent:path] : path0;
}
+ (NSString *)createFolderInDocuments:(NSString *)folderName {
    NSString *folderPath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:folderName];
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    
	BOOL isDirectory = NO;
	NSArray *directories = @[folderPath];
	for (NSString *directory in directories) {
		BOOL exists = [fileManager fileExistsAtPath:directory isDirectory:&isDirectory];
		if (exists && !isDirectory) {
			[NSException raise:@"FileExistsAtCachePath" format:@"Cannot create a directory for the cache at '%@', because a file already exists",directory];
		} else if (!exists) {
			[fileManager createDirectoryAtPath:directory withIntermediateDirectories:NO attributes:nil error:nil];
			if (![fileManager fileExistsAtPath:directory]) {
				[NSException raise:@"FailedToCreateCacheDirectory" format:@"Failed to create a directory for the cache at '%@'",directory];
			}
		}
	}
    
    return folderPath;
}

-(BOOL) createFileAtPath:(NSString *)path contents:(NSData *)data attributes:(NSDictionary *)attr withIntermediateDirectories:(BOOL)intermediate {
    if (intermediate)  {
        NSUInteger slash_index = [path rangeOfString:@"/" options:NSBackwardsSearch].location;
        if (slash_index != NSNotFound) {
            NSString* dir_path = [path substringToIndex:slash_index];
            if (![self fileExistsAtPath:dir_path]) {
                [self createDirectoryAtPath:dir_path withIntermediateDirectories:YES attributes:nil error:nil];
            }
        }
    }
    return [self createFileAtPath:path contents:data attributes:attr];
}

@end










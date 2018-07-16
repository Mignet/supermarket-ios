//
//  NSFileManager+XL.h
//  XL
//
//  Created by czh0766 on 12-8-20.
//
//

#import <Foundation/Foundation.h>

@interface NSFileManager (Common)

+(NSString*) pathInDocuments:(NSString*)path;

+(NSString*) pathInLibrary:(NSString*)path;

+(NSString*) pathInLibraryCaches:(NSString*)path;

+ (NSString *)createFolderInDocuments:(NSString *)folderName;

-(BOOL) createFileAtPath:(NSString *)path contents:(NSData *)data attributes:(NSDictionary *)attr withIntermediateDirectories:(BOOL)intermediate;

@end

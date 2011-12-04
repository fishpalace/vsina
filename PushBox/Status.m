//
//  Status.m
//  PushBox
//
//  Created by Gabriel Yeah on 11-12-4.
//  Copyright (c) 2011年 同济大学. All rights reserved.
//

#import "Status.h"
#import "Comment.h"
#import "Status.h"
#import "User.h"
#import "NSDateAddition.h"


@implementation Status

@dynamic bmiddlePicURL;
@dynamic commentsCount;
@dynamic createdAt;
@dynamic favorited;
@dynamic isMentioned;
@dynamic lat;
@dynamic lon;
@dynamic originalPicURL;
@dynamic repostsCount;
@dynamic searchString;
@dynamic source;
@dynamic statusID;
@dynamic text;
@dynamic thumbnailPicURL;
@dynamic updateDate;
@dynamic featureOrigin;
@dynamic featurePic;
@dynamic featureVideo;
@dynamic featureMusic;
@dynamic author;
@dynamic comments;
@dynamic favoritedBy;
@dynamic isFriendsStatusOf;
@dynamic repostedBy;
@dynamic repostStatus;

- (BOOL)isEqualToStatus:(Status *)status
{
    return [self.statusID isEqualToString:status.statusID];
}

+ (Status *)statusWithID:(NSString *)statudID inManagedObjectContext:(NSManagedObjectContext *)context
{
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    
    [request setEntity:[NSEntityDescription entityForName:@"Status" inManagedObjectContext:context]];
    [request setPredicate:[NSPredicate predicateWithFormat:@"statusID == %@", statudID]];
    
    Status *res = [[context executeFetchRequest:request error:NULL] lastObject];
    
    [request release];
    
    return res;
}

+ (Status *)insertMentionedStatus:(NSDictionary *)dict inManagedObjectContext:(NSManagedObjectContext *)context
{
	NSString *statusID = [[dict objectForKey:@"id"] stringValue];
    
    if (!statusID || [statusID isEqualToString:@""]) {
        return nil;
    }
    
    Status *result = [Status statusWithID:statusID inManagedObjectContext:context];
    if (!result) {
        result = [NSEntityDescription insertNewObjectForEntityForName:@"Status" inManagedObjectContext:context];
    }
    
    //    result.updateDate = [NSDate date];
    result.statusID = statusID;
    
    NSString *dateString = [dict objectForKey:@"created_at"];
	result.updateDate = [NSDate dateFromStringRepresentation:dateString];
    result.createdAt = [NSDate dateFromStringRepresentation:dateString];
    
    result.text = [dict objectForKey:@"text"];
    
    result.source = [dict objectForKey:@"source"];
    
    result.favorited = [NSNumber numberWithBool:[[dict objectForKey:@"favorited"] boolValue]];
	result.isMentioned = [NSNumber numberWithBool:YES];
    
    result.commentsCount = [dict objectForKey:@"comment_count"];
    result.repostsCount = [dict objectForKey:@"repost_count"];
    
    result.thumbnailPicURL = [dict objectForKey:@"thumbnail_pic"];
    result.bmiddlePicURL = [dict objectForKey:@"bmiddle_pic"];
    result.originalPicURL = [dict objectForKey:@"original_pic"];
    
    NSDictionary* geoDic = (NSDictionary*)[dict objectForKey:@"geo"];
    if (geoDic && ![[geoDic class] isSubclassOfClass:[NSNull class]]) {
        result.lat = [[NSNumber alloc] initWithFloat:[[(NSArray*)([geoDic objectForKey:@"coordinates"]) objectAtIndex:0] floatValue]];
        result.lon = [[NSNumber alloc] initWithFloat:[[(NSArray*)([geoDic objectForKey:@"coordinates"]) objectAtIndex:1] floatValue]];
    }
    else {
        result.lat = 0;
        result.lon = 0;
    }
    
    NSDictionary *userDict = [dict objectForKey:@"user"];
    
    result.author = [User insertUser:userDict inManagedObjectContext:context];
    
    NSDictionary* repostedStatusDict = [dict objectForKey:@"retweeted_status"];
    if (repostedStatusDict) {
        result.repostStatus = [Status insertStatus:repostedStatusDict inManagedObjectContext:context];
    }
    
    return result;
}

//+ (Status *)in

+ (Status *)insertTrendsStatus:(NSDictionary *)dict withString:(NSString*)searchString inManagedObjectContext:(NSManagedObjectContext *)context
{
	NSString *statusID = [[dict objectForKey:@"id"] stringValue];
    
    if (!statusID || [statusID isEqualToString:@""]) {
        return nil;
    }
    
    Status *result = [Status statusWithID:statusID inManagedObjectContext:context];
    if (!result) {
        result = [NSEntityDescription insertNewObjectForEntityForName:@"Status" inManagedObjectContext:context];
    }
    
    //    result.updateDate = [NSDate date];
    result.statusID = statusID;
    
    NSString *dateString = [dict objectForKey:@"created_at"];
	result.updateDate = [NSDate dateFromStringRepresentation:dateString];
    result.createdAt = [NSDate dateFromStringRepresentation:dateString];
    
    result.text = [dict objectForKey:@"text"];
    
    result.source = [dict objectForKey:@"source"];
    
    result.favorited = [NSNumber numberWithBool:[[dict objectForKey:@"favorited"] boolValue]];
	result.isMentioned = [NSNumber numberWithBool:NO];
	result.searchString = [NSString stringWithString:searchString];
    
    result.commentsCount = [dict objectForKey:@"comment_count"];
    result.repostsCount = [dict objectForKey:@"repost_count"];
    
    result.thumbnailPicURL = [dict objectForKey:@"thumbnail_pic"];
    result.bmiddlePicURL = [dict objectForKey:@"bmiddle_pic"];
    result.originalPicURL = [dict objectForKey:@"original_pic"];
    
    NSDictionary* geoDic = (NSDictionary*)[dict objectForKey:@"geo"];
    if (geoDic && ![[geoDic class] isSubclassOfClass:[NSNull class]]) {
        result.lat = [[NSNumber alloc] initWithFloat:[[(NSArray*)([geoDic objectForKey:@"coordinates"]) objectAtIndex:0] floatValue]];
        result.lon = [[NSNumber alloc] initWithFloat:[[(NSArray*)([geoDic objectForKey:@"coordinates"]) objectAtIndex:1] floatValue]];
    }
    else {
        result.lat = 0;
        result.lon = 0;
    }
    
    NSDictionary *userDict = [dict objectForKey:@"user"];
    
    result.author = [User insertUser:userDict inManagedObjectContext:context];
    
    NSDictionary* repostedStatusDict = [dict objectForKey:@"retweeted_status"];
    if (repostedStatusDict) {
        result.repostStatus = [Status insertStatus:repostedStatusDict inManagedObjectContext:context];
    }
    
    NSLog(@"----------------------%@", result.text);
    
    return result;
}

+ (int)countOfStatuseInContext:(NSManagedObjectContext *)context

{
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:@"Status" inManagedObjectContext:context]];
    
    [request setIncludesSubentities:NO]; //Omit subentities. Default is YES (i.e. include subentities)
    
    NSError *err;
    NSUInteger count = [context countForFetchRequest:request error:&err];
    if(count == NSNotFound) {
        //Handle error
    }
    
    [request release];
    
    return count;
}

+ (Status *)insertStatus:(NSDictionary *)dict withFeature:(int)feature inManagedObjectContext:(NSManagedObjectContext *)context
{
    NSString *statusID = [[dict objectForKey:@"id"] stringValue];
    
    if (!statusID || [statusID isEqualToString:@""]) {
        return nil;
    }
    
    Status *result = [Status statusWithID:statusID inManagedObjectContext:context];
    if (!result) {
        result = [NSEntityDescription insertNewObjectForEntityForName:@"Status" inManagedObjectContext:context];
    }
    
    result.updateDate = [NSDate date];
    
    result.statusID = statusID;
    
    NSString *dateString = [dict objectForKey:@"created_at"];
    result.createdAt = [NSDate dateFromStringRepresentation:dateString];
    
    result.text = [dict objectForKey:@"text"];
    
    result.source = [dict objectForKey:@"source"];
    
    result.favorited = [NSNumber numberWithBool:[[dict objectForKey:@"favorited"] boolValue]];
    
    result.commentsCount = [dict objectForKey:@"comment_count"];
    result.repostsCount = [dict objectForKey:@"repost_count"];
    
    result.thumbnailPicURL = [dict objectForKey:@"thumbnail_pic"];
    result.bmiddlePicURL = [dict objectForKey:@"bmiddle_pic"];
    result.originalPicURL = [dict objectForKey:@"original_pic"];
    
    switch (feature) {
        case 1:
            result.featureOrigin = [NSNumber numberWithBool:YES];
            break;
        case 2:
            result.featurePic = [NSNumber numberWithBool:YES];
            break;
        case 3:
            result.featureVideo = [NSNumber numberWithBool:YES];
            break;
        case 4:
            result.featureMusic = [NSNumber numberWithBool:YES];
            break;
        default:
            break;
    }
    
    NSDictionary* geoDic = (NSDictionary*)[dict objectForKey:@"geo"];
    if (geoDic && ![[geoDic class] isSubclassOfClass:[NSNull class]]) {
        result.lat = [[NSNumber alloc] initWithFloat:[[(NSArray*)([geoDic objectForKey:@"coordinates"]) objectAtIndex:0] floatValue]];
        result.lon = [[NSNumber alloc] initWithFloat:[[(NSArray*)([geoDic objectForKey:@"coordinates"]) objectAtIndex:1] floatValue]];
    }
    else {
        result.lat = 0;
        result.lon = 0;
    }
    
    NSDictionary *userDict = [dict objectForKey:@"user"];
    
    result.author = [User insertUser:userDict inManagedObjectContext:context];
    
    NSDictionary* repostedStatusDict = [dict objectForKey:@"retweeted_status"];
    if (repostedStatusDict) {
        result.repostStatus = [Status insertStatus:repostedStatusDict inManagedObjectContext:context];
    }
    
    return result;
}

+ (Status *)insertStatus:(NSDictionary *)dict inManagedObjectContext:(NSManagedObjectContext *)context
{
    NSString *statusID = [[dict objectForKey:@"id"] stringValue];
    
    if (!statusID || [statusID isEqualToString:@""]) {
        return nil;
    }
    
    Status *result = [Status statusWithID:statusID inManagedObjectContext:context];
    if (!result) {
        result = [NSEntityDescription insertNewObjectForEntityForName:@"Status" inManagedObjectContext:context];
    }
    
    result.updateDate = [NSDate date];
    
    result.statusID = statusID;
    
    NSString *dateString = [dict objectForKey:@"created_at"];
    result.createdAt = [NSDate dateFromStringRepresentation:dateString];
    
    result.text = [dict objectForKey:@"text"];
    
    result.source = [dict objectForKey:@"source"];
    
    result.favorited = [NSNumber numberWithBool:[[dict objectForKey:@"favorited"] boolValue]];
    
    result.commentsCount = [dict objectForKey:@"comment_count"];
    result.repostsCount = [dict objectForKey:@"repost_count"];
    
    result.thumbnailPicURL = [dict objectForKey:@"thumbnail_pic"];
    result.bmiddlePicURL = [dict objectForKey:@"bmiddle_pic"];
    result.originalPicURL = [dict objectForKey:@"original_pic"];
    
    NSDictionary* geoDic = (NSDictionary*)[dict objectForKey:@"geo"];
    if (geoDic && ![[geoDic class] isSubclassOfClass:[NSNull class]]) {
        result.lat = [[NSNumber alloc] initWithFloat:[[(NSArray*)([geoDic objectForKey:@"coordinates"]) objectAtIndex:0] floatValue]];
        result.lon = [[NSNumber alloc] initWithFloat:[[(NSArray*)([geoDic objectForKey:@"coordinates"]) objectAtIndex:1] floatValue]];
    }
    else {
        result.lat = 0;
        result.lon = 0;
    }
    
    NSDictionary *userDict = [dict objectForKey:@"user"];
    
    result.author = [User insertUser:userDict inManagedObjectContext:context];
    
    NSDictionary* repostedStatusDict = [dict objectForKey:@"retweeted_status"];
    if (repostedStatusDict) {
        result.repostStatus = [Status insertStatus:repostedStatusDict inManagedObjectContext:context];
    }
    
    return result;
}

+ (void)deleteAllObjectsInManagedObjectContext:(NSManagedObjectContext *)context
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Status" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    
    NSArray *items = [context executeFetchRequest:fetchRequest error:NULL];
    [fetchRequest release];
    
    for (NSManagedObject *managedObject in items) {
        [context deleteObject:managedObject];
    }
}

@end
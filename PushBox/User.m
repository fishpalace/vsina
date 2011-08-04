//
//  User.m
//  PushBox
//
//  Created by Xie Hasky on 11-7-24.
//  Copyright (c) 2011年 同济大学. All rights reserved.
//

#import "User.h"
#import "Status.h"
#import "NSDateAddition.h"

@implementation User
@dynamic userID;
@dynamic screenName;
@dynamic location;
@dynamic selfDescription;
@dynamic blogURL;
@dynamic profileImageURL;
@dynamic domainURL;
@dynamic gender;
@dynamic followersCount;
@dynamic friendsCount;
@dynamic statusesCount;
@dynamic favouritesCount;
@dynamic createdAt;
@dynamic verified;
@dynamic following;
@dynamic statuses;
@dynamic comments;
@dynamic friendsStatuses;
@dynamic updateDate;
@dynamic followers;
@dynamic friends;
@dynamic favorites;


+ (User *)insertUser:(NSDictionary *)dict inManagedObjectContext:(NSManagedObjectContext *)context
{
    NSString *userID = [[dict objectForKey:@"id"] stringValue];
    
    if (!userID || [userID isEqualToString:@""]) {
        return nil;
    }
    
    User *result = [User userWithID:userID inManagedObjectContext:context];
    if (!result) {
        result = [NSEntityDescription insertNewObjectForEntityForName:@"User" inManagedObjectContext:context];
    }
    
    result.updateDate = [NSDate date];
    
    result.userID = userID;
    result.screenName = [dict objectForKey:@"screen_name"];
    
    NSString *dateString = [dict objectForKey:@"created_at"];
    result.createdAt = [NSDate dateFromStringRepresentation:dateString];
    
    result.profileImageURL = [dict objectForKey:@"profile_image_url"];
    result.gender = [dict objectForKey:@"gender"];
    result.selfDescription = [dict objectForKey:@"description"];
    result.location = [dict objectForKey:@"location"];
    result.verified = [NSNumber numberWithBool:[[dict objectForKey:@"verified"] boolValue]];
    
    result.domainURL = [dict objectForKey:@"domain"];
    result.blogURL = [dict objectForKey:@"url"];
    
    result.friendsCount = [[dict objectForKey:@"friends_count"] stringValue];
    result.followersCount = [[dict objectForKey:@"followers_count"] stringValue];
    result.statusesCount = [[dict objectForKey:@"statuses_count"] stringValue];
    result.favouritesCount = [[dict objectForKey:@"favourites_count"] stringValue];
    
    BOOL following = [[dict objectForKey:@"following"] boolValue];

    result.following = [NSNumber numberWithBool:following];
    
    NSDictionary *statusDict = [dict objectForKey:@"status"];
    
    if (statusDict) {
        [result addStatusesObject:[Status insertStatus:statusDict inManagedObjectContext:context]];
    }
    
    return result;
}

+ (User *)userWithID:(NSString *)userID inManagedObjectContext:(NSManagedObjectContext *)context
{
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    
    [request setEntity:[NSEntityDescription entityForName:@"User" inManagedObjectContext:context]];
    [request setPredicate:[NSPredicate predicateWithFormat:@"userID == %@", userID]];
    
    User *res = [[context executeFetchRequest:request error:NULL] lastObject];
    
    [request release];
    
    return res;
}

+ (void)deleteAllObjectsInManagedObjectContext:(NSManagedObjectContext *)context
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"User" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    
    NSArray *items = [context executeFetchRequest:fetchRequest error:NULL];
    [fetchRequest release];
    
    for (NSManagedObject *managedObject in items) {
        [context deleteObject:managedObject];
    }
}

- (BOOL)isEqualToUser:(User *)user
{
    return [self.userID isEqualToString:user.userID];
}


@end

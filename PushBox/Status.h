//
//  Status.h
//  PushBox
//
//  Created by Kelvin Ren on 11/21/11.
//  Copyright (c) 2011 同济大学. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Comment, Status, User;

@interface Status : NSManagedObject

@property (nonatomic, retain) NSString * bmiddlePicURL;
@property (nonatomic, retain) NSString * commentsCount;
@property (nonatomic, retain) NSDate * createdAt;
@property (nonatomic, retain) NSNumber * favorited;
@property (nonatomic, retain) NSNumber * isMentioned;
@property (nonatomic, retain) NSString * originalPicURL;
@property (nonatomic, retain) NSString * repostsCount;
@property (nonatomic, retain) NSString * source;
@property (nonatomic, retain) NSString * statusID;
@property (nonatomic, retain) NSString * text;
@property (nonatomic, retain) NSString * thumbnailPicURL;
@property (nonatomic, retain) NSDate * updateDate;
@property (nonatomic, retain) NSString * searchString;
@property (nonatomic, retain) User *author;
@property (nonatomic, retain) NSSet *comments;
@property (nonatomic, retain) User *favoritedBy;
@property (nonatomic, retain) User *isFriendsStatusOf;
@property (nonatomic, retain) NSSet *repostedBy;
@property (nonatomic, retain) Status *repostStatus;

- (BOOL)isEqualToStatus:(Status *)status;
+ (Status *)insertStatus:(NSDictionary *)dict inManagedObjectContext:(NSManagedObjectContext *)context;
+ (Status *)insertMentionedStatus:(NSDictionary *)dict inManagedObjectContext:(NSManagedObjectContext *)context;
+ (Status *)insertTrendsStatus:(NSDictionary *)dict withString:(NSString*)searchString inManagedObjectContext:(NSManagedObjectContext *)context;
+ (Status *)statusWithID:(NSString *)statudID inManagedObjectContext:(NSManagedObjectContext *)context;
+ (void)deleteAllObjectsInManagedObjectContext:(NSManagedObjectContext *)context;
+ (int)countOfStatuseInContext:(NSManagedObjectContext *)context;

@end


@interface Status (CoreDataGeneratedAccessors)

- (void)addCommentsObject:(Comment *)value;
- (void)removeCommentsObject:(Comment *)value;
- (void)addComments:(NSSet *)values;
- (void)removeComments:(NSSet *)values;
- (void)addRepostedByObject:(Status *)value;
- (void)removeRepostedByObject:(Status *)value;
- (void)addRepostedBy:(NSSet *)values;
- (void)removeRepostedBy:(NSSet *)values;

@end

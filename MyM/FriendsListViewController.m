//
//  FriendsListViewController.m
//  MyM
//
//  Created by Justin Wagner on 4/3/13.
//  Copyright (c) 2013 MyM Co. All rights reserved.
//

#import "FriendsListViewController.h"
#import "UtilityClass.h"

#import "AJNotificationView.h"

#define BANNER_DEFAULT_TIME 2

static NSString * const kSearchBarTableViewControllerDefaultTableViewCellIdentifier = @"kSearchBarTableViewControllerDefaultTableViewCellIdentifier";

@interface FriendsListViewController ()

@property(nonatomic, copy) NSMutableArray *friends;
@property(nonatomic, copy) NSArray *sections;

@property(nonatomic, copy) NSArray *filteredFriends;
@property(nonatomic, copy) NSString *currentSearchString;

@property(nonatomic, strong, readwrite) UITableView *tableView;
@property(nonatomic, strong, readwrite) UISearchBar *searchBar;

@property(nonatomic, strong) UISearchDisplayController *strongSearchDisplayController;

@property (nonatomic) NSArray *jsonGetFriends;
@property (nonatomic) NSDictionary *jsonAddFriend;
@property (nonatomic) NSDictionary *jsonDeleteFriend;

@property (nonatomic, copy,   readwrite) NSString *filePath;
@property (nonatomic, strong, readwrite) NSOutputStream *fileStream;

@end

@implementation FriendsListViewController

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (id)initWithSectionIndexes:(BOOL)showSectionIndexes
{
    if ((self = [super initWithNibName:nil bundle:nil])) {
        self.title = @"Friends";
        
        _showSectionIndexes = showSectionIndexes;
        
//        NSString *path = [[NSBundle mainBundle] pathForResource:@"Top100FamousPersons" ofType:@"plist"];
//        _friends = [[NSMutableArray alloc] initWithContentsOfFile:path];
//        
////        self.filePath = [[NSBundle mainBundle] pathForResource:@"FriendsList" ofType:@"plist"];
////        self.fileStream = [NSOutputStream outputStreamToFileAtPath:self.filePath append:YES];
////        [self.fileStream open];
//        
//        NSString *user = [_user token];
//        NSLog(@"%@ DEBUG", user);
//        NSDictionary *jsonDictionary = @{ @"access_token" : user};
//        
//        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
//        dispatch_async(queue, ^{
//            self.jsonGetFriends = [UtilityClass GetFriendsJSON:jsonDictionary toAddress:@"http://54.225.76.23:3000/friends"];
//            dispatch_async(dispatch_get_main_queue(), ^ {
//               if(self.jsonGetFriends)
//                {
//                    //_friends = [self.jsonGetFriends valueForKey: @"name"];
//                }
//                               
////                [self.fileStream close];
////                _friends = [[NSMutableArray alloc] initWithContentsOfFile:self.filePath];
//            });
//        });
//        
//        if (showSectionIndexes) {
//            UILocalizedIndexedCollation *collation = [UILocalizedIndexedCollation currentCollation];
//            
//            NSMutableArray *unsortedSections = [[NSMutableArray alloc] initWithCapacity:[[collation sectionTitles] count]];
//            for (NSUInteger i = 0; i < [[collation sectionTitles] count]; i++) {
//                [unsortedSections addObject:[NSMutableArray array]];
//            }
//            
//            for (NSString *personName in self.friends) {
//                NSInteger index = [collation sectionForObject:personName collationStringSelector:@selector(description)];
//                [[unsortedSections objectAtIndex:index] addObject:personName];
//            }
//            
//            NSMutableArray *sortedSections = [[NSMutableArray alloc] initWithCapacity:unsortedSections.count];
//            for (NSMutableArray *section in unsortedSections) {
//                [sortedSections addObject:[collation sortedArrayFromArray:section collationStringSelector:@selector(description)]];
//            }
//            
//            self.sections = sortedSections;
//        }
    }
    
    return self;
}

-(void) viewWillAppear:(BOOL)animated
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Top100FamousPersons" ofType:@"plist"];
    _friends = [[NSMutableArray alloc] initWithContentsOfFile:path];
    
    //        self.filePath = [[NSBundle mainBundle] pathForResource:@"FriendsList" ofType:@"plist"];
    //        self.fileStream = [NSOutputStream outputStreamToFileAtPath:self.filePath append:YES];
    //        [self.fileStream open];
    
    //                [self.fileStream close];
    //                _friends = [[NSMutableArray alloc] initWithContentsOfFile:self.filePath];
    
    if (_showSectionIndexes) {
        [self loadSections:_friends];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    [self.view addSubview:self.tableView];
    
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectZero];
    self.searchBar.placeholder = @"Search";
    self.searchBar.delegate = self;
    
    [self.searchBar sizeToFit];
    
    self.strongSearchDisplayController = [[UISearchDisplayController alloc] initWithSearchBar:self.searchBar contentsController:self];
    self.searchDisplayController.searchResultsDataSource = self;
    self.searchDisplayController.searchResultsDelegate = self;
    self.searchDisplayController.delegate = self;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (animated) {
        [self.tableView flashScrollIndicators];
    }
}

- (void)scrollTableViewToSearchBarAnimated:(BOOL)animated
{
    NSAssert(YES, @"This method should be handled by a subclass!");
}

#pragma mark - TableView Delegate and DataSource

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    if (tableView == self.tableView && self.showSectionIndexes) {
        return [[NSArray arrayWithObject:UITableViewIndexSearch] arrayByAddingObjectsFromArray:[[UILocalizedIndexedCollation currentCollation] sectionIndexTitles]];
    } else {
        return nil;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (tableView == self.tableView && self.showSectionIndexes) {
        if ([[self.sections objectAtIndex:section] count] > 0) {
            return [[[UILocalizedIndexedCollation currentCollation] sectionTitles] objectAtIndex:section];
        } else {
            return nil;
        }
    } else {
        return nil;
    }
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    if ([title isEqualToString:UITableViewIndexSearch]) {
        [self scrollTableViewToSearchBarAnimated:NO];
        return NSNotFound;
    } else {
        return [[UILocalizedIndexedCollation currentCollation] sectionForSectionIndexTitleAtIndex:index] - 1; // -1 because we add the search symbol
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView == self.tableView) {
        if (self.showSectionIndexes) {
            return self.sections.count;
        } else {
            return 1;
        }
    } else {
        return 1;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.tableView) {
        if (self.showSectionIndexes) {
            return [[self.sections objectAtIndex:section] count];
        } else {
            return self.friends.count;
        }
    } else {
        return self.filteredFriends.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kSearchBarTableViewControllerDefaultTableViewCellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kSearchBarTableViewControllerDefaultTableViewCellIdentifier];
    }
    
    if (tableView == self.tableView) {
        if (self.showSectionIndexes) {
            cell.textLabel.text = [[self.sections objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
        } else {
            cell.textLabel.text = [self.friends objectAtIndex:indexPath.row];
        }
    } else {
        cell.textLabel.text = [self.filteredFriends objectAtIndex:indexPath.row];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    //add code here
}

//- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
//    // Return YES if you want the specified item to be editable.
//    return YES;
//}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //add code here for when you hit delete
        
        NSString *user = [_user token];
        NSString *email = @"wagnerj5@apps.tcnj.edu";
        NSDictionary *jsonDictionary = @{ @"access_token" : user, @"email": email };
        
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_async(queue, ^{
            self.jsonDeleteFriend = [UtilityClass SendJSON:jsonDictionary toAddress:@"http://54.225.76.23:3000/deletefriend"];
            dispatch_async(dispatch_get_main_queue(), ^ {
                if(self.jsonDeleteFriend)
                {
                    if([self.jsonDeleteFriend[@"deleted"] boolValue])
                    {
                        NSLog(@"%@ successfully removed from friends list.", email);
                        NSString *title = email;
                        title = [title stringByAppendingString:@" successfully removed from friends list."];
                        [AJNotificationView showNoticeInView:self.view type:AJNotificationTypeGreen
                                                       title:title
                                             linedBackground:AJLinedBackgroundTypeDisabled
                                                   hideAfter:BANNER_DEFAULT_TIME];
                    }
                    else
                    {
                        NSLog(@"%@ could not be removed from your friends list. Try again.", email);
                        NSString *title = email;
                        title = [title stringByAppendingString:@" could not be removed from your friends list. Try again."];
                        [AJNotificationView showNoticeInView:self.view type:AJNotificationTypeRed
                                                       title:title
                                             linedBackground:AJLinedBackgroundTypeDisabled
                                                   hideAfter:BANNER_DEFAULT_TIME];
                    }
                }
                else
                {
                    NSLog(@"Http request failed.");
                    [AJNotificationView showNoticeInView:self.view type:AJNotificationTypeRed
                                                   title:@"Server request failed."
                                         linedBackground:AJLinedBackgroundTypeDisabled
                                               hideAfter:BANNER_DEFAULT_TIME];
                }
            });
        });

        [self loadSections:_friends];
        //[tableView reloadData];
    }
}

#pragma mark - Search Delegate

- (void)searchDisplayControllerWillBeginSearch:(UISearchDisplayController *)controller
{
    self.filteredFriends = nil;
    self.currentSearchString = @"";
}

- (void)searchDisplayControllerDidEndSearch:(UISearchDisplayController *)controller
{
    self.filteredFriends = nil;
    self.currentSearchString = nil;
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    if (searchString.length > 0) { // Should always be the case
        NSArray *personsToSearch = self.friends;
        if (self.currentSearchString.length > 0 && [searchString rangeOfString:self.currentSearchString].location == 0) { // If the new search string starts with the last search string, reuse the already filtered array so searching is faster
            personsToSearch = self.filteredFriends;
        }
        
        self.filteredFriends = [personsToSearch filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"SELF contains[cd] %@", searchString]];
    } else {
        self.filteredFriends = self.friends;
    }
    
    self.currentSearchString = searchString;
    
    return YES;
}

- (void)loadSections:(NSMutableArray *)friends
{
    NSString *user = [_user token];
    NSDictionary *jsonDictionary = @{ @"access_token" : user};
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        self.jsonGetFriends = [UtilityClass GetFriendsJSON:jsonDictionary toAddress:@"http://54.225.76.23:3000/friends"];
        dispatch_async(dispatch_get_main_queue(), ^ {
            if(self.jsonGetFriends)
            {
                //                _friends = [self.jsonGetFriends valueForKey: @"name"];
            }
        });
    });
    
    UILocalizedIndexedCollation *collation = [UILocalizedIndexedCollation currentCollation];
    
    NSMutableArray *unsortedSections = [[NSMutableArray alloc] initWithCapacity:[[collation sectionTitles] count]];
    for (NSUInteger i = 0; i < [[collation sectionTitles] count]; i++) {
        [unsortedSections addObject:[NSMutableArray array]];
    }
    
    for (NSString *personName in friends) {
        NSInteger index = [collation sectionForObject:personName collationStringSelector:@selector(description)];
        [[unsortedSections objectAtIndex:index] addObject:personName];
    }
    
    NSMutableArray *sortedSections = [[NSMutableArray alloc] initWithCapacity:unsortedSections.count];
    for (NSMutableArray *section in unsortedSections) {
        [sortedSections addObject:[collation sortedArrayFromArray:section collationStringSelector:@selector(description)]];
    }
    
    self.sections = sortedSections;
}

- (void)addFriendButton
{
    NSLog(@"Add a Friend");
    
    NSString *user = [_user token];
    NSString *email = @"wagnerj5@apps.tcnj.edu";
    
    NSDictionary *jsonDictionary = @{  @"access_token" : user,  @"email" : email };
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        self.jsonAddFriend = [UtilityClass SendJSON:jsonDictionary toAddress:@"http://54.225.76.23:3000/createfriend/"];
        dispatch_async(dispatch_get_main_queue(), ^ {
            if(self.jsonAddFriend)
            {
                if(![self.jsonAddFriend[@"friends"] boolValue])
                {
                    if([self.jsonAddFriend[@"exists"] boolValue])
                    {
                        if([self.jsonAddFriend[@"created"] boolValue])
                        {
                            //[_friends addObject:friend];
                            [self loadSections:_friends];
                            NSLog(@"Friend request sent.");
                            [AJNotificationView showNoticeInView:self.view type:AJNotificationTypeGreen
                                                           title:@"Friend request email successfully sent!"
                                                 linedBackground:AJLinedBackgroundTypeDisabled
                                                       hideAfter:BANNER_DEFAULT_TIME];
                        }
                        else
                        {
                            NSLog(@"Friend request failed to send.");
                            [AJNotificationView showNoticeInView:self.view type:AJNotificationTypeRed
                                                           title:@"Friend request failed to send."
                                                 linedBackground:AJLinedBackgroundTypeDisabled
                                                       hideAfter:BANNER_DEFAULT_TIME];
                        }
                    }
                    else
                    {
                        NSLog(@"Friend does not exist.");
                        [AJNotificationView showNoticeInView:self.view type:AJNotificationTypeRed
                                                       title:@"Friend does not exist."
                                             linedBackground:AJLinedBackgroundTypeDisabled
                                                   hideAfter:BANNER_DEFAULT_TIME];
                    }
                }
                else
                {
                    NSLog(@"Already friends with this person.");
                    [AJNotificationView showNoticeInView:self.view type:AJNotificationTypeRed
                                                   title:@"You are already friends with this person."
                                         linedBackground:AJLinedBackgroundTypeDisabled
                                               hideAfter:BANNER_DEFAULT_TIME];
                }
            }
            else if(!self.jsonAddFriend)
            {
                NSLog(@"Http request failed.");
                [AJNotificationView showNoticeInView:self.view type:AJNotificationTypeRed
                                               title:@"Server request failed."
                                     linedBackground:AJLinedBackgroundTypeDisabled
                                           hideAfter:BANNER_DEFAULT_TIME];
            }

        });
    });
    
}

@end
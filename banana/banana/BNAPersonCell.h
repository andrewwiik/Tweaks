//
//  PersonCell.h
//  test
//
//  Created by Brian Olencki on 3/9/16.
//  Copyright © 2016 bolencki13. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BNAPersonCell : UITableViewCell {
    NSString *_name;
    NSString *_detailText;
    UIImage *_icon;
    UIImage *_iconLarge;
    NSString *_information;
    NSString *_country;
    NSString *_twitter;
    NSURL *_facebook;
    NSURL *_github;
    NSURL *_website;
    NSURL *_email;
}

/* The name of the person */
@property (nonatomic, retain, nonnull) NSString *name;

/* The detail identifier for the person (ex: Developer, Designer, Stripper) */
@property (nonatomic, retain, nonnull) NSString *detailText;

/* The image for the person */
@property (nonatomic, retain, nonnull) UIImage *icon;

@property (nonatomic, retain, nonnull) UIImage *iconLarge;
/* Country of origin for the person */
@property (nonatomic, retain, nonnull) NSString *country;

/* Aditional information about the person (ex: Bio, Resume)*/
@property (nonatomic, retain, nonnull) NSString *information;

/* Twitter URL for the person */
@property (nonatomic, retain, nonnull) NSString *twitter;

/* Facebook URL for the person */
@property (nonatomic, retain, nonnull) NSURL *facebook;

/* GitHub URL for the person */
@property (nonatomic, retain, nonnull) NSURL *github;

/* Website URL for the person */
@property (nonatomic, retain, nonnull) NSURL *website;

/* Email URL for the person, Append 'mailto://' to the beginning of the email address */
@property (nonatomic, retain, nonnull) NSURL *email;

/* Default cell height to be used in the tableview delegate */
+ (CGFloat)defaultCellHeight;

/* Default detail text color for the cell */
+ (nonnull UIColor*)defaultDetailTextColor;

/* The only instancetype that should be used. Auto sets the name */
- (nonnull instancetype)initWithName:(nonnull NSString*)name reuseIdentifier:(nonnull NSString *)reuseIdentifier;
@end

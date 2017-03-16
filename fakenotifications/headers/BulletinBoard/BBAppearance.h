#import <BulletinBoard/BBColor.h>
#import <BulletinBoard/BBImage.h>

@interface BBAppearance : NSObject <NSSecureCoding, NSCopying> {

	NSString* _title;
	BBColor* _titleColor;
	BBImage* _image;
	BBColor* _color;
	long long _style;
	NSString* _viewClassName;

}

@property (nonatomic,copy) NSString * title;                      //@synthesize title=_title - In the implementation block
@property (nonatomic,copy) BBColor * titleColor;                  //@synthesize titleColor=_titleColor - In the implementation block
@property (nonatomic,copy) BBImage * image;                       //@synthesize image=_image - In the implementation block
@property (nonatomic,copy) BBColor * color;                       //@synthesize color=_color - In the implementation block
@property (assign,nonatomic) long long style;                     //@synthesize style=_style - In the implementation block
@property (nonatomic,copy) NSString * viewClassName;              //@synthesize viewClassName=_viewClassName - In the implementation block
+(BOOL)supportsSecureCoding;
+(id)appearanceWithTitle:(id)arg1 ;
-(id)replacementObjectForCoder:(id)arg1 ;
-(void)setImage:(BBImage *)arg1 ;
-(id)initWithCoder:(id)arg1 ;
-(void)encodeWithCoder:(id)arg1 ;
-(void)setTitle:(NSString *)arg1 ;
-(BOOL)isEqual:(id)arg1 ;
-(unsigned long long)hash;
-(NSString *)title;
-(long long)style;
-(BBImage *)image;
-(id)copyWithZone:(NSZone*)arg1 ;
-(BBColor *)color;
-(void)setColor:(BBColor *)arg1 ;
-(void)setStyle:(long long)arg1 ;
-(void)setTitleColor:(BBColor *)arg1 ;
-(BBColor *)titleColor;
-(id)awakeAfterUsingCoder:(id)arg1 ;
-(NSString *)viewClassName;
-(void)setViewClassName:(NSString *)arg1 ;
@end
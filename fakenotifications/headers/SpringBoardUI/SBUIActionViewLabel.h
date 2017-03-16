@interface SBUIActionViewLabel : UIView {

	NSString* _text;
	UIColor* _textColor;
	UILabel* _label;
	UILabel* _emojiLabel;

}

@property (nonatomic,copy) NSString * text; 
@property (nonatomic,retain) UIFont * font; 
@property (nonatomic,retain) UIColor * textColor; 
@property (assign,nonatomic) NSInteger textAlignment; 
@property (assign,nonatomic) NSInteger lineBreakMode; 
@property (assign,nonatomic) NSInteger numberOfLines; 
-(id)initWithFrame:(CGRect)arg1 ;
-(void)setNumberOfLines:(NSInteger)arg1 ;
-(void)setTextAlignment:(NSInteger)arg1 ;
-(void)setTextColor:(UIColor *)arg1 ;
-(void)setFont:(UIFont *)arg1 ;
-(NSString *)text;
-(void)setText:(NSString *)arg1 ;
-(UIEdgeInsets)alignmentRectInsets;
-(void)setLineBreakMode:(NSInteger)arg1 ;
-(UIFont *)font;
-(UIColor *)textColor;
-(NSInteger)textAlignment;
-(id)viewForLastBaselineLayout;
-(NSInteger)lineBreakMode;
-(NSInteger)numberOfLines;
-(id)viewForFirstBaselineLayout;
-(void)nc_applyVibrantStyling:(id)arg1 ;
-(void)nc_removeAllVibrantStyling;
@end

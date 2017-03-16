@interface SettingsSwitchTableViewCell : UITableViewCell
- (id)initWithTitle:(id)title switchValue:(char)toggle target:(id)target action:(SEL)action reuseIdentifier:(id)identifier;
- (id)switchControl;
@end
#import "XL/XLForm.h"

NSString *const kSelectorLeftRight = @"selectorLeftRight";
NSString *const kSelectorLeftRightDisabled = @"selectorLeftRightDisabled";


@interface CalendarEventFormViewController: XLFormViewController
@property(nonatomic, retain) XLFormRowDescriptor *selectionRow;
@end

@implementation CalendarEventFormViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self){
        [self initializeForm];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self){
        [self initializeForm];
    }
    return self;
}

- (void)initializeForm {
  XLFormDescriptor * form;
  XLFormSectionDescriptor * section;
  XLFormRowDescriptor * row;

  form = [XLFormDescriptor formDescriptorWithTitle:@"Add Event"];

  // First section
  section = [XLFormSectionDescriptor formSection];
  [form addFormSection:section];

  // Title
  row = [XLFormRowDescriptor formRowDescriptorWithTag:@"title" rowType:XLFormRowDescriptorTypeText];
  [row.cellConfigAtConfigure setObject:@"Title" forKey:@"textField.placeholder"];
  [section addFormRow:row];

  // Location
  row = [XLFormRowDescriptor formRowDescriptorWithTag:@"location" rowType:XLFormRowDescriptorTypeText];
  [row.cellConfigAtConfigure setObject:@"Location" forKey:@"textField.placeholder"];
  [section addFormRow:row];

  // Second Section
  section = [XLFormSectionDescriptor formSection];
  [form addFormSection:section];

  // All-day
  row = [XLFormRowDescriptor formRowDescriptorWithTag:@"all-day" rowType:XLFormRowDescriptorTypeBooleanSwitch title:@"All-day"];
  [section addFormRow:row];

  // Starts
  row = [XLFormRowDescriptor formRowDescriptorWithTag:@"starts" rowType:XLFormRowDescriptorTypeDateTimeInline title:@"Starts"];
  row.value = [NSDate dateWithTimeIntervalSinceNow:60*60*24];
  [section addFormRow:row];

   section = [XLFormSectionDescriptor formSectionWithTitle:@"Inline Selectors"];
    [form addFormSection:section];
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"Butt" rowType:XLFormRowDescriptorTypeSelectorPickerViewInline title:@"Inline Picker View"];
    row.selectorOptions = @[@"Option 1", @"Option 2", @"Option 3", @"Option 4", @"Option 5", @"Option 6"];
    row.value = @"Option 6";
    [section addFormRow:row];
    self.selectionRow = row;

    NSArray * nameList = @[@"family", @"male", @"female", @"client"];

// Enable Insertion, Deletion, Reordering
section = [XLFormSectionDescriptor formSectionWithTitle:@"MultiValued TextField"
                                          sectionOptions:XLFormSectionOptionCanInsert | XLFormSectionOptionCanDelete];
section.multivaluedTag = @"textFieldRow";
[form addFormSection:section];

for (NSString * tag in nameList) {
    // add a row to the section, each row will represent a name of the name list array.
    row = [XLFormRowDescriptor formRowDescriptorWithTag:nil rowType:XLFormRowDescriptorTypeBooleanCheck title:tag];
    row.value = [tag copy];
    [section addFormRow:row];
}
// add an empty row to the section.
row = [XLFormRowDescriptor formRowDescriptorWithTag:nil rowType:XLFormRowDescriptorTypeBooleanCheck title:@"Add Profile"];
[section addFormRow:row];

  self.form = form;
}

-(void)formRowHasBeenAdded:(XLFormRowDescriptor *)formRow atIndexPath:(NSIndexPath *)indexPath {
	[super formRowHasBeenAdded:formRow atIndexPath:indexPath];

}
-(void)formRowHasBeenRemoved:(XLFormRowDescriptor *)formRow atIndexPath:(NSIndexPath *)indexPath {
	[super formRowHasBeenRemoved:formRow atIndexPath:indexPath];

}

@end

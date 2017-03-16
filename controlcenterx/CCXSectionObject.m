#import "CCXSectionObject.h"

@implementation CCXSectionObject

- (id)initWithSectionClass:(Class<CCXSectionControllerDelegate>)sectionClass {

	self = [super init];
	if (self) {
		if ([sectionClass respondsToSelector:@selector(sectionIdentifier)]) {
			self.sectionIdentifier = [sectionClass sectionIdentifier];
		}
		if ([sectionClass respondsToSelector:@selector(sectionName)]) {
			self.sectionName = [sectionClass sectionName];
		}
		if ([sectionClass respondsToSelector:@selector(sectionImage)]) {
			self.sectionIcon = [sectionClass sectionImage];
		}
		if ([sectionClass respondsToSelector:@selector(settingsControllerClass)]) {
			self.settingsControllerClass = [sectionClass settingsControllerClass];
		}
		// if ([sectionClass respondsToSelector:@selector(configuredSettingsController)]) {
		// 	self.configuredSettingsController = [sectionClass configuredSettingsController];
		// }
		self.controllerClass = sectionClass;
	}
	return self;
}

- (id)initWithCoder:(NSCoder *)decoder {
  	if (self = [super init]) {
	    self.sectionIdentifier = [decoder decodeObjectForKey:@"sectionIdentifier"];
	    self.controllerClass = NSClassFromString([decoder decodeObjectForKey:@"sectionClass"]);
	    if ([self.controllerClass respondsToSelector:@selector(sectionName)]) {
			self.sectionName = [self.controllerClass sectionName];
		}
		if ([self.controllerClass respondsToSelector:@selector(sectionImage)]) {
			self.sectionIcon = [self.controllerClass sectionImage];
		}
		if ([self.controllerClass respondsToSelector:@selector(settingsControllerClass)]) {
			self.settingsControllerClass = [self.controllerClass settingsControllerClass];
		}
  	}
  	return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
	[encoder encodeObject:self.sectionIdentifier forKey:@"sectionIdentifier"];
	[encoder encodeObject:NSStringFromClass(self.controllerClass) forKey:@"controllerClass"];
}
@end
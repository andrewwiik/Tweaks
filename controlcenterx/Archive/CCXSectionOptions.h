typedef NS_OPTIONS(NSUInteger, CCXSectionLocation) {
	CCXSectionLocationDefault = 0,
    CCXSectionLocationCenterPortrait = 1 << 0,
    CCXSectionLocationLeftLandscape = 1 << 1,
    CCXSectionLocationCenterLandscape = 1 << 2,
    CCXSectionLocationRightLandscape = 1 << 3,
    CCXSectionLocationLeftPad = 1 << 4,
    CCXSectionLocationRightPad = 1 << 5
};
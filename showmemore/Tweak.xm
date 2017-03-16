%hook CKPhotoPickerCollectionViewController
-(void)setMaxAssetsToDisplay:(long long)arg1 {
	%orig(10000);
}
-(long long)maxAssetsToDisplay {
	return 10000;
}
%end
%hook BluetoothDevice
- (BOOL)isServiceSupported:(unsigned int)arg1 {
	if (arg1 == 1) {
		return NO;
	}
	else {
		return %orig;
	}
}
%end
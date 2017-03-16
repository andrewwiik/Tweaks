extern "C" BOOL MGGetBoolAnswer(CFStringRef);
%hookf(BOOL, MGGetBoolAnswer, CFStringRef key)
{
	#define k(key_) CFEqual(key, CFSTR(key_))
	if (k("nVh/gwNpy7Jv1NOk00CMrw")
	 	|| k("ESA7FmyB3KbJFNBAsBejcg"))
		return YES;
	return %orig;
}
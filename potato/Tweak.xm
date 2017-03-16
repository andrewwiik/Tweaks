#import <xpc/xpc.h>
#import <Foundation/Foundation.h>
#import <Foundation/NSDistributedNotificationCenter.h>
#import "BTAVRCP_ActivatorEvents.h"
@interface BKProcessAssertionServer : NSObject
@end
@interface BTAVRCP_Library : NSObject
@end

@interface BTAVRCP_XpcSession : NSObject
-(NSDictionary *)xpc_dict_to_nsdictionary:(xpc_object_t)xpc_dict;
-(NSArray *)xpc_array_to_ns_array:(xpc_object_t)xpc_array;
-(id)xpc_value_to_ns_object:(xpc_object_t)value;
@end

%hook BTAVRCP_XpcSession
%new
-(NSArray *)xpc_array_to_ns_array:(xpc_object_t)xpc_array{

	__block NSMutableArray *array=[NSMutableArray array];
	int count = xpc_array_get_count(xpc_array);
	xpc_array_applier_t applier = ^(size_t index, xpc_object_t value){
		[array addObject:[self xpc_value_to_ns_object:value]];
		return index<count;
	};
	xpc_array_apply (xpc_array, applier );
	return array;

}
%new
-(id)xpc_value_to_ns_object:(xpc_object_t)value{

	xpc_type_t atype=xpc_get_type(value);

	if (atype==XPC_TYPE_INT64){
		return [NSNumber numberWithInt:xpc_int64_get_value(value)];
	}
	else if (atype == XPC_TYPE_UINT64){
		return [NSNumber numberWithUnsignedInt:xpc_uint64_get_value(value)];
	}
	else if (atype == XPC_TYPE_STRING){
		return [NSString stringWithCString:xpc_string_get_string_ptr(value) encoding:NSUTF8StringEncoding];
	}
	else if (atype == XPC_TYPE_DOUBLE){
		return [NSNumber numberWithDouble:xpc_double_get_value(value)];
	}
	else if (atype == XPC_TYPE_DICTIONARY){
		return [self xpc_dict_to_nsdictionary:value];
	}
	else if (atype == XPC_TYPE_BOOL){
		return [NSNumber numberWithBool:xpc_bool_get_value(value)];
	}

	else if (atype == XPC_TYPE_ARRAY){
		return [self xpc_array_to_ns_array:value];
	}
	else if (atype == XPC_TYPE_DATE){
		return [NSDate dateWithTimeIntervalSince1970:xpc_date_get_value(value)];
	}
	else if (atype == XPC_TYPE_ERROR){
		return @"ERROR DESCRIPTION SHOULD BE HERE";
	}
	else if (atype == XPC_TYPE_DATA){
		const void * data= xpc_data_get_bytes_ptr ( value );
		return [NSData dataWithBytes:data length:xpc_data_get_length(value)];
	}
	else {
		NSLog(@"FAILED TO CONVERT xpc %@ to id, returning  default value",(id)value);
		return (id)value;
	}

}
%new
-(NSDictionary *)xpc_dict_to_nsdictionary:(xpc_object_t)xpc_dict{


	__block NSMutableDictionary *dict=[NSMutableDictionary dictionary];

	xpc_dictionary_applier_t applier =  ^( const char *key, xpc_object_t value){

		NSString *keyAsNSString=[NSString stringWithCString:key encoding:NSUTF8StringEncoding];
		[dict setObject:[self xpc_value_to_ns_object:value] forKey:keyAsNSString];

		return key!=NULL;
	};

	xpc_dictionary_apply(xpc_dict,applier);
	return dict;

}
-(void)handleEvent:(id)arg1  {
	NSDictionary *commandValues = [self xpc_dict_to_nsdictionary:arg1];
	NSString *commandType = [[NSString alloc]initWithFormat:@"%@",[commandValues valueForKeyPath:@"kMsgArgs.kCommand"]];
	if ([commandType isEqualToString:@"4"]) {
		// next song button pressed
		[[objc_getClass("LAActivator") sharedInstance] sendEventToListener:[objc_getClass("LAEvent") eventWithName:BTAVRCP_PotatoNext mode:[[objc_getClass("LAActivator") sharedInstance] currentEventMode]]];
	}
	else if ([commandType isEqualToString:@"5"]) {
		// previous song button pressed
		[[objc_getClass("LAActivator") sharedInstance] sendEventToListener:[objc_getClass("LAEvent") eventWithName:BTAVRCP_PotatoPrevious mode:[[objc_getClass("LAActivator") sharedInstance] currentEventMode]]];
	}
	else if ([commandType isEqualToString:@"2"]) {
		// play/pause button pressed
		[[objc_getClass("LAActivator") sharedInstance] sendEventToListener:[objc_getClass("LAEvent") eventWithName:BTAVRCP_PotatoPlayPause mode:[[objc_getClass("LAActivator") sharedInstance] currentEventMode]]];
	}
	else %orig(arg1);
}
%end
%ctor {
        @autoreleasepool {
        %init;
				[BTAVRCP_ActivatorEvents sharedInstance];
    }
}

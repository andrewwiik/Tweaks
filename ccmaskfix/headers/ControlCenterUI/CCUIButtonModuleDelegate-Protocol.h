@protocol CCUIButtonModuleDelegate
@required
-(void)buttonModule:(id)arg1 willExecuteSecondaryActionWithCompletionHandler:(/*^block*/id)arg2;
-(void)buttonModuleStateDidChange:(id)arg1;
-(void)buttonModulePropertiesDidChange:(id)arg1;
-(id)controlCenterSystemAgent;

@end

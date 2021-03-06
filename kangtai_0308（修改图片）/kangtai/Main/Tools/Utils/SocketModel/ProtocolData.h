//
//
/**
 * Copyright (c) www.bugull.com
 */
//
//

#import <Foundation/Foundation.h>

@interface ProtocolData : NSObject


//@property (nonatomic,assign);

+ (NSData *)workingServer:(UInt16)index;

+ (NSData *)requestConnect:(UInt16)index;



#pragma mark-
#pragma mark-0x61
+ (NSData *)heartBeat:(UInt16)index WithUDP:(BOOL)Type;

//+ (NSData *)subscribeTimer:(BOOL)sub device:(Device *)device pinNum:(UInt8)pinNum index:(UInt16)index key:(NSData *)key;
//
//+ (NSData *)subscribeConnection:(BOOL)sub device:(Device *)device index:(UInt16)index key:(NSData *)key;
//
//+ (NSData *)subscribeGPIO:(BOOL)sub device:(Device *)device index:(UInt16)index key:(NSData *)key;
//
//+ (NSData *)queryConnection:(Device *)device index:(UInt16)index key:(NSData *)key;
//
//+ (NSData *)queryNewVersion:(Device *)device index:(UInt16)index key:(NSData *)key;
//
//+ (NSData *)queryDeviceInfo:(Device *)device index:(UInt16)index key:(NSData *)key;
//
//+ (NSData *)setDeviceName:(NSString *)name device:(Device *)device index:(UInt16)index key:(NSData *)key;

//+ (NSData *)addAccounts:(NSArray *)accounts admin:(NSString *)admin device:(Device *)device index:(UInt16)index key:(NSData *)key;

//+ (NSData *)updateModule:(NSString *)url device:(Device *)device index:(UInt16)index key:(NSData *)key;


#pragma mark- 0x23 GetIP Key

+ (NSData *)discoveryDevicesWithMac:(NSData *)mac index:(UInt16)index deviceType:(NSString *) type;

#pragma mark- 0x21

//+ (NSData *)discoveryDevices:(NSString *)account index:(UInt16)index;

#pragma mark-Timing 0x03 GPIO

+ (NSData *)timingDataWith:(NSData *)mac flag:(UInt8)flag Hour:(UInt8)hour  min:(UInt8)min  switchcc:(UInt8)on_off  isUDP:(BOOL)UDP  numberTaks:(UInt8)task  key:(NSData *)key deviceType:(NSString *)type;

#pragma mark- 0x02 GPIO

+ (NSData *)queryGPIOWithSockets:(NSArray *)sockets device:(Device *)device index:(UInt16)index key:(NSData *)key;

//23
+ (NSData *)discoveryDevices:(UInt16)index deviceType:(NSString *)type;

#pragma mark-
+ (NSData *)queryGPIOWithdevice:(NSData *)mac deviceType:(NSString *)type;

#pragma mark-Timing 0x04 GPIO 查询

+ (NSData *)gettimingDataWith:(NSData *)mac  key:(NSData *)key deviceType:(NSString *)type;

#pragma mark-0x05 GPIO 删除

+ (NSData *)deleteGPIOWithMac:(NSData *)mac Num:(UInt8)number deviceType:(NSString *)type;


#pragma mark-add_23
+ (NSData *)UpdataIPTodeviceWithMac:(NSData *)mac;
+ (NSData *)addDeviceWithFF_FFTolocalisUpData:(BOOL)isUpData WithMac:(NSData *)mac key:(NSData *)key companyCode:(UInt8)company;

+ (NSData *)UpdataIPToEnergyDeviceWithMac:(NSData *)mac;
+ (NSData *)addEnergyDeviceWithFF_FFTolocalisUpData:(BOOL)isUpData WithMac:(NSData *)mac key:(NSData *)key companyCode:(UInt8)company;

+ (NSData *)UpdataIPToRFDeviceWithMac:(NSData *)mac;
+ (NSData *)addRFDeviceWithFF_FFTolocalisUpData:(BOOL)isUpData WithMac:(NSData *)mac key:(NSData *)key companyCode:(UInt8)company;

#pragma mark- 0x24 Lock

+ (NSData *)lockWithdevice:(NSData *)mac  linex:(UInt8)line key:(NSData *)key deviceType:(NSString *)type;

#pragma mark- 0x01 GPIO

+ (NSData *)setGPIOWithdevice:(NSData *)mac index:(UInt16)index linex:(UInt8)line key:(NSData *)key deviceType:(NSString *)type;

#pragma mark-0x0D 433

+ (NSData *)onAndOffTo433WithMac:(NSData *)mac  UDP:(BOOL)udp address:(NSData *)addres cmd:(UInt8)cmd type:(NSString *)type timerDic:(NSDictionary *)dic;


#pragma mark-
#pragma mark-0x62

+ (NSData *)getDeviceInfoToMac:(NSData *)mac deviceType:(NSString *)type;

#pragma mark-0x61
+(NSData *)heartBeatWithUDPWithMac:(NSData *)mac withDeviceType:(NSString *)type;
#pragma mark-
#pragma mark-0x65

+ (NSData *)firmwareUpgradeWithMac:(NSData *)mac WithUrlLen:(UInt8)len WithUrl:(NSData *)urlData WithKey:(NSData *)key deviceType:(NSString *)type;
#pragma mark-0x83
+ (NSData *)subscribetoevents:(NSData *)mac WithSwitch:(UInt8)indx WithCmd:(UInt8)cmd deviceType:(NSString *)type;

#pragma mark-0x84
+ (NSData *)queryEquipmentOnlineWithMac:(NSData *)mac deviceType:(NSString *)type;


//#pragma mark-0x85
//+ (NSData *)deviceOnlineWithMac:(NSData *)mac withSwitch:(UInt8)indx;

#pragma mark-0x86
+ (NSData *)getFirwareVersionNumberWithMac:(NSData *)mac deviceType:(NSString *)type;


#pragma mark-Timing 0x09 防盗

+ (NSData *)setAbsenceDataWith:(NSData *)mac WithFlag:(UInt8)flag  WithFromStateData:(NSData *)fromData WithToData:(NSData *)toData key:(NSData *)key deviceType:(NSString *)type;

#pragma mark-Timing 0x0A 防盗查询

+ (NSData *)getQueryTheftModeWith:(NSData *)mac key:(NSData *)key deviceType:(NSString *)type;

#pragma mark-Timing 0x08 设置倒计时
+ (NSData *)countdownDataWith:(NSData *)mac flag:(UInt8)flag Hour:(UInt8)hour  min:(UInt8)min  switchcc:(UInt8)on_off  isUDP:(BOOL)UDP  numberTaks:(UInt8)task  key:(NSData *)key deviceType:(NSString *)type;

#pragma mark-Timing 0x09 查询倒计时
+ (NSData *)getCountdownDataWith:(NSData *)mac key:(NSData *)key deviceType:(NSString *)type orderType:(NSString *)order;

#pragma mark - 0x0B 电量查询
+ (NSData *)getDeviceWattInfoWithMac:(NSData *)mac key:(NSData *)key;

@end

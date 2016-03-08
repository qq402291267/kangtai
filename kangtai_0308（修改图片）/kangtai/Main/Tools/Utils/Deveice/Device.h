//
//
/**
 * Copyright (c) www.bugull.com
 */
//
//

#import <Foundation/Foundation.h>
#import "NSCodingUtil.h"
#import "DragSortView.h"

@class Device;
@protocol GPIOWatcher <NSObject>

- (void)gpioChangedInDevice:(Device *)device;

@end

@protocol DeviceObserver <NSObject>

- (void)statusChanged:(Device *)device;

@end

@interface Device : NSCodingObject <SortUnit,NSCopying>

@property (strong,nonatomic) NSString * pk;

@property(nonatomic,strong)NSString *deviceId;

@property(nonatomic,strong)NSString *LockType;

@property (nonatomic,assign) NSInteger page;

@property (nonatomic,assign) NSInteger index;

@property (readonly,nonatomic,getter = isConnected) BOOL connected;

@property (nonatomic,getter = isLocked) BOOL locked;

@property (strong,nonatomic) NSString * name;

@property (copy,nonatomic) NSString * alarm;

@property (strong,nonatomic) NSString * image;

@property (copy,nonatomic)NSString *macString;

@property (copy,nonatomic) NSString * codeString;

@property (copy,nonatomic) NSString * deviceType;

@property (copy,nonatomic) NSString * authCodeString;

@property (assign,nonatomic)NSInteger  orderNumber;

@property (strong,nonatomic) NSArray * socketArray;

@property (strong,nonatomic) NSData * mac;

@property (nonatomic,assign) UInt16 interval;

@property (nonatomic) UInt8 accessCode;

@property (nonatomic) UInt8 productor;

@property (nonatomic) UInt8 type;

@property (nonatomic,strong) NSString * typeString;

@property (strong,nonatomic) NSData * authCode;

@property (strong,nonatomic) NSString * host;

@property (strong,nonatomic) NSData * key;

@property (strong,nonatomic) NSString* keyString;


@property (copy,nonatomic) NSString * hver;

@property (copy,nonatomic) NSString * sver;

@property (nonatomic,copy) NSString * localContent;

@property (nonatomic,copy) NSString *  remoteContent;

@property (nonatomic,copy) NSString *  deviceOpen;

@property (nonatomic,assign) BOOL deviceRespons;

@property (nonatomic,strong)NSTimer * heartbeatTimer;


@property (nonatomic,strong)NSTimer * heartTimer;

@property (nonatomic,strong)NSTimer * heartNumberTimer;

@property (nonatomic, assign) int heartBeatNumber;

@property (weak,nonatomic) id gpioWatcher;

+ (id)copyWithZone:(NSZone *)zone;

- (void)didConnect:(NSData *)response;

- (void)disConnect;

- (int)socketNumber;

- (void)updateGPIOWithPinArray:(NSArray *)pinArray;

- (void)updatePin:(NSData *)pin;

- (void)setObserver:(id)observer;

- (void)initSocketArray;

@end

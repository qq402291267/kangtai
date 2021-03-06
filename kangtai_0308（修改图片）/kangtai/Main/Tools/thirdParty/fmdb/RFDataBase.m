
#import "RFDataBase.h"

@implementation RFDataBase


static RFDataBase *_db = nil;

static FMDatabase * database = nil;

+ (RFDataBase *)shareInstance{
    
    @synchronized(self){
        
        if (!_db) {
            
            _db = [[RFDataBase alloc]init];
            
            [self openDataBase];
            //
            [self createTable];
        }
    }
    
    return _db;
}

+ (NSString *)getPath
{
    NSArray *documentPath =NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *path = [documentPath objectAtIndex:0];
    NSString *myPath = [path stringByAppendingPathComponent:@"RFTest.sqlite"];
    
    return myPath;
}

+ (void)openDataBase
{
    if (database) {
        
        return;
    }
    database = [FMDatabase databaseWithPath:[self getPath]];
    if (![database open]) {
        NSLog(@"open cancel打开失败");
        return;
    }else{
        NSLog(@"open OK 成功");
    }
    // 为数据库设置缓存,提高查询效率
    database.shouldCacheStatements = YES;
}
#pragma mark - 关闭数据库操作
+ (void)closeDataBase{
    
    if (![database close]) {
        NSLog(@"关闭数据库失败");
        return;
    }
    
    database = nil;
    NSLog(@"关闭数据库成功");
    
}

#pragma mark - 管理创建表的操作
+ (void)createTable{
    
    [self openDataBase];
    
    // 判断表是否存在,不存在就创建------ tableExists
    if (![database tableExists:@"RFDataTable"]) {
        
        [database executeUpdate:@"CREATE TABLE RFDataTable( id INTEGER PRIMARY KEY AUTOINCREMENT,MAC TEXT, name TEXT, logo TEXT, state TEXT,type TEXT,address TEXT,orderNumber INTEGER,username TEXT)"];
        
        NSLog(@"创建表成功");
    }
    
    [self closeDataBase];
}
#pragma mark - 增加数据操作----- executeUpdate
+ (void)insertIntoDataBase:(RFDataModel *)model{
    
    [self openDataBase];
    NSString *userName = [[NSUserDefaults standardUserDefaults] objectForKey:KEY_USERMODEL];
    [database executeUpdate:@"INSERT INTO RFDataTable (MAC,name,logo,state,type,address,orderNumber,username) VALUES (?,?,?,?,?,?,?,?)",model.rfDataMac,model.rfDataName,model.rfDataLogo,model.rfDataState,model.typeRF,model.address,[NSNumber numberWithInteger:model.orderNumber],userName];
    
    [self closeDataBase];
    
}

#pragma mark - 删除数据操作----- executeUpdate
+ (void)deleteDataFromDataBase:(RFDataModel *)model{
    
    [self openDataBase];
    
    [database executeUpdate:[NSString stringWithFormat:@" DELETE FROM RFDataTable WHERE id = %@",model.rfDataId ]];
    
    [self closeDataBase];
}


#pragma mark - 查询数据操作(与其他的都不一样,查询是调用executeQuery,切记切记!!!!!!)
+ (NSMutableArray *)selectAllDataFromDataBase:(NSString *)data
{
    
    [self openDataBase];
    
    NSString *userName = [[NSUserDefaults standardUserDefaults] objectForKey:KEY_USERMODEL];

    FMResultSet * resultSet = [database executeQuery:@" SELECT * FROM RFDataTable WHERE username =? AND MAC = ?",userName,data];
    
    NSMutableArray *murableArray = [[NSMutableArray alloc] initWithCapacity:0];
    while ([resultSet next]) {
        RFDataModel *model = [[RFDataModel alloc] init];
        model.rfDataId = [resultSet stringForColumn:@"id"];
        model.rfDataMac = [resultSet stringForColumn:@"MAC"];
        model.rfDataName = [resultSet stringForColumn:@"name"];
        model.rfDataLogo = [resultSet stringForColumn:@"logo"];
        model.rfDataState = [resultSet stringForColumn:@"state"];
        model.typeRF = [resultSet stringForColumn:@"type"];
        model.address = [resultSet stringForColumn:@"address"];
        model.orderNumber = [resultSet intForColumn:@"orderNumber"];
        
        [murableArray addObject:model];
    }
    

    [self closeDataBase];
    return murableArray;
}


+ (NSMutableArray *)selectDataFromDataBaseWithAddress:(NSString *)address
{
    [self openDataBase];
    
    FMResultSet * resultSet = [database executeQuery:[NSString stringWithFormat:@" SELECT * FROM RFDataTable WHERE address IN ('%@')",address]];
    
    NSMutableArray *murableArray = [[NSMutableArray alloc] initWithCapacity:0];
    while ([resultSet next]) {
        RFDataModel *model = [[RFDataModel alloc] init];
        model.rfDataId = [resultSet stringForColumn:@"id"];
        model.rfDataMac = [resultSet stringForColumn:@"MAC"];
        model.rfDataName = [resultSet stringForColumn:@"name"];
        model.rfDataLogo = [resultSet stringForColumn:@"logo"];
        model.rfDataState = [resultSet stringForColumn:@"state"];
        model.typeRF = [resultSet stringForColumn:@"type"];
        model.address = [resultSet stringForColumn:@"address"];
        model.orderNumber = [resultSet intForColumn:@"orderNumber"];

        [murableArray addObject:model];
    }
    
    [self closeDataBase];
    return murableArray;
}

#pragma mark - 给RF设备列表排正序
+ (NSMutableArray *)ascWithRFTableINorderNumber
{
    [self openDataBase];
    
    NSString *userName = [[NSUserDefaults standardUserDefaults]objectForKey:KEY_USERMODEL];
    //@"SELECT * FROM  DataTable order by orderNumber ASC"
    //    [NSString stringWithFormat:@" SELECT * FROM DataTable WHERE MAC IN ('%@')",data]]
    FMResultSet * resultSet = [database  executeQuery:@" SELECT * FROM RFDataTable WHERE username=?order by orderNumber ASC",userName];
    NSMutableArray *murableArray = [[NSMutableArray alloc] initWithCapacity:0];
    
    while ([resultSet next])
    {
        RFDataModel *model = [[RFDataModel alloc] init];
        model.rfDataId = [resultSet stringForColumn:@"id"];
        model.rfDataMac = [resultSet stringForColumn:@"MAC"];
        model.rfDataName = [resultSet stringForColumn:@"name"];
        model.rfDataLogo = [resultSet stringForColumn:@"logo"];
        model.rfDataState = [resultSet stringForColumn:@"state"];
        model.typeRF = [resultSet stringForColumn:@"type"];
        model.address = [resultSet stringForColumn:@"address"];
        model.orderNumber = [resultSet intForColumn:@"orderNumber"];
        
        [murableArray addObject:model];
        
    }
    
    
    [self closeDataBase];
    
    return murableArray;
}

#pragma mark - 给RF设备列表排倒序
+ (NSMutableArray *)descWithRFTableINorderNumber
{
    [self openDataBase];
    NSString *userName = [[NSUserDefaults standardUserDefaults]objectForKey:KEY_USERMODEL];
    
    FMResultSet * resultSet  = [database executeQuery:@"SELECT * FROM RFDataTable WHERE username=? ORDER BY orderNumber DESC",userName];
    NSMutableArray *murableArray = [[NSMutableArray alloc] initWithCapacity:0];
    while ([resultSet next])
    {
        RFDataModel *model = [[RFDataModel alloc] init];
        model.rfDataId = [resultSet stringForColumn:@"id"];
        model.rfDataMac = [resultSet stringForColumn:@"MAC"];
        model.rfDataName = [resultSet stringForColumn:@"name"];
        model.rfDataLogo = [resultSet stringForColumn:@"logo"];
        model.rfDataState = [resultSet stringForColumn:@"state"];
        model.typeRF = [resultSet stringForColumn:@"type"];
        model.address = [resultSet stringForColumn:@"address"];
        model.orderNumber = [resultSet intForColumn:@"orderNumber"];
        
        [murableArray addObject:model];
    }
    
    
    [self closeDataBase];
    
    return murableArray;
    
}


#pragma mark - 更新数据操作----- executeUpdate
+ (void)updateFromDataBase:(RFDataModel *)model{
    
    [self openDataBase];
    
    [database executeUpdate:[NSString stringWithFormat:@"UPDATE RFDataTable SET MAC ='%@', name ='%@', logo ='%@', type='%@', orderNumber='%d' WHERE address ='%@'", model.rfDataMac, model.rfDataName,model.rfDataLogo,model.typeRF,(int)model.orderNumber, model.address]];
    
    [self closeDataBase];
}


@end

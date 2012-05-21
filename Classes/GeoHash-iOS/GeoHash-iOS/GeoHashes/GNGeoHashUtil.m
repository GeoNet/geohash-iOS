//
//  GNGeohashUtil.m
//  GeoNetQuakeIB
//
//  Created by Manuel Beuttler on 20/04/12.
//  Copyright (c) 2012 KJEW Investments Pty Ltd t/as AppTastic. All rights reserved.
//

#import "GNGeohashUtil.h"

@implementation GNGeohashUtil

static int numbits = 6 * 5;

+ (NSString*) encodeLatitude: (double)latitude andLongitude:(double)longitude withPrecision:(int)numbChar
{
    return [[GNGeohashUtil encodeLatitude:latitude andLongitude:longitude]substringToIndex:numbChar];
}

+ (NSString*) encodeLatitude: (double)latitude andLongitude:(double)longitude
{
    NSArray *latBits = [GNGeohashUtil getBitsForLat:latitude floor:-90.0 ceiling:90.0];
    NSArray *lonBits = [GNGeohashUtil getBitsForLat:longitude floor:-180.0 ceiling:180];
    
    NSMutableArray *buffer = [[NSMutableArray alloc]init];
    for (int i=0; i<numbits; i++)
    {
        [buffer addObject: [lonBits objectAtIndex:i]];
        [buffer addObject: [latBits objectAtIndex:i]];
    }
    NSString *bufferAsString = [buffer componentsJoinedByString:@""];

    return [GNGeohashUtil base2tobase32:bufferAsString];
    //long binlong = [GNGeohashUtil bin2long:bufferAsString];
                    
    //return [GNGeohashUtil base32:binlong];
}

+(long)bin2long:(NSString*)binstr
{
    long ret = 0;
    int len = [binstr length];
    long val = 1;
    
    while (--len >= 0)
    {
        NSRange digrange = NSMakeRange(len,1);
        int digval = [[binstr substringWithRange:digrange] intValue];
        switch (digval)
        {
            case 0:
            {
                break;
            }
            case 1:
            {
                ret+=val;
                break;
            }
            default:
            {
                NSLog(@"ERROR: Binary value of '%d' is not valid.",digval);
            }
        }
        val*=2;
    }
//    NSLog(@"bin(%@)=%ld",binstr,ret);
    return ret;
}



+(NSString*)base2tobase32:(NSString*)binstr
{
    NSMutableString *sret = [[NSMutableString alloc] initWithCapacity:32];
    
    int len = [binstr length];
    
//    NSLog(@"len is %d",len);
    NSArray *digits = [[NSArray alloc] initWithObjects:@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"b",@"c",@"d",@"e",@"f",@"g",@"h",@"j",@"k",@"m",@"n",@"p",@"q",@"r",@"s",@"t",@"u",@"v",@"w",@"x",@"y",@"z", nil];

    while (len >= 5)
    {
        int ret = 0;
        int val = 1;
        int s = 5;
        len-=5;
        while (--s >= 0)
        {
            NSRange digrange = NSMakeRange((s+len),1);
            int digval = [[binstr substringWithRange:digrange] intValue];
        
            switch (digval)
            {
                case 0:
                {
                    break;
                }
                case 1:
                {
                    ret+=val;
                    break;
                }
                default:
                {
                    NSLog(@"ERROR: Binary value of '%d' is not valid.",digval);
                }
            }
            val*=2;
        }
        
//        NSLog(@"%@ = %d => %@",[binstr substringWithRange:NSMakeRange(len,5)], ret,[digits objectAtIndex:ret]);
        
        [sret insertString:[digits objectAtIndex:ret] atIndex:0];
        
        // ret is the offset into the array now
    }
//    NSLog(@"base32(%@)=%@",binstr,sret);
    return [NSString stringWithString:sret];
}

+ (NSArray*) getBitsForLat:(double)lat floor:(double)floor ceiling:(double) ceiling
{
    NSMutableArray *buffer = [[NSMutableArray alloc]initWithCapacity:numbits];
    
    for (int i=0; i < numbits; i++)
    {
        double mid = (floor + ceiling) /2;
        
        if (lat >= mid)
        {
            [buffer insertObject:[NSNumber numberWithBool:TRUE] atIndex:i];
            floor = mid;
        }else 
        {
            [buffer insertObject:[NSNumber numberWithBool:FALSE] atIndex:i];
            ceiling = mid;
        }
    }
    
    return buffer;
}

+ (NSString*) base32:(long)i
{
    NSArray *digits = [[NSArray alloc] initWithObjects:@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"b",@"c",@"d",@"e",@"f",@"g",@"h",@"j",@"k",@"m",@"n",@"p",@"q",@"r",@"s",@"t",@"u",@"v",@"w",@"x",@"y",@"z", nil];
    
    //Generate a empty array
    int capacity = 65;
    NSMutableArray *buf = [[NSMutableArray alloc]initWithCapacity:capacity];
    for (int i = 0; i < capacity; i ++) {
        [buf addObject: @""];
    }
    
    int charPos = 64;
    BOOL negative = (i < 0);
    
    if (!negative)
    {
        i = -i;
    }
    
    while (i <= -32)
    {
        NSString *digit = [digits objectAtIndex:-(i%32)];
        [buf replaceObjectAtIndex:charPos-- withObject:digit];
        i /= 32;
        NSLog(@"Base32: %@",[buf componentsJoinedByString:@""]);
        NSLog(@"%ld left",i);
    }
    [buf replaceObjectAtIndex:charPos withObject:[digits objectAtIndex:-i]];
    
    if (negative)
    {
        [buf insertObject:@"-" atIndex:--charPos];
    }
    NSArray *subArray = [buf subarrayWithRange:NSMakeRange(charPos, 65 - charPos)];
    
    NSString *result = [subArray componentsJoinedByString:@""];
    return result;
}

@end

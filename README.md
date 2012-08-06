# geohash-iOS

geohash-iOS is an implementation of GeoHash based spacial proximity calculation in Objective-C to be used for mobile applications. It contains the necessary classes and a tester to check the functionality.

## GeoHashes

### Introduction

A GeoHash is a representation for a certain location on the world map. It is encoded through an amount of base32 characters depending on a given precision. The string can be transfered into a binary representation where the even bits are extracted to calculate longitude and the odd bits to calculate latitude correspondingly.

GeoHashes are easy to handle compared to the numerical latitude/longitude values. In that way they are good for data processing and storage of point data.

A good detailled description can be found at [Wikipedia](http://en.wikipedia.org/wiki/Geohash). 

To check the position of a hash, go to [http://geohash.org](http://geohash.org). Add the hash string to the URL (e.g. for hash *r3gqm68z9gnw* enter [http://geohash.org/r3gqm68z9gnw](http://geohash.org/r3gqm68z9gnw) as URL.

The precision of a GeoHash increases with each additional character. Assuming the first character defines a large area on the map of e.g. 1000 sqkm, an additional second character will define a smaller area of e.g. 100 sqkm within the area defined by the first character. In that way the chain of characters can be regarded as hierachical nested area definitions with each additional character defining a point/area more precise within a larger area. A good visual description of the concept is given in this [presentation](http://www.basistech.com/pdf/events/open-source-search-conference/oss-2011-smiley-geospatial-search.pdf). An interactive map with areas visualized depending on hash precision can be found at [openlocation.org](http://openlocation.org/geohash/geohash-js/).

### Application 

According to the hierarchical definition of subareas in a hash string it is easy to identify whether different hashes are within a certain proximity. E.g. given hashes *r3gqm68z9gnw* and *r3gqm68z9gnx* and a required precision of e.g. *12* it can be assumed the hashes to be quite close to each other since only the last character differs while a hash *u33dc0f42e445* would far away.

At [GNS Science](http://www.geonet.org.nz/) the idea is used to identify whether the location of an appearing or expected earthquake is close to any cities. An [iPhone App](http://itunes.apple.com/au/app/geonetquake/id533054360?mt=8) can be used to find occurences close to certain areas.

## Usage

The main-method is to be found in the supporting files folder in the file main.m. The test method is testGeoHashes in the GNViewController class.

### Calculate a GeoHash from a given numerical latitude/longitude representation of a point

```objective-c
float lat = -34.042580;
float lon = 151.052139;
int precision = 12;

GNGeoHash *gh = [GNGeoHash withCharacterPrecision:lat andLongitude:lon andNumberOfCharacters:precision];

//print the result
NSLog(@"GeoHash is %@",[gh toBase32]);
```

Result is
```
GeoHash is r3gqm68z9gnw
```

### Calculate Neighbors

```objective-c
GNGeoHash *gh = [GNGeoHash withCharacterPrecision:lat andLongitude:lon andNumberOfCharacters:precision];

GNGeoHash *northern = [gh getNorthernNeighbour];
GNGeoHash *eastern = [gh getEasternNeighbour];
GNGeoHash *southern = [gh getSouthernNeighbour];
GNGeoHash *western = [gh getWesternNeighbour];

//print results
NSLog(@"Northern hash is %@",[northern toBase32]);
NSLog(@"Eastern hash is %@",[eastern toBase32]);
NSLog(@"Southern hash is %@",[southern toBase32]);
NSLog(@"Western hash is %@",[western toBase32]);
```

Result is
```
Northern hash is r3gqm68z9gnx
Eastern hash is  r3gqm68z9gny
Southern hash is r3gqm68z9gnt
Western hash is W has GeoHash r3gqm68z9gnq
```

### Obtain numerical latitude/longitude values for the area described by the given GeoHash

```objective-c
GNGeoHash *gh = [GNGeoHash withCharacterPrecision:lat andLongitude:lon andNumberOfCharacters:precision];

NSLog(@"Upper left corner is %@",[gh.boundingBox getUpperLeft]);
NSLog(@"Lower right corner is %@",[gh.boundingBox getLowerRight]);
```

Result is
```
Upper left corner is -34.042580,151.052139
Lower right corner is -34.042580,151.052140
```
## Restrictions

* Latitude values have to be between -90 and 90
* Longitude values have to be between -180 and 180
* Precision has to be between 1 and 12

## Requirements
* iOS 5.1

## License
*(This project is released under the [GPL](https://github.com/Narfit/TestRep/blob/master/COPYING))*

Copyright (c) 2012 GNS Science. All rights reserved. http://www.gns.cri.nz/

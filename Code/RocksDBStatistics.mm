//
//  RocksDBStatistics.m
//  ObjectiveRocks
//
//  Created by Iska on 04/01/15.
//  Copyright (c) 2015 BrainCookie. All rights reserved.
//

#import "RocksDBStatistics.h"

#import <rocksdb/statistics.h>

#pragma mark - Informal Protocols

@interface RocksDBStatistics ()
{
	std::shared_ptr<rocksdb::Statistics> _statistics;
}
@property (nonatomic, assign) std::shared_ptr<rocksdb::Statistics> statistics;
@end

@interface RocksDBStatisticsHistogram ()
@property (nonatomic, copy) NSString *ticker;
@property (nonatomic, assign) double median;
@property (nonatomic, assign) double percentile95;
@property (nonatomic, assign) double percentile99;
@property (nonatomic, assign) double average;
@property (nonatomic, assign) double standardDeviation;
@end

#pragma mark - Impl

@implementation RocksDBStatistics
@synthesize statistics = _statistics;

static rocksdb::Tickers RocksDBTickerToNativeTicker(RocksDBTicker ticker)
{
	switch (ticker) {
		// RocksDB 11 inserted new tickers before these legacy ObjectiveRocks cases,
		// so raw enum forwarding no longer points at the intended counters.
		case RocksDBTickerBytesWritten:
			return rocksdb::BYTES_WRITTEN;
		case RocksDBTickerBytesRead:
			return rocksdb::BYTES_READ;
		default:
			return static_cast<rocksdb::Tickers>(ticker);
	}
}

#pragma mark - Lifecycle

- (instancetype)init
{
	self = [super init];
	if (self) {
		_statistics = rocksdb::CreateDBStatistics();
	}
	return self;
}

- (void)dealloc
{
	@synchronized(self) {
		if (_statistics != nullptr) {
			_statistics.reset();
		}
	}
}

#pragma mark - Accessor

- (uint64_t)countForTicker:(RocksDBTicker)ticker
{
	return _statistics->getTickerCount(RocksDBTickerToNativeTicker(ticker));
}

- (RocksDBStatisticsHistogram *)histogramDataForType:(RocksDBHistogram)ticker
{
	rocksdb::HistogramData *data = new rocksdb::HistogramData;
	_statistics->histogramData(ticker, data);

	RocksDBStatisticsHistogram *histogram = [RocksDBStatisticsHistogram new];

	std::string tickerName = rocksdb::HistogramsNameMap[ticker].second;

	histogram.ticker = [NSString stringWithCString:tickerName.c_str() encoding:NSUTF8StringEncoding];
	histogram.median = data->median;
	histogram.percentile95 = data->percentile95;
	histogram.percentile99 = data->percentile99;
	histogram.average = data->average;
	histogram.standardDeviation = data->standard_deviation;

	delete data;

	return histogram;
}

#pragma mark - Description

- (NSString *)description
{
	return [NSString stringWithCString:_statistics->ToString().c_str() encoding:NSUTF8StringEncoding];
}

@end

//
//  RocksDBCallbackSliceTransform.cpp
//  ObjectiveRocks
//
//  Created by Iska on 26/12/14.
//  Copyright (c) 2014 BrainCookie. All rights reserved.
//

#include "RocksDBCallbackSliceTransform.h"

class RocksDBCallbackSliceTransformImpl : public rocksdb::SliceTransform
{
private:
	void* instance;
	const char* name;
	TransformCallback transformCallback;
	InDomainCallback inDomainCallback;
	SameResultWhenAppendedCallback sameResultWhenAppendedCallback;
	
public:
	RocksDBCallbackSliceTransformImpl(void* instance, const char* name,
									  TransformCallback transform,
									  InDomainCallback domain,
									  SameResultWhenAppendedCallback sameResultWhenAppended):
	instance(instance), name(name), transformCallback(transform), inDomainCallback(domain), sameResultWhenAppendedCallback(sameResultWhenAppended) {}

	virtual const char* Name() const
	{
		return name;
	}

	virtual rocksdb::Slice Transform(const rocksdb::Slice& src) const
	{
		return transformCallback(instance, src);
	}

	virtual bool InDomain(const rocksdb::Slice& src) const
	{
		return inDomainCallback(instance, src);
	}

	virtual bool SameResultWhenAppended(const rocksdb::Slice& prefix) const
	{
		return sameResultWhenAppendedCallback(instance, prefix);
	}

};

rocksdb::SliceTransform* RocksDBCallbackSliceTransform(void* instance,
													   const char* name,
													   TransformCallback transform,
													   InDomainCallback domain,
													   SameResultWhenAppendedCallback sameResultWhenAppended)
{
	return new RocksDBCallbackSliceTransformImpl(instance, name, transform, domain, sameResultWhenAppended);
}

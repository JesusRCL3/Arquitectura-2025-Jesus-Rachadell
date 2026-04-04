#ifndef CACHE_H
#define CACHE_H

#include <vector>
#include <cstdint>

struct CacheEntry{
    uint32_t tag = 0;
    int activationTime = 0;
    bool dirtybit = false;
    bool valid = false;
};

struct MissResult{
    int penalty;
    CacheEntry& line;
};

class Cache{
private:
    std::vector<std::vector<CacheEntry>> sets;

    uint32_t numSets;
    uint32_t associativity;
    uint32_t blockSize;

    uint32_t offsetBits;
    uint32_t indexBits;

    int hits = 0;
    int misses = 0;
    int currentTime = 0;
    
public:
    Cache(uint32_t cacheSize, uint32_t assoc, uint32_t bSize);

    int access(uint32_t pfn, char operation);

    MissResult handleMiss(uint32_t index, uint32_t tag);

    double getHitRate();
};

#endif
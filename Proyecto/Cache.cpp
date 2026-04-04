#include "Cache.h"

#include <cmath>
#include <limits>

Cache::Cache(uint32_t cacheSize, uint32_t assoc, uint32_t bSize){
        associativity = assoc;
        blockSize = bSize;
        numSets = cacheSize / (blockSize * associativity);
        offsetBits = log2(blockSize);
        indexBits = log2(numSets);

        sets.resize(numSets, std::vector<CacheEntry>(associativity));
}

int Cache::access(uint32_t pfn, char operation){
        currentTime++;
        
        uint32_t addressWithoutOffset = pfn >> offsetBits;

        uint32_t index = addressWithoutOffset & (numSets - 1);
        uint32_t tag = addressWithoutOffset >> indexBits;

        for (auto& line : sets[index]){
            if (line.valid && line.tag == tag){
                line.activationTime = currentTime;
                hits++;

                if (operation == 'W'){
                    line.dirtybit = true;
                }
                return 1;
            }
        }

        misses++;
        MissResult result = handleMiss(index, tag);

        if (operation == 'W'){
            result.line.dirtybit = true;
        }

        return result.penalty;
}

MissResult Cache::handleMiss(uint32_t index, uint32_t tag){
        int penalty = 100;
        int oldestTime = std::numeric_limits<int>::max();
        int lruWay = 0;

        std::vector<CacheEntry>& currentset = sets[index];

        // Si esta uno vacio, lo usa y se devuelve
        for (int i=0; i < associativity; i++){
            if (!currentset[i].valid){
                currentset[i].valid = true;
                currentset[i].tag = tag;
                currentset[i].activationTime = currentTime;
                return{penalty, currentset[i]};
            }

            if (currentset[i].activationTime < oldestTime){
                oldestTime = currentset[i].activationTime;
                lruWay = i;
            }
        }

        CacheEntry& choosed = sets[index][lruWay];

        if (choosed.valid && choosed.dirtybit){
            penalty += 100;
        }

        choosed.tag = tag;
        choosed.valid = true;
        choosed.dirtybit = false;
        choosed.activationTime = currentTime;

        return {penalty, choosed};
}

double Cache::getHitRate(){
        return (hits + misses == 0) ? 0 : (double)hits/(hits+misses);
}

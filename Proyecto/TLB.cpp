#include "TLB.h"
#include <limits>

TLB::TLB(uint32_t size) : nEntries(size), entries(size) {}

uint32_t TLB::lookup(uint32_t vpn){
        currentTime++;

        for(auto& entry : entries){
            if (entry.valid && entry.vpn == vpn){
                entry.activationTime = currentTime;
                hits++;
                return entry.pfn;
            }
        }

        misses++;
        return -1;
}

void TLB::insert(uint32_t vpn, uint32_t pfn){
        int lruIndex = 0;
        int oldestTime = std::numeric_limits<int>::max();

        for (int i=0; i < nEntries; i++){
            if (!entries[i].valid){
                entries[i].vpn = vpn;
                entries[i].pfn = pfn;
                entries[i].valid = true;
                entries[i].activationTime = currentTime;
                return;
            }

            if(entries[i].activationTime < oldestTime){
                oldestTime = entries[i].activationTime;
                lruIndex = i;
            }
        }

        entries[lruIndex].vpn = vpn;
        entries[lruIndex].pfn = pfn;
        entries[lruIndex].activationTime = currentTime;
}

double TLB::hitRate() const{
        return (hits + misses == 0) ? 0 : (double)hits/(hits + misses);
}
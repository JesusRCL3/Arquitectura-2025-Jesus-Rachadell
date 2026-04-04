#ifndef TLB_H
#define TLB_H

#include <vector>
#include <cstdint>

struct TLBEntry{
    uint32_t vpn;
    uint32_t pfn;
    bool valid = false;
    int activationTime;
};

class TLB{
private:
    std::vector<TLBEntry> entries;
    uint32_t nEntries;
    uint32_t hits = 0;
    uint32_t misses = 0;
    int currentTime = 0;

public: 
    TLB(uint32_t size);

    // Revisa si existe una traducción guardada
    uint32_t lookup(uint32_t vpn);

    // En caso de TLBmiss, se busca en tabla de paginas y se intercambia con esta funcion
    void insert(uint32_t vpn, uint32_t pfn);

    // Numero de hits/misses
    double hitRate() const;
};

#endif
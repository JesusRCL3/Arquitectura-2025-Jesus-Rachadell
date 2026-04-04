#ifndef PAGETABLE_H
#define PAGETABLE_H

#include <vector>
#include <cstdint>

struct PageEntry{
    uint32_t pfn;
    bool inRam = false;
    bool valid = false;
};

class PageTable{
private:
    std::vector<PageEntry> table;
    int pageFaults = 0;
    bool laFault = false; //LastAccessWasFault?

public:
    PageTable(uint32_t size);

    uint32_t getPfn(uint32_t vpn);

    void handleFault(uint32_t vpn);

    int getPageFault() const;

    bool getlaFault();
};

#endif
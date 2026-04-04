#include "PageTable.h"

PageTable::PageTable(uint32_t size){
        table.resize(size);
        for (uint32_t i = 0; i < size; i++) {
            table[i].pfn = i;
            table[i].valid = true;  
            table[i].inRam = false; 
        }
}

uint32_t PageTable::getPfn(uint32_t vpn){
        if (vpn >= table.size() || !table[vpn].valid){
            laFault = false;    
            return -1; //Segment FAULT
        }

        if (!table[vpn].inRam){
            pageFaults++;
            handleFault(vpn);
            laFault = true;
            return table[vpn].pfn;
        }

        laFault = false;
        return table[vpn].pfn;
}

void PageTable::handleFault(uint32_t vpn){
        // Se asume que lo encontró en el disco
        table[vpn].inRam = true;
}

int PageTable::getPageFault() const {return pageFaults;}

bool PageTable::getlaFault(){
        return laFault;
}
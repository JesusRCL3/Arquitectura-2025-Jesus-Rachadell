#include <iostream>
#include <vector>
#include <fstream>
#include <sstream>
#include <string>
#include <iomanip>
#include <cstdint>
#include <cmath>
#include <limits>
#include "TLB.h"
#include "Pagetable.h"
#include "Cache.h"

void runSim(std::string filename){    
    std::ifstream file(filename);
    if (!file.is_open()){
        std::cerr << "Error: El archivo no se puedo abrir\n";
        return;
    }

    std::string line;
    uint32_t tlbSize, pageSize, cacheSize, assoc, blockSize;

    while(std::getline(file, line)){
        if (line.empty() || line[0] == '#') continue;

        if (line.find("TLB_SIZE:") != std::string::npos) 
            std::stringstream(line.substr(line.find(":") + 1)) >> tlbSize;
        else if (line.find("PAGE_SIZE:") != std::string::npos)
            std::stringstream(line.substr(line.find(":") + 1)) >> pageSize;
        else if (line.find("CACHE_SIZE:") != std::string::npos)
            std::stringstream(line.substr(line.find(":") + 1)) >> cacheSize;
        else if (line.find("CACHE_ASSOC:") != std::string::npos)
            std::stringstream(line.substr(line.find(":") + 1)) >> assoc;
        else if (line.find("CACHE_BLOCK:") != std::string::npos)
            std::stringstream(line.substr(line.find(":") + 1)) >> blockSize;

        if (line[0]=='R' || line[0]=='W') break;
    }

    TLB tlb(tlbSize);
    uint32_t numPages = pow(2, 32 - std::log2(pageSize)); 
    PageTable PageTable(numPages);
    Cache Cache(cacheSize, assoc, blockSize);
    uint32_t totalCycles = 0;

    do{
        if (line.empty()||line[0]=='#') continue;

        std::stringstream ss(line);
        char op;
        std::string addrstr;
        uint32_t virtualAddr;

        ss >> op >> addrstr;

        std::stringstream converter;
        converter << std::hex << addrstr;
        converter >> virtualAddr;

        uint32_t offsetBits = std::log2(pageSize);
        uint32_t vpn = virtualAddr >> offsetBits;


        int pfn = tlb.lookup(vpn);
        
        if(pfn != -1){
            totalCycles += 1;
        } else{
            pfn = PageTable.getPfn(vpn);

            if(pfn == -1){
                exit(1);
            }
            if (PageTable.getlaFault()){
                totalCycles += 1000000; //Estaba en disco
            } else{
                totalCycles += 100;
            }

            tlb.insert(vpn, pfn);
        }

        uint32_t offset = virtualAddr & (pageSize - 1);
        uint32_t physicalAddr = (pfn << offsetBits) | offset; 
        totalCycles += Cache.access(physicalAddr, op);


        std::cout << "Procesando " << op << " en " << std::hex << virtualAddr << '\n';
    } while(std::getline(file, line));
    std::cout << "Tasa de aciertos de la TLB: " << tlb.hitRate() << '\n';
    std::cout << "Tasa de aciertos de la cache: " << Cache.getHitRate() << '\n';
    std::cout << "Ciclos Totales: " << std::dec << totalCycles << std::endl;
}

int main(){
    std::string filename;
    std::cout << "Ingrese archivo a leer: ";
    std::cin >> filename;
    runSim(filename);

    return 0;
}
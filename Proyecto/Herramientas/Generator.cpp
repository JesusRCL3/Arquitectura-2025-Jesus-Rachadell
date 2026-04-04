#include <iostream>
#include <fstream>
#include <random>
#include <string>
#include <iomanip>

void generateTraces(int numLines, double randomness, std::string filename) {
    std::ofstream outFile(filename);
    uint32_t tlbSize, pageSize, cacheSize, assoc, blockSize;

    std::cout << "Ingrese el tamaño de la TLB: "; std::cin >> tlbSize;
    std::cout << "Ingrese el tamaño de la Tabla de Paginas: "; std::cin >> pageSize;
    std::cout << "Ingrese el tamaño de la Cache: "; std::cin >> cacheSize; 
    std::cout << "Ingrese la asociatividad deseada: "; std::cin >> assoc;
    std::cout << "Ingrese el tamaño de los bloques: "; std::cin >> blockSize;
    
    //Se escribe en la cabecera del nuevo archivo
    outFile << "TLB_SIZE: " << tlbSize << "\n";
    outFile << "PAGE_SIZE: " << pageSize << "\n";
    outFile << "CACHE_SIZE: " << cacheSize << "\n";
    outFile << "CACHE_ASSOC: " << assoc << "\n";
    outFile << "CACHE_BLOCK: " << blockSize << "\n\n";

    unsigned int seed;
    std::cout << "Ingrese una semilla: (solo numeros) \n";
    std::cin >> seed;

    std::mt19937 gen(seed); // Semilla fija para consistencia
    std::uniform_int_distribution<uint32_t> dist(0, 0xFFFFFFFF);
    
    uint32_t lastAddr = 0x400000;

    for(int i = 0; i < numLines; i++) {
        char op = (gen() % 10 < 2) ? 'W' : 'R'; // %20 W %80 R
        uint32_t addr;

        if ((gen() % 100) < (randomness * 100)) {
            addr = dist(gen) & ~0x3; // de 4 en 4
        } else {
            addr = lastAddr + ((gen() % 16) * 4);
        }

        outFile << op << " 0x" << std::hex << std::uppercase << std::setw(8) << std::setfill('0') << addr << '\n';
        lastAddr = addr;
    }
}

int main(){
    int numLines;
    double random;
    std::string filename;

    std::cout << "Bienvenido al constructor de Datos, por favor elija lo siguiente\n";

    std::cout << "Ingrese el numero de Instrucciones: ";
    std::cin >> numLines;

    std::cout << "Ingrese el nombre del archivo: ";
    std::cin.ignore();
    std::getline(std::cin, filename);

    std::cout <<"Los datos se guardaran como: \""<<filename<<"\"\n";
    
    std::cout << "Ingrese factor de randomizacion: (0.0-1.0)\n";
    std::cout << "ADVERTENCIA: valores altos podrian generar muchisimos fallos, se recomienda 0.2 o 0.1\n";
    std::cin >> random;

    generateTraces(numLines, random, filename);
    return 0;
}
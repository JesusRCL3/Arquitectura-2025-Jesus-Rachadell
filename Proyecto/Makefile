
TARGET = Sim
CXX = g++
CXXFLAGS = -std=c++11 -Wall
OBJS = Sim.o TLB.o PageTable.o Cache.o

$(TARGET): $(OBJS)
	$(CXX) $(CXXFLAGS) -o $(TARGET) $(OBJS)

Sim.o: Sim.cpp TLB.h Pagetable.h Cache.h
	$(CXX) $(CXXFLAGS) -c Sim.cpp

TLB.o: TLB.cpp TLB.h
	$(CXX) $(CXXFLAGS) -c TLB.cpp

PageTable.o: Pagetable.cpp Pagetable.h
	$(CXX) $(CXXFLAGS) -c Pagetable.cpp

Cache.o: Cache.cpp Cache.h
	$(CXX) $(CXXFLAGS) -c Cache.cpp

clean:
	rm -f $(OBJS) $(TARGET)

run: $(TARGET)
	./$(TARGET)
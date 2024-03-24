// Empty testbench

#include <verilated.h>
#include <verilated_vcd_c.h>

#include "Vforwarding_unit.h" //Change module name here

using namespace std;

#define MAX_TIME 10 //Set max time here in ns 
#define PERIOD 10  //Set simulation period here in ps
static Vforwarding_unit* ptop = new Vforwarding_unit;  //Change module name here

vluint64_t sim_time = 0;
static VerilatedVcdC* tfp = new VerilatedVcdC;

static void tick(int count)
{
  for (;count > 0; --count)
  {
    ptop->eval();
    sim_time++;
    tfp->dump(sim_time);
  }
}

static void run(uint64_t limit)
{
  uint64_t count = 0;
  while(count < limit)
  {
    tick(PERIOD);         //Modify as per module
    ++count;              //
  }
}


int main(int argc, char** argv, char** env) {
  Verilated::commandArgs(argc, argv);
  Verilated::traceEverOn(true);

  ptop->trace(tfp, 99);
  tfp->open("dump.vcd");

  run(MAX_TIME*1000/PERIOD);

  tfp->close();
  ptop->final();
  delete tfp;
  delete ptop;
  return 0;
}
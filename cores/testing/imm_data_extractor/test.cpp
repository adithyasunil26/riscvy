#include <verilated.h>
#include <verilated_vcd_c.h>

#include "Vimm_data_extractor.h" //Change module name here

using namespace std;

#define MAX_TIME 0.25 //Set max time here in ns 
#define PERIOD 10  //Set simulation period here in ps
static Vimm_data_extractor* ptop = new Vimm_data_extractor;  //Change module name here

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
    ptop->inst = count*100000;   //Modify as per module
    tick(PERIOD);                 //
    ++count;
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
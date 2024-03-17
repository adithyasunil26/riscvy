#include <verilated.h>
#include <verilated_vcd_c.h>

#include "Vprogram_counter.h" //Change module name here

using namespace std;

#define MAX_TIME 10 //Set max time here in ns 
#define PERIOD 10  //Set simulation period here in ps
static Vprogram_counter* ptop = new Vprogram_counter;  //Change module name here

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
    ptop->PC_in = count;  //Modify as per module
    if (count%2==0)       //
      ptop->reset = 0;    //
    else                  //
      ptop->reset = 1;    //
    if (count%6==0)       //
      ptop->stall = 1;    //
    else                  //
      ptop->stall = 0;    //
    ptop->clk = 0;        //
    tick(PERIOD/2);       //
    ptop->clk = 1;        //
    tick(PERIOD/2);       //
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
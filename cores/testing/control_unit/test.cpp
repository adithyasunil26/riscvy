#include <verilated.h>
#include <verilated_vcd_c.h>

#include "Vcontrol_unit.h" //Change module name here

using namespace std;

#define MAX_TIME 10 //Set max time here in ns 
#define PERIOD 10  //Set simulation period here in ps
static Vcontrol_unit* ptop = new Vcontrol_unit;  //Change module name here

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
  int k = 0;                 //
  int m[5]={3,35,51,99,19};  //
  int l = 0;                 //
  while(count < limit)
  {
    ptop->stall = l;      //Modify as per module
    ptop->opcode = m[k];  //
    tick(PERIOD);         //
    ++k;                  //
    ++l;                  //
    ++count;              //
    if (k==5)             //
      k=0;                //
    if (l==1)             //
      l=0;                //
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
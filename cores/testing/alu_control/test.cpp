#include <verilated.h>
#include <verilated_vcd_c.h>

#include "Valu_control.h" //Change module name here

using namespace std;

#define MAX_TIME 10 //Set max time here in ns 
#define PERIOD 10  //Set simulation period here in ps
static Valu_control* ptop = new Valu_control;  //Change module name here

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
  int k = 0;              //
  int l = 0;              //
  int m[4]={0,6,7,8};     //
  while(count < limit)
  {
    ptop->aluop = k;      //Modify as per module
    ptop->funct = m[l];   //
    tick(PERIOD);         //
    ++k;                  //
    ++l;                  //
    ++count;              //
    if (k==3)             //
      k=0;                //
    if (l==4)             //
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
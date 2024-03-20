#include <verilated.h>
#include <verilated_vcd_c.h>

#include "Vreg_fetch_decode.h" //Change module name here

using namespace std;

#define MAX_TIME 10 //Set max time here in ns 
#define PERIOD 10  //Set simulation period here in ps
static Vreg_fetch_decode* ptop = new Vreg_fetch_decode;  //Change module name here

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
  ptop->reset = 0;
  ptop->flush = 0;
  while(count < limit)
  {
    ptop->inst_in = count;
    ptop->a_in = count+1;
    if (count%3==0){      //Modify as per module
      ptop->write = 1;    //
    } else {              //
      ptop->write = 0;    //
    }                     //
    if (count%10==0)       //
      ptop->flush = 1;    //
    else                  //
      ptop->flush = 0;    //
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
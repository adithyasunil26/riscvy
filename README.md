# riscvy

[![Tests](https://github.com/adithyasunil26/riscvy/actions/workflows/tests.yml/badge.svg)](https://github.com/adithyasunil26/riscvy/actions/workflows/tests.yml)

A simple 5 stage RISC-V ISA based pipelined processor with forwarding, stalling, and flushing functionality.

## Getting Started

This repository is FuseSoC compatible and, in fact, it is recommended to use FuseSoC as the core files have defined all the includes making it easier to simulate different modules without keeping track of sub-modules.

### Installing FuseSoC
FuseSoC works on Linux, Windows and macOS. It is written in Python and can be installed like any other Python package through "pip". Please refer to the full list of system requirements and installation instructions in the Installation section in the [User Guide](https://fusesoc.readthedocs.io/en/stable/user/installation.html).

### Installing Verilator
Verilator work on Linux, Windows and MacOS. It can be installed through `apt-get` on linux or `brew` on OSX. Please refer to the detailed installation instructions in the [documentation](https://verilator.org/guide/latest/install.html).

### Quick Start for FuseSoC
To check if FuseSoC is working, and to get an initial feeling for how FuseSoC
works, you can try to simulate a simple hardware design from our core libray.

First, create and enter an empty workspace

    mkdir workspace
    cd workspace

Install the FuseSoc base library into the workspace

    fusesoc library add fusesoc-cores https://github.com/fusesoc/fusesoc-cores

Get a list of cores found in the workspace

    fusesoc core list

If you have any of the supported simulators installed, you can try to
run a simulation on one of the cores as well. For example,
`fusesoc run --target=sim i2c` will run a regression test on the core
i2c with Icarus Verilog. If you want to try another simulator instead,
add e.g. `--tool=modelsim` or `--tool=xcelium` between `run` and `i2c`.

`fusesoc --help` will give you more information on commands and switches.

## Running riscvy

### Adding riscvy core library to FuseSoC

```
fusesoc library add riscvy cores/
fusesoc core list
```

### Running riscvy cores
The cores currently have 2 targets which are verilator lint and testbench. They can be used as follows.

For linting

    fusesoc run --target lint <core_name>

For verilator testbench

    fusesoc run --target verilator_tb <core_name>

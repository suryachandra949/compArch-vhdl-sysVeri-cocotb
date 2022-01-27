# This file is public domain, it can be freely copied without restrictions.
# SPDX-License-Identifier: CC0-1.0
# Simple tests for an adder module
import cocotb
import numpy as np
from cocotb.triggers import Timer
from alu_model import alu_model
import random


@cocotb.test()
async def adder_basic_test(dut):
    """Test for 5 + 10"""

    A = 5
    B = 10
    X = 1
    OPCODE = 5
    dut.A.value = A
    dut.B.value = B
    dut.X.value = X
    dut.OPCODE.value = OPCODE

    await Timer(2, units='ns')
    print(dut.ALU_OUT.value)
    print(alu_model(A,B,X,OPCODE))
    assert dut.ALU_OUT.value == alu_model(A, B,X,OPCODE), f"Adder result is incorrect"


@cocotb.test()
async def adder_randomised_test(dut):
    """Test for adding 2 random numbers multiple times"""

    for i in range(10):

        A = random.randint(0, 15)
        B = random.randint(0, 15)
        X = 1
        OPCODE = 5
        dut.A.value = A
        dut.B.value = B
        dut.X.value = X
        dut.OPCODE.value = OPCODE

        await Timer(2, units='ns')

        assert dut.ALU_OUT.value == alu_model(A, B,X,OPCODE), "Randomised test failed with"

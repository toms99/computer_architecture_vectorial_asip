import unittest
import compiler


class opCodes_testing(unittest.TestCase):
    op_code_dict = compiler.op_code_dict

    def test_JMP(self):
        self.assertEqual(self.op_code_dict["JMP"], "1010")

    def test_JE(self):
        self.assertEqual(self.op_code_dict["JE"], "1000")

    def test_JNE(self):
        self.assertEqual(self.op_code_dict["JNE"], "1001")

    def test_INC(self):
        self.assertEqual(self.op_code_dict["INC"], "0111")

    def test_LOSC(self):
        self.assertEqual(self.op_code_dict["LOSC"], "0000")

    def test_LMEM(self):
        self.assertEqual(self.op_code_dict["LMEM"], "1111")

    def test_XOR(self):
        self.assertEqual(self.op_code_dict["XOR"], "0001")

    def test_ECAE(self):
        self.assertEqual(self.op_code_dict["ECAE"], "0010")

    def test_DCAE(self):
        self.assertEqual(self.op_code_dict["DCAE"], "0011")

    def test_MUL(self):
        self.assertEqual(self.op_code_dict["MUL"], "0100")

    def test_RSHF(self):
        self.assertEqual(self.op_code_dict["RSHF"], "0101")

    def test_LSHF(self):
        self.assertEqual(self.op_code_dict["LSHF"], "0110")

    def test_LOPIX(self):
        self.assertEqual(self.op_code_dict["LOPIX"], "1101")

    def test_SVPIX(self):
        self.assertEqual(self.op_code_dict["SVPIX"], "1100")


class reg_codes_testing(unittest.TestCase):
    register_dict = compiler.register_dict

    def test_R0(self):
        self.assertEqual(self.register_dict["R0"], "0000")

    def test_R1(self):
        self.assertEqual(self.register_dict["R1"], "0001")

    def test_R2(self):
        self.assertEqual(self.register_dict["R2"], "0010")

    def test_R3(self):
        self.assertEqual(self.register_dict["R3"], "0011")

    def test_R4(self):
        self.assertEqual(self.register_dict["R4"], "0100")

    def test_R5(self):
        self.assertEqual(self.register_dict["R5"], "0101")

    def test_R6(self):
        self.assertEqual(self.register_dict["R6"], "0110")

    def test_R7(self):
        self.assertEqual(self.register_dict["R7"], "0111")

    def test_R8(self):
        self.assertEqual(self.register_dict["R8"], "1000")

    def test_R9(self):
        self.assertEqual(self.register_dict["R9"], "1001")

    def test_R10(self):
        self.assertEqual(self.register_dict["R10"], "1010")

    def test_R11(self):
        self.assertEqual(self.register_dict["R11"], "1011")

    def test_R12(self):
        self.assertEqual(self.register_dict["R12"], "1100")

    def test_R13(self):
        self.assertEqual(self.register_dict["R13"], "1101")

    def test_R14(self):
        self.assertEqual(self.register_dict["R14"], "1110")

    def test_R15(self):
        self.assertEqual(self.register_dict["R15"], "1111")


class one_operand_testing(unittest.TestCase):
    def test_INC_decode(self):
        instruction = [["INC"]]
        result = compiler.compile_instructions(instruction)
        self.assertEqual(result[1], "0111111000000000")

    def test_STALL_decode(self):
        instruction = [["STALL"]]
        result = compiler.compile_instructions(instruction)
        self.assertEqual(result[1], "0000100000000000")


class LOSC_testing(unittest.TestCase):
    def test_LOSC_decode_hex_right(self):
        instruction = [["LOSC", "R4", "0XB"]]
        result = compiler.compile_instructions(instruction)
        self.assertEqual(result[1], "0000010000001011")

    def test_LOSC_decode_hex_overflow(self):
        instruction = [["LOSC", "R4", "0XFF1"]]
        with self.assertRaises(Exception) as context:
            compiler.compile_instructions(instruction)
            self.assertEqual(
                str(context.exception),
                f"Error: Valor hexadecimal fuera de rango (0-FF): 0XFF1",
            )

    def test_LOSC_decode_decimal_right(self):
        instruction = [["LOSC", "R4", "#125"]]
        result = compiler.compile_instructions(instruction)
        self.assertEqual(result[1], "0000010001111101")

    def test_LOSC_decode_decimal_overflow(self):
        instruction = [["LOSC", "R4", "#1000"]]
        with self.assertRaises(Exception) as context:
            compiler.compile_instructions(instruction)
            self.assertEqual(
                str(context.exception),
                f"Error: Valor hexadecimal fuera de rango (0-FF): #1000",
            )

    def test_LOSC_decode_decimal_negative(self):
        instruction = [["LOSC", "R4", "#-1000"]]
        with self.assertRaises(Exception) as context:
            compiler.compile_instructions(instruction)
            self.assertEqual(
                str(context.exception),
                f"Error: Valor hexadecimal fuera de rango (0-FF): #1000",
            )


if __name__ == "__main__":
    unittest.main()

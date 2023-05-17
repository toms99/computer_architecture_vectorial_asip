import argparse
import os

# Globals


register_dict = {
    # Uso general
    "R0": "0000",  # Vectorial
    "R1": "0001",  # Vectorial
    "R2": "0010",  # Vectorial
    "R3": "0011",  # Vectorial
    "R4": "0100",  # Escalar
    "R5": "0101",  # Escalar
    "R6": "0110",  # Escalar
    "R7": "0111",  # Escalar
    # Uso específico
    "R8": "1000",
    "R9": "1001",
    "R10": "1010",
    "R11": "1011",
    "R12": "1100",
    "R13": "1101",  # Ultimo byte
    "R14": "1110",  # Contador de pixeles
    "R15": "1111",  # PC
}

op_code_dict = {
    "JMP": "1010",
    "JE": "1000",
    "JNE": "1001",
    "INC": "0111",
    "LOPIX": "1101",
    "SVPIX": "1100",
    "LOSC": "0000",
    "LMEM": "1111",
    "XOR": "0001",
    "ECAE": "0010",
    "DCAE": "0011",
    "MUL": "0100",
    "RSHF": "0101",
    "LSHF": "0110",
}

# Branch que almacenará
branchs_dict = {}

# listas de instrucciones que esperan por cantidad de argumentos
one_operand_instructions = ["JMP", "JE", "JNE", "INC", "LOPIX", "SVPIX"]
two_operand_instructions = [
    "LOSC",
    "LMEM",
    "XOR",
    "ECAE",
    "DCAE",
    "MUL",
    "RSHF",
    "LSHF",
]


# Funciones


# Chequea sí ingresó la ruta en los argumentos a la hora de ejecutarlo
def checks_if_path_is_None(path):
    if path is None:
        raise Exception(
            "Debe ingresar el path del código a compilar. Se recomienda usar -f <path> al compilar"
        )


# Chequea si la ruta existe
def checks_if_path_exists(path):
    if not os.path.exists(path):
        raise Exception("Debe ingresar un path existente")


# Obtiene las lineas del archivo sin los saltos de linea
def get_file_lines(path):
    with open(path, "r") as file:
        lineas = [line.rstrip() for line in file.readlines()]
        return lineas


# Elimina los comentarios de una unica linea
def remove_comments_single_line(string):
    result = string.split("$")
    return result[0]


# Remueve todos los comentarios de todas las lineas
def remove_all_comments(lines):
    result = []
    for line in lines:
        result.append(remove_comments_single_line(line).upper())
    return result


# Convierte el string de una instrucción en una lista con los elementos de la instrucción
# SUM Ri Rj -> [SUM, ]
def make_lists_from_instructions(lines):
    result = []
    for line in lines:
        result.append(line.split(" "))
    return result


# Elimina los espacios vacios de una sola linea
def clean_empty_strings_single(line):
    return [result for result in line if bool(result)]


# Elimina los espacios vacios de todas las lineas
def clean_empty_strings(lines):
    result = []
    for line in lines:
        result.append(clean_empty_strings_single(line))
    return result


# Funciones agrupadoras


def checks_input_file(path_source_file):
    # Chequea si ingresó la ruta en los argumentos a la hora de ejecutarlo
    checks_if_path_is_None(path_source_file)

    # Chequea si la ruta existe
    checks_if_path_exists(path_source_file)


# Formatea el archivo a listas con los elementos de la instrucción
# Retorna la matriz de instrucciones.
def reformat_input_file(path_source_file):
    # Obtiene las lineas del archivo sin los saltos de linea
    lines_source_file = get_file_lines(path_source_file)

    # Elimina todos los comentarios definidos por el caracter $
    lines_source_file_no_comments = remove_all_comments(lines_source_file)
    del lines_source_file

    # Separar cada linea en una lista con cada elemento de la instrucción
    instruction_matrix = make_lists_from_instructions(lines_source_file_no_comments)
    del lines_source_file_no_comments

    instruction_matrix = clean_empty_strings(instruction_matrix)

    return instruction_matrix


def calc_binary_from_counter(compiled_instructions_counter):
    # Multiplicar el contador por 4
    result_decimal = compiled_instructions_counter * 4

    # Convertir el resultado a formato binario de 8 bits
    result_binario = bin(result_decimal & 0xFF)[2:].zfill(8)

    return result_binario


def process_branch_instruction(instruction, compiled_instructions_counter):
    global branchs_dict
    binary_address = calc_binary_from_counter(compiled_instructions_counter)
    if instruction not in branchs_dict:
        branchs_dict[instruction] = binary_address
    else:
        raise Exception(f"La branch {instruction} ya fue definida anteriormente.")


def compile_instructions(instruction_matrix):
    compiled_instructios_result = []
    compiled_instructions_counter = 0
    line_counter = 1
    for instruction_list in instruction_matrix:
        instruction_length = len(instruction_list)
        # Comprueba si la linea es vacia.
        # En ese caso se ignora la linea
        if instruction_length == 0:
            line_counter += 1
            pass
        # Comprueba la definición de branches.
        elif instruction_length == 1:
            if ":" in instruction_list[0]:
                instruction = instruction_list[0].replace(":", "")
                process_branch_instruction(
                    instruction, compiled_instructions_counter + 1
                )
                line_counter += 1
            else:
                raise Exception(
                    f"Branch definida de manera incorrecta en la linea {line_counter}: {instruction_list[0]}. Posible : faltante."
                )

        # Comprueba instrucciones de un operando
        elif instruction_length == 2:
            line_counter += 1
            compiled_instructions_counter += 1
            print("instrucciones de un operando")

        # Comprueba instrucciones de dos operandos
        elif instruction_length == 3:
            line_counter += 1
            compiled_instructions_counter += 1
            print("instrucciones de dos operandos")

        else:
            raise Exception(f"Instrucción inválida en la linea {line_counter}")


# main --------------------------------------------------------------------------------------------------------------------------------------


def main():
    # Recibe el path del codigo fuente
    # Debe compilarse como py compiler.py -f <path>
    parser = argparse.ArgumentParser()
    parser.add_argument("-f", "--file", type=str, help="Ruta al código fuente")
    args = parser.parse_args()
    path_source_file = args.file

    # Chequea el archivo de entrada.

    checks_input_file(path_source_file)

    # Formate el archivo de entrada a una estructura de listas

    instruction_matrix = reformat_input_file(path_source_file)

    # Compila las instrucciones
    compile_instructions(instruction_matrix)

    print(branchs_dict)


# Verifica si el archivo se está ejecutando como el programa principal
if __name__ == "__main__":
    main()

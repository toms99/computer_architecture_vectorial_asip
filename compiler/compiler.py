import argparse
import os

# Globals

# Recibe el path del codigo fuente
# Debe compilarse como py compiler.py -f <path>
parser = argparse.ArgumentParser()
parser.add_argument("-f", "--file", type=str, help="Ruta al código fuente")
args = parser.parse_args()
path_source_file = args.file


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
    "JE": "1000",
    "JNE": "1001",
    "INC": "0111",
    "LOPIX": "1101",
    "SUPIX": "1100",
    "LOSC": "0000",
    "LMEM": "1111",
    "XOR": "0001",
    "ECAE": "0010",
    "DCAE": "0011",
    "MULC": "0100",
    "RSHF": "0101",
    "LSHF": "0110",
}

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
    print(result)
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


# main --------------------------------------------------------------------------------------------------------------------------------------

# Chequea si ingresó la ruta en los argumentos a la hora de ejecutarlo
checks_if_path_is_None(path_source_file)

# Chequea si la ruta existe
checks_if_path_exists(path_source_file)

# Obtiene las lineas del archivo sin los saltos de linea
lines_source_file = get_file_lines(path_source_file)

# Elimina todos los comentarios definidos por el caracter $
lines_source_file_no_comments = remove_all_comments(lines_source_file)
del lines_source_file

# Separar cada linea en una lista con cada elemento de la instrucción
instruction_matrix = make_lists_from_instructions(lines_source_file_no_comments)
del lines_source_file_no_comments

instruction_matrix = clean_empty_strings(instruction_matrix)

print(instruction_matrix)

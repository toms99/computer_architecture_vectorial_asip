from PIL import Image
import pdb
import os

def convertir_a_imagen(datos, ancho, alto, key):
    # Obtener el nombre base del archivo sin la extensión
    nombre_base = os.path.splitext(datos)[0]

    # Crear una nueva imagen en blanco
    imagen = Image.new("L", (ancho, alto))

    # Leer los datos de píxeles desde el archivo
    with open(datos, 'r') as archivo:
        lineas = archivo.readlines()

    # Verificar que el número de líneas coincida con el tamaño de la imagen
    if len(lineas) != alto*ancho:
        print("El número de líneas no coincide con el tamaño de la imagen.")
        return None

    # Iterar sobre las líneas y establecer los valores de los píxeles en la imagen
    for i, linea in enumerate(lineas):
        # Eliminar caracteres de nueva línea y espacios en blanco
        linea = linea.strip()

        # Verificar que la longitud de la línea coincida con el ancho de la imagen
        if len(linea) != 8:
            print(f"La longitud de la línea {i + 1} no coincide con el ancho de la imagen.")
            return None

        # Convertir la línea a un entero
        valor_pixel = int(linea, 2)
        print(f"El pixel antes de encriptar era: {valor_pixel}")
        print(f"La llave es: {key}")
        #valor_pixel = valor_pixel ^ key
        print(f"El valor del pixel despues es: {valor_pixel}")

        # Aplicar el operador XOR con la clave
        valor_pixel = valor_pixel^ key

        # Establecer el valor del píxel en la imagen
        imagen.putpixel((i % ancho, i // ancho), valor_pixel)

    # Generar el nombre del archivo de imagen usando el nombre base del archivo de datos
    nombre_imagen = f"{nombre_base}.png"

    return imagen, nombre_imagen

# Especificar el nombre del archivo de datos y el tamaño de la imagen
nombre_archivo = "mundoEncriptado.txt"
ancho_imagen = 100
alto_imagen = 100
key = 0x70

# Convertir los datos a una imagen
imagen, nombre_imagen = convertir_a_imagen(nombre_archivo, ancho_imagen, alto_imagen, key)

# Guardar la imagen resultante
if imagen is not None:
    imagen.save(nombre_imagen)
    print("La imagen ha sido creada exitosamente.")

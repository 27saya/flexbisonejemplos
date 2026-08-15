# Ejemplos de Flex y Bison (Capítulo 1: Páginas 23 a 31)

Este repositorio contiene la implementación, análisis detallado y guía de ejecución de los ejemplos **1-1 al 1-5** del libro *"flex & bison"* de John Levine.

---

## 📌 Resumen Conceptual: ¿Qué son Flex y Bison?

* **Flex (Analizador Léxico):** Se encarga de leer el texto carácter por carácter y agrupar secuencias con significado (como números, palabras, operadores o saltos de línea) en unidades llamadas **tokens**.
* **Bison (Analizador Sintáctico):** Recibe los tokens producidos por Flex y verifica que cumplan un conjunto de reglas gramaticales (como la estructura de una operación matemática), calculando los resultados o ejecutando acciones asociadas.

---

## 🔍 Análisis del Comportamiento de Cada Ejemplo

### Ejemplo 1-1: Contador de palabras (`fb1-1.l`)
* **Ubicación:** `ejemplo1-1/fb1-1.l`
* **¿Qué hace?:** Emula de forma simplificada el comando clásico `wc` (word count) de sistemas Unix/Linux.
* **Comportamiento:**
  * Lee texto desde la entrada estándar.
  * Cuando detecta una secuencia de una o más letras (`[a-zA-Z]+`), incrementa el contador de palabras e incrementa el total de caracteres según la longitud de esa palabra.
  * Al encontrar un salto de línea (`\n`), incrementa el contador de líneas y el de caracteres.
  * Cualquier otro carácter individual (espacios, signos de puntuación) suma uno al total de caracteres.
  * Al finalizar la lectura (EOF / Ctrl+D), imprime en pantalla tres columnas con el formato: número de líneas, número de palabras y número de caracteres.

---

### Ejemplo 1-2: Traductor simple de inglés británico a americano (`fb1-2.l`)
* **Ubicación:** `ejemplo1-2/fb1-2.l`
* **¿Qué hace?:** Funciona como un filtro de sustitución de texto básico.
* **Comportamiento:**
  * Lee el flujo de entrada buscando palabras específicas en inglés británico y las imprime traducidas a su variante estadounidense:
    * `colour` $\rightarrow$ `color`
    * `flavour` $\rightarrow$ `flavor`
    * `clever` $\rightarrow$ `smart`
    * `smart` $\rightarrow$ `elegant`
    * `conservative` $\rightarrow$ `liberal`
  * Cualquier otro carácter que no coincida con estas palabras se imprime exactamente igual a como entró (`. { printf("%s", yytext); }`).

---

### Ejemplo 1-3: Reconocedor de tokens para calculadora (`fb1-3.l`)
* **Ubicación:** `ejemplo1-3/fb1-3.l`
* **¿Qué hace?:** Identifica y clasifica los elementos de una expresión aritmética elemental, imprimiendo el nombre del token reconocido.
* **Comportamiento:**
  * Reconoce operadores individuales (`+`, `-`, `*`, `/`, `|`) y emite en una línea separada su nombre (`PLUS`, `MINUS`, `TIMES`, `DIVIDE`, `ABS`).
  * Reconoce cadenas numéricas enteras (`[0-9]+`) e imprime `NUMBER` seguido del número leído.
  * Identifica saltos de línea e imprime `NEWLINE`.
  * Los espacios y tabulaciones son ignorados deliberadamente.
  * Cualquier carácter no reconocido (como una letra u otro símbolo no matemático) genera un mensaje de advertencia: `Mystery character <carácter>`.

---

### Ejemplo 1-4: Escáner con retorno de valores numéricos de tokens (`fb1-4.l`)
* **Ubicación:** `ejemplo1-4/fb1-4.l`
* **¿Qué hace?:** Da el siguiente paso lógico hacia un compilador real: en lugar de imprimir directamente texto informativo, asigna códigos numéricos a cada token y almacena valores semánticos.
* **Comportamiento:**
  * Define un enum en C con valores numéricos para cada tipo de token a partir de 258 (`NUMBER=258`, `ADD=259`, `SUB=260`, etc.).
  * Cada regla retorna el código numérico correspondiente al ser invocada la función `yylex()`.
  * En el caso de los números, convierte el texto a un entero real en C usando `atoi()` y lo guarda en la variable global `yylval` antes de retornar `NUMBER`.
  * El programa principal (`main`) ejecuta un bucle llamando a `yylex()`, mostrando el código del token obtenido y, si es un número, el valor guardado en `yylval`.

---

### Ejemplo 1-5: Calculadora básica combinando Flex y Bison (`fb1-5.l` y `fb1-5.y`)
* **Ubicación:** `ejemplo1-5/`
* **¿Qué hace?:** Es una calculadora aritmética funcional interactiva que evalúa expresiones respetando la precedencia de operadores.
* **Comportamiento:**
  * **Flex (`fb1-5.l`):** Lee la entrada y extrae tokens (`NUMBER`, `ADD`, `SUB`, `MUL`, `DIV`, `ABS`, `EOL`), enviándolos a Bison junto con el valor numérico en `yylval`.
  * **Bison (`fb1-5.y`):** Implementa una gramática libre de contexto estructurada en niveles jerárquicos:
    * `exp` (expresión general: sumas y restas).
    * `factor` (multiplicaciones y divisiones, evaluadas antes que la suma/resta).
    * `term` (números individuales o valor absoluto `ABS term`).
    * `calclist` (permite ingresar y procesar múltiples líneas consecutivas).
  * Al presionar Enter (`EOL`), Bison evalúa el árbol de derivación generado, calcula el resultado aritmético y lo muestra en pantalla precedido por `= `.

---

## 🚀 Guía de Ejecución Paso a Paso (Ubuntu WSL)

Asegúrate de contar con los paquetes necesarios instalados en Ubuntu WSL:
```bash
sudo apt update
sudo apt install -y flex bison gcc
```

---

### 1. Ejecución del Ejemplo 1-1
```bash
cd ejemplo1-1
flex fb1-1.l
gcc lex.yy.c -o fb1-1
./fb1-1
```
* **Prueba de entrada:**
  ```text
  The boy stood on the burning deck
  shelling peanuts by the peck
  ```
  *(Presiona `Ctrl + D` para finalizar la entrada en Linux/WSL).*
* **Salida esperada:**
  ```text
         2      12      63
  ```

---

### 2. Ejecución del Ejemplo 1-2
```bash
cd ejemplo1-2
flex fb1-2.l
gcc lex.yy.c -o fb1-2
./fb1-2
```
* **Prueba de entrada:**
  ```text
  The colour and flavour of a clever conservative is smart
  ```
  *(Presiona `Ctrl + D` para finalizar).*
* **Salida esperada:**
  ```text
  The color and flavor of a smart liberal is elegant
  ```

---

### 3. Ejecución del Ejemplo 1-3
```bash
cd ejemplo1-3
flex fb1-3.l
gcc lex.yy.c -o fb1-3
./fb1-3
```
* **Prueba de entrada:**
  ```text
  12+34
  5 6 / 7q
  ```
  *(Presiona `Ctrl + D` para finalizar).*
* **Salida esperada:**
  ```text
  NUMBER 12
  PLUS
  NUMBER 34
  NEWLINE
  NUMBER 5
  NUMBER 6
  DIVIDE
  NUMBER 7
  Mystery character q
  NEWLINE
  ```

---

### 4. Ejecución del Ejemplo 1-4
```bash
cd ejemplo1-4
flex fb1-4.l
gcc lex.yy.c -o fb1-4
./fb1-4
```
* **Prueba de entrada:**
  ```text
  a / 34 + |45
  ```
  *(Presiona `Ctrl + D` para finalizar).*
* **Salida esperada:**
  ```text
  Mystery character a
  262
  258 = 34
  259
  263
  258 = 45
  264
  ```

---

### 5. Ejecución del Ejemplo 1-5
```bash
cd ejemplo1-5
bison -d fb1-5.y
flex fb1-5.l
gcc -o fb1-5 fb1-5.tab.c lex.yy.c
./fb1-5
```
* **Prueba de entrada:**
  ```text
  2 + 3 * 4
  2 * 3 + 4
  20 / 4 - 2
  20 - 4 / 2
  ```
  *(Presiona `Ctrl + D` para salir).*
* **Salida esperada:**
  ```text
  = 14
  = 10
  = 3
  = 18
  ```

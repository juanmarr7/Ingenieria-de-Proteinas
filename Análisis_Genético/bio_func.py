# -*- coding: utf-8 -*-
"""
Created on Fri Aug 21 11:46:17 2020

@author: Juanma
"""


from bio_seq import bio_seq
from DNA_structures import writeTextFile, readTextFile, read_FASTA

cadena_test="AAAAGGGGCCCTT"
cadena_test2=bio_seq(cadena_test, "DNA", "Test de funcionamiento")
cadena_test2.info_seq()

cadena_test2.random_seq(40, "RNA")
cadena_test2.info_seq()

print(cadena_test2.contar())
print(cadena_test2.transcribir())
print(cadena_test2.reversa())
print("Aqui")
cadena_test2.patron_dna()
print(cadena_test2.gc_content())
print(cadena_test2.gc_content_intervalos())
print(cadena_test2.traducir())
print(cadena_test2.codon_use("L"))

print(cadena_test2.marcos_de_lectura())
print("Nuevo:")
NM_000207="AGCCCTCCAGGACAGGCTGCATCAGAAGAGGCCATCAAGCAGATCACTGTCCTTCTGCCATGGCCCTGTGGATGCGCCTCCTGCCCCTGCTGGCGCTGCTGGCCCTCTGGGGACCTGACCCAGCCGCAGCCTTTGTGAACCAACACCTGTGCGGCTCACACCTGGTGGAAGCTCTCTACCTAGTGTGCGGGGAACGAGGCTTCTTCTACACACCCAAGACCCGCCGGGAGGCAGAGGACCTGCAGGTGGGGCAGGTGGAGCTGGGCGGGGGCCCTGGTGCAGGCAGCCTGCAGCCCTTGGCCCTGGAGGGGTCCCTGCAGAAGCGTGGCATTGTGGAACAATGCTGTACCAGCATCTGCTCCCTCTACCAGCTGGAGAACTACTGCAACTAGACGCAGCCCGCAGGCAGCCCCACACCCGCCGCCTCCTGCACCGAGAGAGATGGAATAAAGCCCTTGAACCAGC"
cadena_1=bio_seq(NM_000207)
print(cadena_1.marcos_de_lectura())
print(cadena_1.proteinas_en_marco(['S', 'P', 'P', 'G', 'Q', 'A', 'A', 'S', 'E', 'E', 'A', 'I', 'K', 'Q', 'I', 'T', 'V', 'L', 'L', 'P', 'W', 'P', 'C', 'G', 'C', 'A', 'S', 'C', 'P', 'C', 'W', 'R', 'C', 'W', 'P', 'S', 'G', 'D', 'L', 'T', 'Q', 'P', 'Q', 'P', 'L', '_', 'T', 'N', 'T', 'C', 'A', 'A', 'H', 'T', 'W', 'W', 'K', 'L', 'S', 'T', '_', 'C', 'A', 'G', 'N', 'E', 'A', 'S', 'S', 'T', 'H', 'P', 'R', 'P', 'A', 'G', 'R', 'Q', 'R', 'T', 'C', 'R', 'W', 'G', 'R', 'W', 'S', 'W', 'A', 'G', 'A', 'L', 'V', 'Q', 'A', 'A', 'C', 'S', 'P', 'W', 'P', 'W', 'R', 'G', 'P', 'C', 'R', 'S', 'V', 'A', 'L', 'W', 'N', 'N', 'A', 'V', 'P', 'A', 'S', 'A', 'P', 'S', 'T', 'S', 'W', 'R', 'T', 'T', 'A', 'T', 'R', 'R', 'S', 'P', 'Q', 'A', 'A', 'P', 'H', 'P', 'P', 'P', 'P', 'A', 'P', 'R', 'E', 'M', 'E', '_', 'S', 'P', '_', 'T', 'S']))
print("AQUI")
print(cadena_1.todas_las_proteinas())


writeTextFile("text.txt", cadena_1.seq) # no entiendo por qué funciona así
for marco in cadena_1.marcos_de_lectura():
    writeTextFile("text.txt", str(marco), "a")
    

fasta=read_FASTA("fasta_samples.txt")
print(fasta)
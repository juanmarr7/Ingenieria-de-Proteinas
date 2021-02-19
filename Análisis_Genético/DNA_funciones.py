# -*- coding: utf-8 -*-
"""
Created on Tue Aug 18 10:36:49 2020

@author: Juanma
"""
from utilidades import colored


base_nuc= ["A", "C", "T", "G"]
base_reverse={"A": "T", "T": "A", "C": "G", "G": "C"}


# Validando secuencias
def validar(seq):
    'Permite asegurarnos de que trabajamos con una cadena de DNA'
    valid_seq=seq.upper()
    for nuc in valid_seq:
        if nuc not in base_nuc:
            print("No es una cadena de DNA")
    return valid_seq
    
# Contando nº de nucleótidos de cada tipo 
def contar(seq):
    dic_nuc={ "A": 0, "C": 0, "T": 0, "G": 0 }
    for nuc in seq:
        dic_nuc[nuc] +=1
    return dic_nuc


def transcribir(seq):
    trans_seq=seq.replace("T","U")
    return trans_seq
    

def reversa(seq):
    return ''.join([base_reverse[nuc] for nuc in seq])

def patron_dna(seq):
    print("5'" +" " + colored(seq) + " 3' ")
    print("  "f" {''.join(['|' for c in range(0,len(seq))])}")
    print("3'" +" " +colored(reversa(seq))+ " 5' ")

def gc_content(seq):
    return round((seq.count("G")+ seq.count("C"))/len(seq)*100)

def gc_content_intervalos(seq, k=20):
    intervalos=[]
    for i in range(0, len(seq) -k+1 , k):
        subset=seq[i:i+k]
        intervalos.append(gc_content(subset))
    return intervalos

from DNA_structures import *

def traducir_dna(seq,init_pos=0):
    return [DNA_Codons[seq[pos:pos+3]] for pos in range(init_pos,len(seq)-2, 3)]

def traducir_rna(seq_rna, init_pos=0):
    return [RNA_Codons[seq[pos:pos+3]] for pos in range(init_pos, len(seq_rna)-2,3)]

from collections import *
def codon_use(seq, aa):
    lista=list()
    for i in range(0, len(seq)-2, 3):
        if DNA_Codons[seq[i:i+3]]==aa:
            lista.append(seq[i:i+3])
            
    frec=dict(Counter(lista))
    total=sum(frec.values())
    for seq in frec:
        frec[seq]=round(frec[seq]/total, 2)     
    return frec

def marcos_de_lectura(seq):
    marcos=[]
    marcos.append(traducir_dna(seq,0))
    
    marcos.append(traducir_dna(seq,1))
   
    marcos.append(traducir_dna(seq,2))
   
    marcos.append(traducir_dna(reversa(seq[::-1]),0))
    
    marcos.append(traducir_dna(reversa(seq[::-1]),1))
    
    marcos.append(traducir_dna(reversa(seq[::-1]),2))
    
    return marcos


def proteinas_en_marco(seq_aa):
    prot=[]
    prots=[]
    for aa in seq_aa:
        if aa=="_":
            if prot:
                for p in prot:
                    prots.append(p)
                prot=[]
        else:
            if aa=="M":
                prot.append(" ")
            for i in range(len(prot)):
                prot[i]+=aa
    return prots
                
def todas_las_proteinas(seq, start=0, end=0, ordered=False):
    if end>start:
        rfs=marcos_de_lectura(seq[start:end])
    else:
        rfs=marcos_de_lectura(seq)
    
    res=[]
    for rf in rfs:
        proteinas=proteinas_en_marco(rf)
        for p in proteinas:
            res.append(p)
    if ordered:
        return sorted(res, key=len, reverse=True)
    return res
    
    
    
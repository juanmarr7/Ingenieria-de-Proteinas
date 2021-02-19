# -*- coding: utf-8 -*-
"""
Created on Fri Aug 21 11:46:10 2020

@author: Juanma
"""
base_nuc= ["A", "C", "T", "G"]
base_reverse={"A": "T", "T": "A", "C": "G", "G": "C"}
from DNA_structures import DNA_Codons, RNA_Codons, NUCLEOTIDE_BASE
from collections import *


class bio_seq():
    'Clase que define un cadena de DNA/RNA como objeto para actuar sobre él'
    def __init__(self, seq="ATCG", seq_type="DNA", label="No label"):
        self.seq=seq.upper()
        self.seq_type=seq_type
        self.label=label
        self.is_valid=self.__validar()
        assert self.is_valid, f'Provided data not seems to be correct self.seq'
        
    def __validar(self):
        'Permite asegurarnos de que trabajamos con una cadena de DNA. Privada'
        return set(NUCLEOTIDE_BASE[self.seq_type]).issuperset(self.seq)
    
    def info_seq(self):
        'Nos devuelve e imprime información completa sobre la candena. No arguments'
        print("La secuencia en estudio es: " + self.seq)
        print( "Tipo de cadena: " + self.seq_type)
        print( "Label: " + self.label)
        print( "Longitud de la cadena: " + str(len(self.seq))+ " nucleótidos")
        
    def seq_label(self):
        'Devuelve la etiqueta de la cadena. No arguments'
        return self.label
    
    def seq_len(self):
        'Devuelve la longitud de la cadena. No arguments'
        return len(self.seq)
    
    def seq_type(self):
        'Devuelve el tipo de la cadena. No arguments'
        return self.seq_type
    
    def seq(self):
        'Devuelve la cadena. No arguments'
        return self.seq()

    def random_seq(self, lenght=50, seq_type="DNA"):
        'Crea una cadena aleatoria tras haber creado la original. Requiere longitud(50) y seqtype (DNA)'
        import random
        seq=''.join([random.choice(NUCLEOTIDE_BASE[seq_type]) for nuc in range (lenght)])
        self.__init__(seq, seq_type, "Cadena generada aleatoriamente")

    def contar(self):
        'Devuelve la frecuencia de nucleótidos. No arguments'
        if self.seq_type=="DNA":
            self.dic_nuc={ "A": 0, "C": 0, "T": 0, "G": 0 }
            for nuc in self.seq:
                self.dic_nuc[nuc] +=1
            return self.dic_nuc
        elif self.seq_type=="RNA":
            self.dic_nuc={ "A": 0, "C": 0, "U": 0, "G": 0 }
            for nuc in self.seq:
                self.dic_nuc[nuc] +=1
            return self.dic_nuc
    
    def transcribir(self):
        'Devuelve el transcrito de la cadena de DNA. Es decir, devuelve el RNA. No arguments'
        if self.seq_type=="DNA":
            return self.seq.replace("T","U")
        return "No es una secuencia de DNA"
    
    
    def reversa(self):
        'Devuelve la cadena complementaria'
        if self.seq_type=="DNA":
            mapping=str.maketrans("ATGC", "TACG")
          
        elif self.seq_type=="RNA":
            mapping=str.maketrans("AUGC", "UACG")
        return self.seq.translate(mapping)
        
    def patron_dna(self):
        'Devuelve la imagen de doble cadena. No requiere print. No arguments'
        if self.seq_type=="DNA":
            print("5'" +" " + self.seq + " 3' ")
            print("  "f" {''.join(['|' for c in range(0,len(self.seq))])}")
            print("3'" +" " + (self.reversa())+ " 5' ")
        elif self.seq_type=="RNA":
            print("5'" +" " + self.seq + " 3' ")
            print("  "f" {''.join(['|' for c in range(0,len(self.seq))])}")
            print("  "f" {''.join([' ' for c in range(0,len(self.seq))])}")
            print("             ÁRBOL DE NAVIDAD")
            print("  "f" {''.join([' ' for c in range(0,len(self.seq))])}")
            print("  "f" {''.join(['|' for c in range(0,len(self.seq))])}")
            print("5'" +" " + (self.reversa()[::-1])+ " 3' ")
        
    def gc_content(self):
        return "GC content= " + str(round((self.seq.count("G")+ self.seq.count("C"))/len(self.seq)*100)) + "%"
    
    def gc_content_intervalos(self, k=20):
        intervalos=[]
        for i in range(0, len(self.seq) -k+1 , k):
            subset=self.seq[i:i+k]
            intervalos.append((round((subset.count("G")+ subset.count("C"))/len(subset)*100)))
        return "GC content por intervalos de " + str(k) + ": "  + str(intervalos)


    def traducir(self,init_pos=0):
        
        if self.seq_type=="DNA":
            return [DNA_Codons[self.seq[pos:pos+3]] for pos in range(init_pos,len(self.seq)-2, 3)]
        elif self.seq_type=="RNA":
            return [RNA_Codons[self.seq[pos:pos+3]] for pos in range(init_pos, len(self.seq)-2,3)]


    def codon_use(self, aa):
        lista=list()
        for i in range(0, len(self.seq)-2, 3):
            if self.seq_type=="DNA":
                if DNA_Codons[self.seq[i:i+3]]==aa:
                    lista.append(self.seq[i:i+3])
            elif self.seq_type=="RNA":
                if RNA_Codons[self.seq[i:i+3]]==aa:
                    lista.append(self.seq[i:i+3])
        frec=dict(Counter(lista))
        total=sum(frec.values())
        for seq in frec:
            frec[seq]=round(frec[seq]/total, 2)     
        return frec
    
    
    def marcos_de_lectura(self):
        marcos=[]
        marcos.append(self.traducir(0))
        marcos.append(self.traducir(1))
        marcos.append(self.traducir(2))
        contra_seq=bio_seq(self.reversa()[::-1], self.seq_type)
        
        marcos.append(contra_seq.traducir(0))
        marcos.append(contra_seq.traducir(1))
        marcos.append(contra_seq.traducir(2))
        del contra_seq
        return marcos
    
    def proteinas_en_marco(self, aa_seq):
        prot=[]
        prots=[]
        for aa in aa_seq:
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
    
    def todas_las_proteinas(self, start=0, end=0, ordered=False):
        if end>start:
            cadena=bio_seq(self.seq[start:end], self.seq_type)
            rfs=cadena.marcos_de_lectura()
        else:
            rfs=self.marcos_de_lectura()
        
        res=[]
        for rf in rfs:
            proteinas=self.proteinas_en_marco(rf)
            for p in proteinas:
                res.append(p)
        if ordered:
            return sorted(res, key=len, reverse=True)
        return res
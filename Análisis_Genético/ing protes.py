# -*- coding: utf-8 -*-
"""
Created on Tue Jan 19 12:42:12 2021

@author: Juanma
"""

from bio_seq import bio_seq
from DNA_structures import writeTextFile, readTextFile, read_FASTA

fasta= read_FASTA("text.txt")
# print(fasta)
for f in fasta:

    seq=fasta[f]

sarscov=bio_seq(seq)
print(sarscov.transcribir())





















#print("cadena real de la proteína:"  )
#cadena="MHHHHHHSSGVDLGTENLYFQSNMSLENVAFNVVNKGHFDGQQGEVPVSIINNTVYTKVDGVDVELFENKTTLPVNVAFELWAKRNIKPVPEVKILNNLGVDIAANTVIWDYKRDAPAHISTIGVCSMTDIAKKPTETICAPLTVFFDGRVDGQVDLFRNARNGVLITEGSVKGLQPSVGPKQASLNGVTLIGEAVKTQFNYYKKVDGVVQQLPETYFTQSRNLQEFKPRSQMEIDFLELAMDEFIERYKLEGYAFEHIVYGDFSHSQLGGLHLLIGLAKRFKESPFELEDFIPMDSTVKNYFITDAQTGSSKCVCSVIDLLLDDFVEIIKSQDLSVVSKVVKVTIDYTEISFMLWCKDGHVETFYPKLQ"
#print (cadena)
#print()
#cadena_new=""
#print("cadena a partir de la información genética: ")
#for a in sarscov.traducir():
#    cadena_new=cadena_new+a;
#print(cadena_new)

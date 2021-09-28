
"""
AIV_pipe: The AIV pipeline will take raw Illumina MiSeq data of 
avain influenza samples and produce a word document report suitable 
for sending to external clients. This requires a number of 
automated steps including trimming and quality control, influenza genome 
assembly, alignments and cleavage site identification, phylogenetic 
tree building and final generation of the report.

Samples can be selected and parameters can be changed
by altering the config.yaml file
"""

import os, sys

configfile: "config.yaml"

# want to import all of the rules no matter where the program is installed
# this should work if we keep the filenames the same

include: os.path.join(os.path.expanduser(config["program_dir"]), "preprocessing/rules/preprocessing.smk")
include: os.path.join(os.path.expanduser(config["program_dir"]), "irma_assembly/rules/irma_assembly.smk")
include: os.path.join(os.path.expanduser(config["program_dir"]), "annotation/rules/annotation.smk")
include: os.path.join(os.path.expanduser(config["program_dir"]), "phylogenetics/rules/phylogenetics.smk")
include: os.path.join(os.path.expanduser(config["program_dir"]), "qc/rules/qc.smk")
include: os.path.join(os.path.expanduser(config["program_dir"]), "reporting/rules/report.smk")


rule all:
    input:
        "report01.docx"

# AIV Pipeline Introduction
---

The AIV pipeline will take **raw Illumina MiSeq data** of avain influenza samples and produce a **word document** report suitable for sending to external clients. This requires a number of automated steps including trimming and quality control, influenza genome assembly, alignments and cleavage site identification, phylogenetic tree building, and final generation of the report.

**Please feel free to modify or comment on the below.** These are just Matt's initial thoughts and might not be the best way to structure the pipeline.

A potential pipeline structure is below. Each person can work on a seperate 'module' with defined inputs and outputs, thereby not relying on other parts of the pipeline.

![modules](images/module_flow.png)


* The word document report will contain all figures, tables, captions, etc., but only preliminary interpretation statements. It is expected that laboratory staff will open the automatically generated word document and add interpretation / check outputs accordingly.

* As well as a report tailored towards clients, we may also need to generate a second report for laboratory staff that contains detailed QC information, etc., that may not be of interest to clients. This report could be in html format for better interactivity.

* Analysis of the cleavage site needs to indicate a high pathogentic or low pathogenic sequence

    * We could also compare new cleavage sequences to all other sequences we have recovered (or even on NCBI) and report if the cleavage site is novel or where else it has been seen. 

* The QC module will indicate data quality, depth of coverage, etc., and if the data is suitable for reporting. Note a regular occurance is that we only get partial genomes where only a few segments are complete. This is still useful information for reporting, particularly if the full HA segment is recovered.





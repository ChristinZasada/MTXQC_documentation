# Workflow for Maui-annotation projects{#wf:maui}

## Read this in case

- you have run a Maui project
- exported all required container (see \@ref(container))
- you have a copy of sequence list and experimental conditions
- you know the extraction procedure

The following article describes briefly how to use MTXQCvX2 in case you used Maui for the annotation of your metabolomics project. It does not matter if you have performed an experiment 
including stable isotopes or if you just aim for the quantification of a few intermediates. 

## Quick view

1. Setup a new R-project and copy MTXQC template files and folders
2. Knit with parameter: `MTXQC_init.Rmd` and create project folder, e.g., `psirm_glucose`
3. Copy input files and rename `ManualQuantTable.tsv` (e18205cz.tsv) 
4. Create `annotation.csv` and `sample_extracts.csv` files
5. Define the internal extraction standard
6. Knit with parameter: `MTXQC_ExperimentalSetup.Rmd` 
7. Knit with parameter: `MTXQC_part1.Rmd` 
8. Knit with parameter: `MTXQC_part2.Rmd` 
9. If required, proceed with `MTXQC_part3.Rmd` for ManualValidation

## Input files 

Three different kind of export functions have been implemented in Maui. These functions provide the export of the actual data into `.csv` or `.tsv` files that are directly usable as input files for MTXQCvX2. 
Please refer to section \@ref(mauiexport) how you perform the export and which containers have to be exported using what export function and where to copy them in `psirm_glucose/input/`.

Certain circumstances might wish you to combine _multiple MAUI-projects_ into one MTXQC-project. This might be the case when you run the same samples in split and splitless mode on the machine or your experimental setup has been measured in multiple batches in order to avoid derivatisation effects.

It is highly recommended to combine the input files derived from a different Maui projects beforehand the analysis. In that way you have only to work with a single file `CalculationFileData.csv`^[stored in `psirm_glucose/output/quant/...`] containing all data of the your experiment.

The herein described process provides a quick way how to combine the exported files from different Maui projects. The script `combine-sets.R`^[inst/template_files/...] automatically saves all combined files into the correct `input` folder. Just update the folder and subfolder names. All the rest has been taken care of for you.

1. Create in the MTXQC-project folder (e.g., `psirm_glucose/`) a new folder called `raw-data`
2. Create a subfolder for each Maui-project in `psirm_glucose/raw_data/...`
3. Copy into this folder all your Maui-derived input files altogether
4. Update the parameter of `combine-sets.R`, meaning folder name definitions,  file
5. Execute the  R script
6. Merged files have been generated and copied into the corresponding folder: `psirm_glucose/input-folder/gc/...` or `psirm_glucose/input-folder/inc/...`
7. Copy the renamed `ManualQuantTable.tsv` files of each Maui project into `psirm_glucose/input/quant/...`

## Annotation-file

The annotation file relate file names with experimental conditions or specify quantification standards in your batch. Two columns - **File and Type** - are obligatory and have to be present in the annotation file. In the case of their absence `MTXQCvX_part1.Rmd` stops processing and shows an error message.

A quick way to generate an annotation file is described below:

1. Copy the first row / header of `quantMassAreaMatrix.csv` file
2. Paste & transpose the content into a new Excel-File into column A
3. Change the first entry: Metabolite -> File
4. Remove the entry QuantMasses at the very end of the column A
5. Add the column Type and specify each file either as **sample** or **addQ1_dilution**^[see for further details additionalQuant]
6. Add more columns specifying your experimental conditions, e.g., Cellline and Treatment^[optimal: two-three parameter, max: four parameter. Consider possible combinations, e.g., HCT116-control, HCT116-BPTES]
7. Save the content as `csv-file` in the `psirm_glucose/input/...`

## Sample_extracts-file

The `sample_extracts.csv` file is required in order to determine automatically absolute quantities in the manner of pmol/1e+6 cells or pmol/mg tissue in the `CalculationFileData.csv`.

This file requires two obligatory columns - **Extract_vol** and **Unit**^[Define: count, mg or ul]. Please specify for each experimental condition the amount of extracted cells (count), tissue (mg) or volume of blood/plasme (ul) in the unit shown in the brackets.  
The names of the columns of the experimental conditions have to match up with the annotation file. Save the file in the folder `psirm_glucose/input/...`. 

If the defined experimental conditions do not match up with the annotation `MTXQCvX2_part1.Rmd` exit data processing. A template file is saved for review and usage at `inst/template_files/...` 

## Internal Standard

MTXQCvX2 allows the specification of project-specific internal extraction standards. The only thing you need to do is to define the corresponding compounds as an internal standard in the `conversion_metabolite.csv` file. To do so, add `InternalStandard` to the compound in last column `Standard`.

For an classical pSIRM experiment in the Kempa lab we are using cinnamic acid. The evaluation of this compound has been integrated in Maui. Peak areas of cinnamic acid are exported from a distinct container called `cinAcid`. The exported file has to be renamed to `InternalStandard.csv` though and moved to `psirm_glucose/input/gc/...`.

If you have used a different compound as an internal extraction standard you might need to extract the peak areas of this compound from the Maui export file `quantPeakAreasMatrix.csv` file and save it in the folder `psirm_glucose/input/gc/InternalStandard.csv`, respectively. Prerequisite - you have annotated the compound in Maui.

The report of `MTXQCvX2_part1.Rmd` includes the defined internal standard for each project in a message.

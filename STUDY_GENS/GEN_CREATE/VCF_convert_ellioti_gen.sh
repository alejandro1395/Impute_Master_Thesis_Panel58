#!/bin/bash

module load gcc/4.9.3
module load PYTHON/3.6.3

#REFERENCE
REF="/home/devel/marcmont/scratch/snpCalling_hg19/chimp/assembly/BWA/hg19.fa"
BIN="/scratch/devel/avalenzu/Impute_Master_Project/ANALYSIS_sep2018-dec2018_panel58/bin/PANEL_REF/"

#chromosomes
#chromosomes=$(echo {1..22})
chromosomes=1
#We need to have the files from sorted bam with merged name

#OUTPUT
OUTDIR="/scratch/devel/avalenzu/Impute_Master_Project/ANALYSIS_sep2018-dec2018_panel58/data/PANEL_REF/"
mkdir -p ${OUTDIR}
mkdir -p ${OUTDIR}qu/
mkdir -p ${OUTDIR}out/
mkdir -p ${OUTDIR}tmp/


#INPUTS for chr
DATA="/home/devel/marcmont/scratch/GA/GATK/JOINT/"
echo $chromosomes | tr " " "\n" | while read chr;
do mkdir -p ${OUTDIR}/chr${chr} 
INPUT=${DATA}"chr"${chr}"/GA.chr"${chr}".144combined.vcf.gz"
name=$(echo $INPUT | rev |  cut -d/ -f1 | rev)


#MAIN SCRIPT LOOPED FOR CHIMPS CHROMOSOMES


echo "#!/bin/bash
module purge
module load gcc/4.9.3-gold
module load GATK/4.0.8.1
module load TABIX/0.2.6
module load VCFTOOLS/0.1.7
module load zlib/1.2.8
module load intel/16.3.067
module load lapack/3.2.1
module load PLINK/1.90b

#MAIN SCRIPT

${BIN}plink --vcf ${INPUT} --keep ${OUTDIR}samples_file --double-id --recode oxford gen-gz --out ${OUTDIR}chr${chr}/ref_panel_chr${chr}" > ${OUTDIR}qu/ref_panel_chr${chr}.sh
jobname=$(echo ${OUTDIR}qu/ref_panel_chr${chr}.sh)
chmod 755 $jobname

#SUBMISSION TO CLUSTER
/scratch/devel/avalenzu/CNAG_interface/submit.py -c ${jobname} -o ${OUTDIR}out/ref_panel_chr${chr}.out -e ${OUTDIR}out/ref_panel_chr${chr}.err -n ${name} -u 4 -t 1 -w 05:00:00
done;

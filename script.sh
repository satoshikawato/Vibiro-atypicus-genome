#!/usr/bin/env sh


cd ${workdir}
#trim reads

cd reads

### QC reads ###

for lib in DSM25292 TUMSAT1;do

fastp \
--in1=${lib}_L001_R1_001.fastq.gz \
--out1=${lib}_R1.fastp.fq.gz \
--in2=${lib}_L001_R2_001.fastq.gz \
--out2=${lib}_R2.fastp.fq.gz \
--detect_adapter_for_pe \
--html=${lib}_fastp.html \
--thread=8
done

cd ..

### De novo assembly ###
for lib in DSM25292 TUMSAT1;do

spades.py \
-o ${lib}_spades \
-1 ./reads/${lib}_R1.fastp.fq.gz \
-2 ./reads/${lib}_R2.fastp.fq.gz \
--careful \
--only-assembler \
-k 21,33,55,77,89,101,113,125 \
--threads=16 \
--memory=500

done



### Annotation ###
for lib in DSM25292 TUMSAT1;do

cd  ${lib}_spades 

prokka \
--force --rfam \
--kingdom Bacteria \
--gram neg \
--genus Vibrio \
--species atypicus \
--strain ${lib} ${lib}.fna \
--usegenus \
--outdir ./prokka_${lib} \
--cpus 16

cd ..

done

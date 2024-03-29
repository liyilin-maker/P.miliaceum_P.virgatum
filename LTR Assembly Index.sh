cd shijunpeng/software/LTR_retriever/
./LAI -h
The LTR Assembly Index (LAI) is developed to evaluate the assembly continunity of repetitive sequences

Usage: ./LAI -genome genome.fa -intact intact.pass.list -all genome.out [options]
Options:
        -genome [file]  The genome file that is used to generate everything.
        -intact [file]  A list of intact LTR-RTs generated by LTR_retriever (genome.fa.pass.list).
        -all [file]     RepeatMasker annotation of all LTR sequences in the genome (genome.fa.out).
        -window [int]   Window size for LAI estimation. Default: 3000000 (3 Mb)
        -step [int]     Step size for the estimation window to move forward. Default: 300000 (300 Kb)
                        Set step size = window size if prefer non-overlapping outputs.
        -q              Quick estimation of LTR identity (much faster for large genomes, may sacrifice ~0.5% of accuracy).
        -qq             No estimation of LTR identity, only output raw LAI for within species comparison (very quick).
        -mono [file]    This parameter is mainly for ployploid genomes. User provides a list of sequence names that represent a monoploid (1x).
                        LAI will calculated only on these sequences if provided. So user can also specify sequence of interest for LAI calculation.
        -iden [0-100]   Mean LTR identity (%) in the monoploid (1x) genome. This parameter will inactivate de novo estimation (same speed to -qq).
        -totLTR [0-100] Specify the total LTR sequence content (%) in the genome instead of estimating from the -all RepeatMasker file.
        -blast [path]   The path to the blastn program. If left unspecified, then blastn must be accessible via shell ENV.
        -t [number]     Number of threads to run blastn.
        -h              Display this help info.
./LTR_retriever -h
##########################
### LTR_retriever v2.9.0 ###
##########################

A program for accurate identification of LTR-RTs from outputs of LTRharvest and
        LTR_FINDER, generates non-redundant LTR-RT library for genome annotations.

Shujun Ou (shujun.ou.1@gmail.com) 03/26/2019

Usage: LTR_retriever -genome genomefile -inharvest LTRharvest_input [options]

【Input Options】
-genome      [File]     Specify the genome sequence file (FASTA)
-inharvest   [File]     LTR-RT candidates from LTRharvest
-infinder    [File]     LTR-RT candidates from LTR_FINDER
-inmgescan   [File]     LTR-RT candidates from MGEScan_LTR
-nonTGCA     [File]     Non-canonical LTR-RT candidates from LTRharvest

【Output options】
-verbose/-v             Retain intermediate outputs (developer mode)
-noanno                 Disable whole genome LTR-RT annotation (no GFF3 output)

【Filter options】
-misschar    [CHR]      Specify the ambiguous character (default N)
-Nscreen                Disable filtering ambiguous sequence in candidates
-missmax     [INT]      Maximum number of ambiguous bp allowed in a candidate (default 10)
-missrate    [0-1]      Maximum percentage of ambiguous bp allowed in a candidate (default 0.8)
-minlen      [INT]      Minimum bp of the LTR region (default 100)
-max_ratio   [FLOAT]    Maximum length ratio of internal region/LTR region (default 50)
-minscore    [INT]      Minimum alignment length (INT/2) to identify tandem repeats (default 1000)
-flankmiss   [1-60]     Maximum ambiguous length (bp) allowed in 60bp-flanking sequences (default 25)
-flanksim    [0-100]    Minimum percentage of identity for flanking sequence alignment (default 60)
-flankaln    [0-1]      Maximum alignment portion allowed for 60bp-flanking sequences (default 0.6)
-motif       [[STRING]] Specify non-canonical motifs to search for
                        (default -motif [TCCA TGCT TACA TACT TGGA TATA TGTA TGCA])
-notrunc                Discard truncated LTR-RTs and nested LTR-RTs (will dampen sensitivity)
-procovTE    [0-1]      Maximum portion of allowed for cumulated DNA TE database and LINE database
                        lignments (default 0.7)
-procovPL    [0-1]      Maximum portion allowed for cumulated plant protein database alignments (default 0.7)
-prolensig   [INT]      Minimum alignment length (aa) for LINE/DNA transposase/plant protein alignment (default 30)

【Library options】
-blastclust  [[STRING]] Trigger to use blastclust and customize parameters
                        (default -blastclust [-L .9 -b T -S 80])
-cdhit       [[STRING]] Trigger to use cd-hit-est (default) and customize parameters
                        (default -cdhit [-c 0.8 -G 0.8 -s 0.9 -aL 0.9 -aS 0.9 -M 0])
-linelib     [FASTA]    Provide LINE transposase database for LINE TE exclusion
                        (default /database/Tpases020812LINE)
-dnalib      [FASTA]    Provide DNA TE transposase database for DNA TE exclusion
                        (default /database/Tpases020812DNA)
-plantprolib [FASTA]    Provide plant protein database for coding sequence exclusion
                        (default /database/alluniRefprexp082813)
-TEhmm       [Pfam]     Provide Pfam database for TE identification
                        (default /database/TEfam.hmm)

【Dependencies】
-repeatmasker [path]    Path to the RepeatMasker program. (default: find from ENV)
-blastplus   [path]     Path to the BLAST+ program. (default: find from ENV)
-blast       [path]     Path to the BLAST program. Required if -blastclust is used. (default: find from ENV)
-cdhit_path  [path]     Path to the CD-HIT program. Required if -cdhit is used. (default: find from ENV)
-hmmer       [path]     Path to the HMMER program. (default: find from ENV)
-trf_path    [path]     Path to the trf program. (default: find from ENV)

【Miscellaneous】
-u           [FLOAT]    Neutral mutation rate (per bp per ya) (default 1.3e-8 (from rice))
-step        [STRING]   Restart the program from a particular step. Existing outputs will be overwritten. Options:
                                Init (default, from the beginning);
                                Major (Tandem repeat cleanup finished, structrual analyses next)
                                Trunc (Structural analyses finished, truncated LTR recycle next)
                                Promask (Truncated LTR recycle finished, protein contamination cleanup next)
                                Library (Protein contamination cleanup finished, initial library construction next)
                                Next (Initial library construction finished, non-TGCA analyses next)
-threads     [INT]      Number of threads (≤ total available threads, default 4)
-help/-h                Display this help information
cd huangshihui/LAI/P.miliaceum/longmi_-mono
vi ltr_retriever_wholegenome_noline.sh  # 用的是师兄发的Longmi4_v1.fa，听了老师的建议后把scaffold里的下划线去掉了
#!/bin/bash

source ~/.bashrc

conda activate shijunpeng

srun -n 10 /public1/home/sc80041/shijunpeng/software/LTR_retriever/LTR_retriever -genome noline_longmi4.fa -infinder genome_noline.finder.scn -threads 10

跑不出来。直接用之前的结果，用shi.fna的LAI输出文件加上LAI参数去跑也出现no such file 的情况，详见7.8的slurm日志

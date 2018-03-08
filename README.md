# tandem-genotypes

`tandem-genotypes` tries to indicate the copy numbers of tandem
repeats, from alignments of DNA reads to a genome.  Its usage is:

    tandem-genotypes -g refGene.txt microsat.txt alignments.maf

This will check all tandem repeats in `microsat.txt` that overlap any
exon in `refGene.txt`.  If you omit `-g refGene.txt`, it will check
all tandem repeats.

You can supply tandem repeat locations by any of these files (which
can be obtained at the [UCSC genome
database](http://genome.ucsc.edu/)): microsat.txt, simpleRepeat.txt,
rmsk.txt, RepeatMasker .out.  You can also supply repeats in
[BED4](https://genome.ucsc.edu/FAQ/FAQformat.html#format1) format with
the repeating unit in column 4:

    chr1    6370457 6370506 TAT
    chr1    6708960 6709001 TC

You can supply genes with: refGene.txt, refFlat.txt.

The output looks like this:

    chr22  41914573  41914611  GCGCGA  SHISA8  -2 -2 -2 -2  0  0  0  0  0
    chr22  41994883  41994923  TG      SEPT3   -7 -3 -3 -1 -1  0  0

Each line shows one tandem repeat.  The first 3 columns show its
location in [BED3](https://genome.ucsc.edu/FAQ/FAQformat.html#format1)
format, column 4 shows the repeating unit, column 5 shows the gene
name.  The remaining numbers show the copy number change in each
alignment that covers the repeat: for example -2 means the aligned
read has 2 fewer copies than the reference.  Here, the first line is a
nice example with 2 clear alleles, and the second line is a nasty
example without clear alleles.

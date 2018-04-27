# tandem-genotypes

`tandem-genotypes` tries to indicate the copy numbers of tandem
repeats, from alignments of DNA reads to a genome.

## Usage

First, align your sequences as described
[here](https://github.com/mcfrith/last-rna/blob/master/last-long-reads.md).
Then, do:

    tandem-genotypes -g refGene.txt microsat.txt alignments.maf

This will check all tandem repeats in `microsat.txt` that overlap
exons or promoters of genes in `refGene.txt`.  If you omit `-g
refGene.txt`, it will check all tandem repeats.

## Output

The output looks like this:

    chr22  41914573  41914611  GCGCGA  SHISA8  coding  -2,-2,0,0   -2,-2,0,0,0
    chr22  41994883  41994923  TG      SEPT3   3'UTR   -7,-3,-1,0  -3,-1,0,1

Each line shows one tandem repeat.  The first 3 columns show its
location in [BED3](https://genome.ucsc.edu/FAQ/FAQformat.html#format1)
format, column 4 shows the repeating unit, column 5 shows the gene
name, and column 6 the gene part.  Column 7 shows the copy number
change in each DNA read that covers the repeat's forward strand: for
example -2 means the read has 2 fewer copies than the reference.
Column 8 has the same thing for reverse strands.  Here, the first line
is a nice example with 2 clear alleles, and the second line is a nasty
example without clear alleles.

## Tandem repeat input

You can supply tandem repeat locations by any of these files (which
can be obtained at the [UCSC genome
database](http://genome.ucsc.edu/)): microsat.txt, simpleRepeat.txt,
rmsk.txt, RepeatMasker .out.

You can also supply repeats by the first 4 (or 5, or 6) columns of the
output format:

    chr22  41914573  41914611  GCGCGA
    chr22  41994883  41994923  TG

If you are using the "hg19" or "hg38" human genome, you can supply
repeats with the included files `hg19-disease-tr.txt` and
`hg38-disease-tr.txt`, which have a few disease-associated repeats:

    tandem-genotypes -s0 hg38-disease-tr.txt alignments.maf

The `-s0` makes it check all the repeats.  (By default, it skips
repeats annotated "intron" or "intergenic".)

## Gene input

You can supply genes in these formats: refGene.txt, refFlat.txt,
[BED](https://genome.ucsc.edu/FAQ/FAQformat.html#format1).

If you supply a gene in BED format with < 12 columns,
`tandem-genotypes` won't consider exons/introns/promoters: it will
check all tandem repeats that overlap the BED range.

## Options

- `-h`, `--help`: show a help message and exit.

- `-g FILE`, `--genes=FILE`: read genes from a genePred or BED file.

- `-p BP`, `--promoter=BP`: promoter length (default=300).

- `-s N`, `--select=N`: select: all repeats (0), non-intergenic
  repeats (1), non-intergenic non-intronic repeats (2) (default=2).

- `-u BP`, `--min-unit=BP`: ignore repeats with unit shorter than BP
  (default=2).

- `--mode=LETTER`: L=lenient, S=strict (default=L).

- `-v`, `--verbose`: show more details.

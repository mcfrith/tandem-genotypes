# tandem-genotypes

`tandem-genotypes` finds changes in length of tandem repeats, from
"long" DNA reads aligned to a genome.

## Requirements & installation

[Python](https://www.python.org/) (>= 2.6 or 3) needs to be installed
on your computer.  To draw histograms, [R](https://www.r-project.org/)
needs to be installed on your computer.  You can download
`tandem-genotypes` to your computer, put the programs in any
convenient directory, and use them as-is.  You can also get
`tandem-genotypes` from [bioconda](https://bioconda.github.io/).

## Usage

First, align your sequences as described
[here](https://github.com/mcfrith/last-rna/blob/master/last-long-reads.md).

* You can use `last-split` `-fMAF`, to reduce the file size, with no
  effect on `tandem-genotypes`.

Then, do:

    tandem-genotypes -g refGene.txt microsat.txt alignments.maf > tg.txt

This will check the tandem repeats in `microsat.txt`, annotate them
with the genes in `refGene.txt`, and create an output file `tg.txt`.

* It's OK to omit `-g refGene.txt`.
* It's OK to use gzipped (`.gz`) files.

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

The output lines are in descending order of "importance", based on
size change and gene part.

## Drawing histograms

You can draw histograms of the output like this:

    tandem-genotypes-plot tg.txt

This will make a file `tg.pdf` with histograms of the top 16 repeats.
The x-axis is copy number change.  Each histogram bar has a red part
indicating the number of forward-strand reads, and a blue part
indicating the number of reverse-strand reads.  Instead of 16, you can
get (e.g.) the top 50:

    tandem-genotypes-plot -n50 tg.txt

You can see all options like this:

    tandem-genotypes-plot --help

You can choose subsets of repeats with standard command-line tools
like `grep`:

    grep "coding" tg.txt | tandem-genotypes-plot - coding.pdf

### Expected coverage drop for longer repeats

Longer repeats are likely to be fully covered by fewer reads.  You can
show the expected drop in coverage, for a set of reads (in FASTA or
FASTQ format):

    tandem-genotypes-plot --reads myseq.fa tg.txt

This shows the expected coverage drop as a gray line (whose absolute
height is meaningless, only its relative height within each histogram
is meaningful).

## Crude allele prediction

You can predict 2 alleles per repeat, with option `-o2`:

    tandem-genotypes -o2 -g refGene.txt microsat.txt alignments.maf > tg2.txt

This adds 2 extra columns to the output, with predicted copy number
change per allele.  These predictions are crude.  If there is really 1
allele (homozygous), but the DNA reads vary due to sequencing errors,
probably 2 close alleles will be predicted.  The possibility of strand
bias is not taken into account.

## Merging allele reads into a consensus sequence

You can extract the DNA reads of each allele (for the top 16 repeats
by default), and merge them into a consensus sequence, like this:

    tandem-genotypes-merge reads.fq myseq.par tg2.txt > merged.fa

This uses 3 input files: the read sequences (in fastq or fasta
format), `myseq.par` from the alignment step, and the
`tandem-genotypes` output file.  You must first run `tandem-genotypes`
with option `-o2` (to predict alleles) and option `-v` (to show read
names).  This merging requires [lamassemble][] to be installed on your
computer.  Run `tandem-genotypes-merge --help` to see the options
(most of which are described at the [lamassemble][] site).

## Tandem repeat input

You can supply tandem repeat locations by any of these files (which
can be got from the [UCSC genome
database](http://hgdownload.cse.ucsc.edu/downloads.html)):
simpleRepeat.txt, microsat.txt, rmsk.txt, RepeatMasker .out.

* `simpleRepeat`: repeats with unit length from 1 to >1000.  Made with
  [Tandem Repeats Finder](http://tandem.bu.edu/trf/trf.html).  
  Direct links: hg19
  [simpleRepeat.txt.gz](http://hgdownload.soe.ucsc.edu/goldenPath/hg19/database/simpleRepeat.txt.gz),
  hg38
  [simpleRepeat.txt.gz](http://hgdownload.soe.ucsc.edu/goldenPath/hg38/database/simpleRepeat.txt.gz)

* `microsat`: a subset of `simpleRepeat` with perfect di- and
  tri-nucleotide repeats.  Not comprehensive, but small and fast to
  analyze.  
  Direct links: hg19
  [microsat.txt.gz](http://hgdownload.soe.ucsc.edu/goldenPath/hg19/database/microsat.txt.gz),
  hg38
  [microsat.txt.gz](http://hgdownload.soe.ucsc.edu/goldenPath/hg38/database/microsat.txt.gz)

* `rmsk`: includes tandem repeats with unit length from 1 to ~13.
  Made with [RepeatMasker](http://www.repeatmasker.org/).  
  Direct links: hg19
  [rmsk.txt.gz](http://hgdownload.soe.ucsc.edu/goldenPath/hg19/database/rmsk.txt.gz),
  hg38
  [rmsk.txt.gz](http://hgdownload.soe.ucsc.edu/goldenPath/hg38/database/rmsk.txt.gz)

You can also supply repeats found by `tantan -f4`.

You can also supply repeats by the first 4 (or more) columns of the
output format:

    chr22  41914573  41914611  GCGCGA
    chr22  41994883  41994923  TG

If you are using the "hg19" or "hg38" human genome, you can supply
repeats with the included files `hg19-disease-tr.txt` and
`hg38-disease-tr.txt`, which have a few disease-associated repeats:

    tandem-genotypes hg38-disease-tr.txt alignments.maf

These files have "gene names" like: `ATXN7:SCA7`.  The 1st part is the
actual gene name, and the 2nd part is the disease
(e.g. spinocerebellar ataxia 7).

## Gene input

You can supply genes in these formats: refGene.txt, refFlat.txt,
[BED](https://genome.ucsc.edu/FAQ/FAQformat.html#format1).

## Joining and re-ranking `tandem-genotypes` outputs

Suppose you have DNA reads from 1 patient and 2 healthy controls.  You
can join their `tandem-genotypes` outputs like this:

    tandem-genotypes-join patient.txt : healthy1.txt healthy2.txt > out.txt

Each output line shows: 1 tandem repeat with copy number changes for
all inputs (in the order that you specified them).

The output lines are in descending order of "importance": large
changes in the patient are prioritized, and large changes in the
controls are de-prioritized.

You can run `tandem-genotypes-plot` on this output: it will show the
first (left-most) dataset.

You can use any number of patients and controls (separated by `:`).
You can also use concatenated files:

    cat healthy1.txt healthy2.txt > controls.txt
    tandem-genotypes-join patient.txt : controls.txt > out.txt

## Using a genome instead of reads

You can also find repeat length changes in a genome.  For example, in
a chimpanzee genome relative to human:

    tandem-genotypes -g refGene.txt microsat.txt hg38-panTro5-1.maf > chimp.txt

These human-chimp alignments are available
[here](https://github.com/mcfrith/last-genome-alignments).  You could
use the output as a "healthy control":

    tandem-genotypes-join patient.txt : controls.txt chimp.txt > out.txt

Points to be careful of:

* Make sure all files use the same "reference" genome.

* `tandem-genotypes` requires that the alignments are in the order
  produced by `last-split`.  So `hg38-panTro5-2.maf` from the above
  website won't work.

## Control files

You can use control files in the `controls` directory:

    tandem-genotypes-join patient.txt : hg38-microsat-control201808.txt > out.txt

Each file has 3 controls:

* PacBio reads from a human (NA12878 / SRR3197748)
* PromethION reads from a different human (NA19240 / ERR258112-5)
* A chimp genome (panTro5)

No doubt this will soon be outdated, but it should remain useful, if
not ideal.

These control files have been shrunk by keeping just one
representative copy number change per repeat per control, which does
not affect `tandem-genotypes-join` rankings.  They were made by
commands like:

    tandem-genotypes-join -ss SRR3197748-rmsk.txt ERR258112-5-rmsk.txt panTro5-rmsk.txt > rmsk-control.txt

One `-s` gets representative copy number changes, and a doubled `-ss`
also omits gene annotations.

## `tandem-genotypes` options

- `-h`, `--help`: show a help message and exit.

- `-g FILE`, `--genes=FILE`: read genes from a genePred or BED file.

- `-o NUM`, `--output=NUM`: output format: 1=original, 2=alleles
  (default=1).

- `-m PROB`, `--mismap=PROB`: ignore any alignment with mismap
  probability > `PROB` (default=1e-6).

- `--postmask=NUMBER`: by default, `tandem-genotypes` ignores
  mostly-lowercase alignments (using the method of
  [`last-postmask`](http://last.cbrc.jp/doc/last-postmask.html)).
  This is because lowercase indicates repetitive sequence, and
  alignments without a significant amount of non-repetitive sequence
  are less reliable.  You can turn this off with `--postmask=0`.

- `-p BP`, `--promoter=BP`: promoter length (default=300).  This is
  used for gene annotation.

- `-s N`, `--select=N`: select: all repeats (0), non-intergenic
  repeats (1), non-intergenic non-intronic repeats (2) (default=0).

- `-u BP`, `--min-unit=BP`: ignore repeats with unit shorter than `BP`
  (default=2).

- `-f BP`, `--far=BP`: use DNA reads whose alignments extend at least
  this far beyond both sides of the repeat (default=100).

- `-n BP`, `--near=BP`: count insertions <= BP beyond a repeat
  (default=60).

- `--mode=LETTER`: L=lenient, S=strict (default=L).  The non-default S
  mode has stricter requirements for using an alignment to a tandem
  repeat (such as requiring the alignment to actually cover the repeat
  at least a little bit).  This might be good for high-quality
  sequence data of the future, but is not recommended as of early
  2018.

- `-v`, `--verbose`: show more details.  `-v` shows the name of the
  DNA read with each copy number change.  `-vv` shows output for all
  repeats, including ones not covered by any DNA read.

## `tandem-genotypes-join` options

- `-h`, `--help`: show a help message and exit.

- `-s`, `--shrink`: shrink the output (see above).

- `-m NUM`, `--mean=NUM`: how to summarize the "importance" across
  multiple patients of changes in a tandem repeat.  "3" means to use
  the cubic mean of each patient's importance score: this was the
  method used before version 1.5.0 and described in the
  [paper](https://doi.org/10.1186/s13059-019-1667-6).  "1" means to
  use the ordinary mean: this is now the default.  The importance
  across controls is always summarized by cubic mean.

- `--scores=FILE`: override importance scores for gene parts, with a
  file like this:

      coding   50
      5'UTR    20
      3'UTR    20
      exon     15
      promoter 15
      intron   5

- `-v`, `--verbose`: prepend to each line: the importance score, the
  gene part importance score, the importance score from patients, the
  importance score from controls.

## Limitations

* `tandem-genotypes` doesn't work for tandem repeats at (or extremely
  near) the edge of a sequence.  This is because it uses DNA reads
  that clearly align beyond both sides of the repeat.

## Paper

For more details, please see: [Robust detection of tandem repeat
expansions from long DNA
reads](https://doi.org/10.1186/s13059-019-1667-6) by S Mitsuhashi, MC
Frith, et al.

[lamassemble]: https://gitlab.com/mcfrith/lamassemble

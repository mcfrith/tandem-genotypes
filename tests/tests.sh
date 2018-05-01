#! /bin/sh

try () {
    echo TEST "$@"
    eval "$@"
    echo
}

cd $(dirname $0)

PATH=..:$PATH

{
    try tandem-genotypes --help
    try tandem-genotypes microsat.txt nano.maf
    try tandem-genotypes -s2 -g refFlat.txt simpleRepeat.txt nano.maf
    try tandem-genotypes -s2 -v -g refFlat.txt simpleRepeat.txt nano.maf
    try tandem-genotypes -s2 -g refGene.txt rmsk.txt nano.maf
    try tandem-genotypes -s2 -g refFlat.txt rmsk.out nano.maf
    try tandem-genotypes -s0 -g refFlat.txt simpleRepeat.txt nano.maf
    try tandem-genotypes -s1 -g refFlat.txt simpleRepeat.txt nano.maf
    try tandem-genotypes near-beg.bed near-beg.maf
    try tandem-genotypes small-rep.bed small-rep.maf
    try tandem-genotypes far.bed far.maf
    try tandem-genotypes -u1 -s1 -g refFlat.txt simpleRepeat.txt nano.maf
    try tandem-genotypes -u3 -s2 -g refFlat.txt simpleRepeat.txt nano.maf
    try tandem-genotypes slop3.bed slop3.maf
    try tandem-genotypes -s2 -p900 -g refFlat.txt simpleRepeat.txt nano.maf
    try tandem-genotypes ../hg38-disease-tr.txt far.maf
    try "sed 's/chr//' far.maf | tandem-genotypes far.bed"
} 2>&1 |
diff -u $(basename $0 .sh).out -

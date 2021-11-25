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
    try tandem-genotypes -s2 -g refFlat.txt tantan.txt nano.maf
    try tandem-genotypes -s0 -g refFlat.txt simpleRepeat.txt nano.maf
    try tandem-genotypes -s1 -g refFlat.txt simpleRepeat.txt nano.maf
    try tandem-genotypes --postmask=0 near-beg.bed near-beg.maf
    try tandem-genotypes --postmask=0 small-rep.bed small-rep.maf
    try tandem-genotypes --postmask=0 far.bed far.maf
    try tandem-genotypes -u1 -s1 -g refFlat.txt simpleRepeat.txt nano.maf
    try tandem-genotypes -u3 -s2 -g refFlat.txt simpleRepeat.txt nano.maf
    try tandem-genotypes --postmask=0 slop3.bed slop3.maf
    try tandem-genotypes -s2 -p900 -g refFlat.txt simpleRepeat.txt nano.maf
    try tandem-genotypes --postmask=0 ../hg38-disease-tr.txt far.maf
    try "sed 's/chr//' far.maf | tandem-genotypes --postmask=0 far.bed"
    try tandem-genotypes -o2 -s2 -g refFlat.txt simpleRepeat.txt nano.maf

    try tandem-genotypes-join --help
    try tandem-genotypes-join min.txt : pro.txt ape.txt
    try tandem-genotypes-join -ss min.txt : pro.txt ape.txt
    try tandem-genotypes-join nano.txt : min.txt
    try tandem-genotypes-join -c1 nano.txt
    try tandem-genotypes-join -c2 nano.txt
} 2>&1 | diff -u tests.out -

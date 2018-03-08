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
    try tandem-genotypes -g refFlat.txt simpleRepeat.txt nano.maf
    try tandem-genotypes -v -g refFlat.txt simpleRepeat.txt nano.maf
    try tandem-genotypes -g refGene.txt rmsk.txt nano.maf
    try tandem-genotypes -g refFlat.txt rmsk.out nano.maf
    try tandem-genotypes -pI -g refFlat.txt simpleRepeat.txt nano.maf
    try tandem-genotypes -pEI -g refFlat.txt simpleRepeat.txt nano.maf
} 2>&1 |
diff -u $(basename $0 .sh).out -

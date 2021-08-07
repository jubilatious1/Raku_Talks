# Array Design Format (ADF) -- found here:
# "A simple spreadsheet-based, MIAME-supportive format for microarray data: MAGE-TAB"
# https://www.ncbi.nlm.nih.gov/pmc/articles/PMC1687205/
#
#One-Liners Below Convert Test ADF file to FASTA format;
#
#INFO:
# Lines 20-21 of file (column header):
# "[main]
#Block Column	Block Row	Column	Row	Reporter Name	Reporter Database Entry[refseq]	Reporter Database Entry[embl]	Reporter Sequence	Reporter Group[role]	Control Type"

# Object file: Remove first 2908 lines of introductory text along with control probe listings
#
# Data Chunk (sans Controls): 33849 rows × 10 columns
#
# object file cannot have trailing blank lines!
#


# 1. capture columns and ws after 30mer DNA and move to leftend of line:
raku -e 'for lines() {S/<?after <[AGCT]>**30> \t (.+)//; put $0 ~ $_; };'

# 2. delete characters AFTER 30mer DNA sequence (linewise):
raku -e 'for lines() {put S/<?after <[AGCT]>**30> .+// };'

# 3. capture gene IDs in two columns before 30mer DNA and move to leftend of line:
# use J Worthington answer: stackoverflow.com/questions/58982745/raku-one-line-expression-to-capture-group-from-string
raku -e 'for lines() {if $_ ~~ /(<graph>+) \t**1..2 <?before <[AGCT]>**30>/  -> ($s) {put $s ~ "\t" ~ $_;} else {put "Nil_\t" ~ $_;};};'

# 4. delete geneIDs in the one-or-two columns before 30mer DNA:
raku -e 'for lines() {put S/ <graph>+ \t**1..2 <?before <[AGCT]>**30>//;};'

# 5. clean up immediate regex above by deleting one tab where two exist before 30mer DNA:  some rows are missing a corresponding genbankID, use below:
raku -e 'for lines() {put S/\t**1..3 <?before <[AGCT]>**30>/\t/ given $_;};'

# 6. take next-to-last 'GE probe' column (just before 30merDNA), and make it second column after genbank IDs:
raku -e 'for lines() {my $probe = $_ ~~ /(<alnum>+) \t <?before <[AGCT]>**30>/; put S/ <?after ^^<graph>+\t> / $probe / given $_;};'

# 7. delete single column BEFORE 30mer DNA sequence:
raku -e 'for lines() {put S/ (<alnum>+) \t <?before <[AGCT]>**30>// given $_;};'

# 8. At immediate beginning (left end) of line, insert ">" prompt character:
raku -e 'for lines() {put S/ ^^\>/\>/ given $_;};'

# 9(a). replace all tabs with one space each:
raku -e 'for lines() {.subst(/ \t /, " ", :g).put;};'

# 9(b) OPTIONAL: join first two columns via "_" (snakecase) --avoids problem with vulgar format.
raku -e 'for lines()  {put S/<?after ^^\><graph>+> (\s+) <before GE\d+ \s+ .+$$>/_/ given $_};'

# 10. add newline just before 30mer DNA sequence to break line in two:
raku -e 'for lines() {put S/ <?before <[AGCT]>**30 > /\n/; };'

#below all 10 steps. Delete last step to get '9-stepper' file (for probe manipulation):
#
raku -e 'for lines() {S/<?after <[AGCT]>**30> \t (.+)//; put $0 ~ $_; };' | raku -e 'for lines() {put S/<?after <[AGCT]>**30> .+// };' | raku -e 'for lines() {if $_ ~~ /(<graph>+) \t**1..2 <?before <[AGCT]>**30>/  -> ($s) {put $s ~ "\t" ~ $_;} else {put "Nil_\t" ~ $_;};};' | raku -e 'for lines() {put S/ <graph>+ \t**1..2 <?before <[AGCT]>**30>//;};' | raku -e 'for lines() {put S/\t**1..3 <?before <[AGCT]>**30>/\t/ given $_;};' | raku -e 'for lines() {my $probe = $_ ~~ /(<alnum>+) \t <?before <[AGCT]>**30>/; put S/ <?after ^^<graph>+\t> / $probe / given $_;};' | raku -e 'for lines() {put S/ (<alnum>+) \t <?before <[AGCT]>**30>// given $_;};' | raku -e 'for lines() {put S/^^/> / given $_;};' | raku -e 'for lines() {.subst(/ \t /, " ", :g).put;};' | raku -e 'for lines() {put S/ <?before <[AGCT]>**30 > /\n/; };'



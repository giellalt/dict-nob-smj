
# Dette skal bli ei makefil for å lage nobsmj.fst, 
# ei fst-fil som tar nob og gjev ei smj-omsetjing.

# Førebels er det berre eit shellscript.
# Kommando for å lage nobsmj.fst

# sh nobsmj.sh

echo ""
echo "----------------------------------------------------"
echo "Shellscript to make a transducer of the dictionary."
echo ""
echo "It writes a lexc file to bin, containing the line	 "
echo "LEXICON Root										 "
echo "Thereafter, it picks lemma and first translation	 "
echo "of the dictionary, adds them to this lexc file,	 "
echo "and compiles a transducer bin/nobsmj.fst		 "
echo ""
echo "Usage:"
echo "lookup bin/nobsmj.fst"
echo ""
echo "(or if you have set up the alias: just write nobsmj)"
echo "----------------------------------------------------"
echo ""




echo "LEXICON Root" > bin/nobsmj.lexc

cat src/*_nobsmj.xml   | \
tr '\n' '™'            | \
sed 's/<e/£/g;'        | \
tr '£' '\n'            | \
sed 's/<re>[^>]*>//g;' | \
tr '<' '>'             | \
cut -d">" -f6,16       | \
tr ' ' '_'             | \
sed 's/:/%/g;'         | \
tr '>' ':'             | \
grep -v '__'           | \
sed 's/$/ # ;/g'       >> bin/nobsmj.lexc


printf "read lexc < bin/nobsmj.lexc \n\
invert net \n\
save stack bin/nobsmj.fst \n\
quit \n" > tmpfile
xfst -utf8 < tmpfile
rm -f tmpfile


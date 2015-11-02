PAN=/C/Users/Tom/AppData/Local/Pandoc/pandoc.exe 
EBC=/C/Program\ Files/Calibre2/ebook-convert.exe
DROPBOX='/C/Users/Tom/Documents/My Dropbox/Public'
echo "<div style='page-break-before:always;'></div><h1>Inside Dust Jacket</h1><br/>" | cat - insidedustjacket.md > insidedustjacket.md.tmp
sed -i '/<div style="text-align/,$d' insidedustjacket.md.tmp
echo "<div style='page-break-before:always;'></div><h1>Back of Dust Jacket</h1><br/>" | cat - backofdustjacket.md > backofdustjacket.md.tmp
sed -i '/<div style="text-align/,$d' backofdustjacket.md.tmp
# TODO: update last chapter
typeset -i i LAST_CHAP
LAST_CHAP=14

FNAME="ofvioletsandlicorice_ch1_${LAST_CHAP}_`date +%m%d%Y`"
sed -i "s/779\/ofviolets.*\.mobi/779\/$FNAME.mobi/" book.html
sed -i "s/779\/ofviolets.*\.epub/779\/$FNAME.epub/" book.html

UPDATE_LIST="126996872554 insidedustjacket.md 
             127000556994 backofdustjacket.md 
             129354078274 notes.html
             126100415919 chapter1.md 
             128665608999 chapter2.md 
             129232051344 chapter3.md
             129421655504 chapter4.md
             129778824974 chapter5.md
             129929958959 chapter6.md
             130091632584 chapter7.md
             130345019824 chapter8.md
             130757370364 chapter9.md
             130908013549 chapter10.md
             130908034409 chapter11.md
             130908092409 chapter12.md
             130908111454 chapter13.md
             130908130064 chapter14.md
             130908149194 chapter15.md
             130908177659 chapter16.md
             130908197564 chapter17.md
             130908218404 chapter18.md
             130908239619 chapter19.md
             130908262644 chapter20.md
             130908282434 chapter21.md
             130908308029 chapter22.md
             130908326604 chapter23.md
             129355307919 book.html
             "
set -- $UPDATE_LIST 
while [ ! -z "$1" ]  # while $1 is not empty
do
  /c/perl64/bin/perl ../api/updateblog.pl $1 $2
  shift 2
done
# For title based on chapters and date
#echo "---" > title.md.tmp
#echo "title: Of Violets and Licorice, Chapter $LAST_CHAP, `date '+%b %d %Y'`" >> title.md.tmp
#echo "..." >> title.md.tmp
#CHAPLIST="title.md insidedustjacket.md.tmp backofdustjacket.md.tmp"
CHAPLIST="title.md.tmp insidedustjacket.md.tmp backofdustjacket.md.tmp"
sed "s/xxxx/Chapters 1-$LAST_CHAP, `date '+%b %d %Y'`/" title.md > title.md.tmp
let i=1
while ((i <=LAST_CHAP)); do
  echo "<div style='page-break-before:always;'><h1>Chapter $i</h1><br/><br/><br/><br/><br/>" | cat - chapter$i.md > chapter$i.md.tmp
  sed -i '/<div style="text-align/,$d' chapter$i.md.tmp
  CHAPLIST="$CHAPLIST chapter$i.md.tmp"
  let i++
done

echo "<div style='page-break-before:always;'><h1>Notes, Questions, Uncertainties</h1><br/><br/>" | cat - notes.html > notes.html.tmp
CHAPLIST="$CHAPLIST notes.html.tmp"


$PAN -t epub --epub-cover-image=cover.jpg $CHAPLIST -o $FNAME.epub -V title:""
#$PAN $CHAPLIST -o $FNAME.pdf -V title:""

"$EBC" $FNAME.epub $FNAME.mobi

#"$EBC" $FNAME.epub $FNAME.pdf --margin-left 25 --margin-right 25 --preserve-cover-aspect-ratio

rm "$DROPBOX"/*.mobi
rm "$DROPBOX"/*.epub
cp $FNAME.* "$DROPBOX"/.

rm *.tmp

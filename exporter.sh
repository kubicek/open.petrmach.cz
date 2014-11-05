for f in ./records/*.doc
do
 echo "Processing $f"
 fn=$(basename "$f")
 fn="${fn%.*}"
 fn="ep-votings/$fn.json"
 cat $f | antiword -w 0 -t -i 1 - | ruby parser.rb > $fn
 if [ "$( cat $fn)" == "[]" ]; then rm $fn; fi
done

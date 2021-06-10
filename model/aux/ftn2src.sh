
thisdir=`pwd`
ftndir='../ftn'
srcdir='../src'

mkdir $srcdir

DIRLIST=". SCRIP PDLIB" 

for DIR in $DIRLIST
do 
  set -x 
  cd $ftndir/$DIR
  echo $pwd
  ftnfiles=`ls *.ftn`
  ftnfiles=$(sed -e "s/.ftn//g" <<< $ftnfiles)
  nonftnfiles=`ls -I "*.ftn"`

  cd $thisdir
  if [ ! -d $srcdir/$DIR ] 
  then 
     echo "$DIR mkdir"
     mkdir -p $srcdir/$DIR
  fi  

  set -x
  for file in $ftnfiles
  do
    echo "convert $DIR/$file.ftn to a .F90"
    echo "$ftndir/$DIR/${file}.ftn"
    gawk -f $thisdir/switch2cpp.awk < $ftndir/$DIR/${file}.ftn > $ftndir/$DIR/${file}.F90
    mv $ftndir/$DIR/${file}.F90 $ftndir/$DIR/${file}.ftn 
    git mv $ftndir/$DIR/${file}.ftn  $srcdir/$DIR/${file}.F90
  done

  for file in $nonftnfiles
  do
    echo "move $DIR/$file to src" 
    git mv $ftndir/$DIR/${file} $srcdir/$DIR/
  done

done



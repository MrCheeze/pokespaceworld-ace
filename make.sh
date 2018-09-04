out=`wla-gb payload.asm 2>&1`
echo "$out"
if [ -n "$out" ]; then
    read
	exit 1
fi
out=`wlalink linkfile payload.gb 2>&1`
echo "$out"
if [ -n "$out" ]; then
    read
	exit 1
fi

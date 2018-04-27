id=$1

host=`hostname`
env=${host:0:4}


middle="RHGFXDV"



ssh -o LogLevel=Error $env$middle$id

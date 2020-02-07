#!/usr/bin/env bash

# First Args is the limit of loop
# Second Args is bucket name
# Third Args is file size

echo -e "
[Credentials]
language=CH
endpoint=$endpoint
accessKeyID=$accessKeyId
accessKeySecret=$accessKeySecret
" > ~/.ossutilconfig



limit=0
while ((limit<$1))
do
    ((limit++))
    echo "--------------- benchmark No: $limit ---------------"
    # create a custom file
    file=$(date +%s)

    # The first args is size
    ./file_gen.sh $PWD/$file $3

    ossutil cp $PWD/$file oss://$2/dragonfly/$file -c ~/.ossutilconfig

    kubectl pexec --ignore-hostname=true deploy dragonfly-preheat "/opt/dragonfly/df-client/dfget --url \"http://$2.$internalendpoint/dragonfly/$file\"  --output ./$file --node $supernodes --locallimit 800M --totallimit 800M| grep \"download SUCCESS\""


    echo "Start to fetch file from agent"

    # echo "/opt/dragonfly/df-client/dfget --url \"http://$2.$endpoint/dragonfly/$file\" --output ./$file --node \"supernode.default.svc.cluster.local\""

    kubectl pexec --ignore-hostname=true  ds dragonfly-agent "/opt/dragonfly/df-client/dfget --url \"http://$2.$internalendpoint/dragonfly/$file\"  --output ./$file --node $supernodes --locallimit 800M --totallimit 800M| grep \"download SUCCESS\""

    echo "Done"

    echo "Clean up files"
    rm -f $PWD/$file
    ossutil rm oss://$2/dragonfly/$file -c ~/.ossutilconfig
    kubectl pexec --ignore-hostname=true ds dragonfly-agent "rm -f ./$file"

    echo "--------------- benchmark Done ---------------"

    # Sleep 10s
    sleep 10
done






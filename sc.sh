while IFS= read -r line; do
    # Extract the last section of the line separated by '/'
    last=$(echo "$line" | awk -F'/' '{print $NF}')

    # Run skopeo sync command
    skopeo sync --src-creds adminuser:password --src docker --dest dir "aq1nml-d-os-bst.dcls.qpn.local:5001/$line" "/images/$last"

done < /images/namesf.txt

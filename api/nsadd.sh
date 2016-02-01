while getopts h:i: OPT
do
    case $OPT in
        h) host=$OPTARG
           ;;
        i) ip=$OPTARG
           ;;
    esac
done



echo "$host       IN A     $ip" | sudo tee -a  /var/named/chroot/var/named/example.com.db
echo `date`
echo "${host}:${ip}"
sudo service named restart

# Nottingham gpu-cluster
# sh -c "rclone --vfs-cache-mode writes mount \"ahead_ntu130\": ~/ahead-office"

# run vpn

sh -c "sudo openconnect --protocol=fortinet --user=naryyeh ${VPN_IP}:10443 --servercert pin-sha256:vrEuFqahfops0cXRVfFyjx9qVLrIcJ5k9VgZrpSy3/o= "

# mount home dir
sh -c "sshfs naryyeh@office:/home/naryyeh/ ~/ahead-office/home/"

# mount datalake (optional)
# sh -c "sshfs naryyeh@office:/mnt/nas/data_lake ~/ahead-office/data_lake"

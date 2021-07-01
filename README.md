# hydra
Some tools and quick install scripts for setting up HYDRA wallet on different systems for arm devices and Linux versions.


For notify.sh:
Install pushbullet and get an access token. Edit required areas: ACCESS_TOKEN, node, hydra and script logFile locations. Customize watchpatterns as needed.
Set script as executable (chmod +x ./notify.sh) and install as a service: (change file name and service name)
Here's a good guide: https://tecadmin.net/run-shell-script-as-systemd-service/
may need to install bc and jq -> 'apt-get install jq' and 'apt-get install bc' execute script with './notify.sh' or 'bash notify.sh'

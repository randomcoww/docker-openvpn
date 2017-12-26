#!/bin/bash
## load all zones
file_opts=''
config_path='/etc/openvpn'
status_path='/run/openvpn.status'
pid_path='/run/openvpn.pid'

## pass file content in like
# OVPN_AUTH_USER_PASS='file content'
# generates file __auth-user-pass
# adds command option --auth-user-pass __auth-user-pass
rm -f "$config_path/__*"

opt_prefix='OVPN_'

for config in $(compgen -e); do
  if [[ $config == $opt_prefix* ]]; then
    opt=${config#$opt_prefix}
    opt=${opt//_/-}
    opt=${opt,,}

    echo -en "${!config}" > "$config_path/__$opt"
    file_opts="$file_opts --$opt $config_path/__$opt"
  fi
done

## create tun device
## https://caveofcode.com/2017/06/how-to-setup-a-vpn-connection-from-inside-a-pod-in-kubernetes/
mkdir -p /dev/net
mknod -m 600 /dev/net/tun c 10 200
openvpn --mktun --dev tun0 --dev-type tun --user root --group nogroup

## start
rm -f $status_path $pid_path
exec sg nogroup -c "exec openvpn \
  $@ $file_opts \
  --dev tun0 \
  --cd $config_path \
  --status $status_path 10 \
  --writepid $pid_path"

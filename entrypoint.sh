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

## start
rm -f $status_path $pid_path
exec openvpn \
  $@ $file_opts \
  --cd $config_path \
  --status $status_path 10 \
  --writepid $pid_path

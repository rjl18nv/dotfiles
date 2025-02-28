alias wfscan='/System/Library/PrivateFrameworks/Apple80211.framework/Versions/A/Resources/airport scan'	
alias wfon='networksetup -setairportpower en0 on'	
alias wfoff='networksetup -setairportpower en0 off'	
alias wfjoin='networksetup -setairportnetwork en0'	
alias wfi='networksetup -listallhardwareports'	
alias local_ip='ifconfig | grep inet | grep broadcast | cut -d " " -f 2'	
alias public_ip='dig +short myip.opendns.com @resolver1.opendns.com'	
alias renewip='sudo ipconfig set en0 BOOTP && sudo ipconfig set en0 DHCP'	

# Stop after sending count ECHO_REQUEST packets #
alias ping='ping -c 5'
# Do not wait interval 1 second, go fast #
alias fastping='ping -c 100 -s.2'

alias ports='netstat -tulanp'

# Fetch VM's IP address
#
# Usage:
# bash vm-ip <DOMAIN>
#
# Example:
# bash vm-ip fedora23

arp -an | grep `virsh dumpxml ${1} | xmllint --xpath "string((//interface/mac/@address)[1])" -`

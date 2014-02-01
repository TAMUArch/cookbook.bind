default['bind']['data_bag'] = 'zones'

# Bind Zone Variables
default['bind']['zones'] = []

# Base stuffs for any zone
default['bind']['soa'] = node['fqdn']
default['bind']['soa_email'] = "root.#{node['fqdn']}"
default['bind']['ttl'] = '604800'
default['bind']['refresh'] = '604800'
default['bind']['retry'] = '86400'
default['bind']['expire'] = '2419200'
default['bind']['minimum'] = '604800'
default['bind']['nameservers']

# Slave master configs
default['bind']['server']['role'] = 'master'
default['bind']['server']['masters']
# Bind Named Conf Options
default['bind']['options']
default['bind']['forward_ips']

## Bind Packages
case node['platform']
when 'debian', 'ubuntu'
  default['bind']['package_name'] = 'bind9'
  default['bind']['dir'] = '/etc/bind'
  default['bind']['service'] = 'bind9'
  default['bind']['db_dir'] = '/etc/bind'
when 'redhat', 'centos', 'amazon', 'scientific'
  default['bind']['package_name'] = 'bind'
  default['bind']['dir'] = '/etc'
  default['bind']['service'] = 'named'
  default['bind']['db_dir'] = '/etc/named'
end

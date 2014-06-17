include_recipe 'bind'

node.default['bind']['acls'] = {
  recurseallow: %w(192.168.1.0/24 192.168.2.0/24),
  another_acl: %w(192.168.3.0/24)
}

node.default['bind']['options']['dump-file'] = '"/var/log/named_dump.db"'

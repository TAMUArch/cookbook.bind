zones = data_bag(node['bind']['data_bag'])

Chef::Log.error('Data bag cannot be empty') if zones.empty?

node.set['bind']['zones'] = zones

zones.each do |zone|
  zone_info = data_bag_item(node['bind']['data_bag'], zone)

  bind_zone zone do
    action [:create, :reverse]
    nameservers zone_info['nameservers']
    records zone_info['hosts']
    network zone_info['network']
    retry_time zone_info['retry_time'] || node['bind']['retry']
    refresh_time zone_info['refresh_time'] || node['bind']['refresh']
    expire_time zone_info['expire_time'] || node['bind']['expire']
    cache_minimum zone_info['cache_minimum'] || node['bind']['minimum']
    serial zone_info['seed'] unless zone_info['seed'].nil?
  end
end

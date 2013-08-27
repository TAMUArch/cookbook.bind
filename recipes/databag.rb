zones = data_bag(node[:bind][:data_bag])
if zones.empty?
  Chef::Log.error("Data bag cannot be empty")
end

zones.each do |zone|

  zone_info = data_bag_item(node[:bind][:data_bag], zone)

  bind_zone zone do
    action :create
    nameservers zone_info['nameservers']
    records zone_info['hosts']
    retry_time zone_info['retry_time'] || node[:bind][:retry]
    refresh_time zone_info['refresh_time'] || node[:bind][:refresh]
    expire_time zone_info['expire_time'] || node[:bind][:expire]
    cache_minimum zone_info['cache_minimum'] || node[:bind][:minimum]
    serial zone_info['seed'] unless zone_info['seed'].nil?
  end
end

node.set[:bind][:zones] = zones

template "#{node[:bind][:dir]}/named.conf.local" do
  source "named.conf.erb"
  mode "0644"
  group "root"
  owner "root"
  notifies :reload, "service[#{node[:bind][:service]}]"
end
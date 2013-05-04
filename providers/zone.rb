action :delete do
  if ::File.exists?("db.#{new_resource.zone_name}")
    file "db.#{new_resource.zone_name}" do
      action :delete
      notifies :reload,"service[#{node[:bind][:service]}]", :immediately
    end
  end
end

action :create do  

  # A sha256 hash is used to determine whether any records have changed
  require 'digest'

  new_hash = Digest.hexencode(Digest::SHA256.digest new_resource.records.to_s)

  if !node[:bind][:records_hash].nil? 
    if new_hash != node[:bind][:records_hash][new_resource.zone_name]
      serial = rand (10 ** 10)
      node.set[:bind][:records_hash][new_resource.zone_name] = new_hash
    end
  else 
    node.set[:bind][:records_hash][new_resource.zone_name] = new_hash 
    serial = rand (10 ** 10)
  end

  template "#{node[:bind][:db_dir]}/db.#{new_resource.zone_name}" do
    source "zone.db.erb"
    mode "0644"
    owner "root"
    group "root"
    variables({:zone => new_resource.zone_name, 
               :records => new_resource.records,
               :serial => new_resource.serial || serial, 
               :retry_time => new_resource.retry_time || node[:bind][:retry],
               :refresh_time => new_resource.refresh_time || node[:bind][:refresh],
               :expire_time => new_resource.expire_time || node[:bind][:expire],
               :nameservers => new_resource.nameservers || node[:bind][:nameservers],
               :cache_minimum => new_resource.cache_minimum || node[:bind][:minimum]})
    notifies :restart, "service[#{node[:bind][:service]}]"
  end 
end 

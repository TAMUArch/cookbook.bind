action :delete do
  if ::File.exists?("db.#{new_resource.zone_name}")
    file "db.#{new_resource.zone_name}" do
      action :delete
      notifies :reload,"service[#{node[:bind][:service]}]", :immediately
    end
  end
end

action :create do
  refresh_time = new_resource.refresh_time || node[:bind][:refresh]
  retry_time = new_resource.retry_time || node[:bind][:retry]
  expire_time = new_resource.expire_time || node[:bind][:expire]
  cache_minimum = new_resource.cache_minimum || node[:bind][:minimum]
  
  template "#{node[:bind][:dir]}/db.#{new_resource.zone_name}" do
    source "zone.db.erb"
    mode "0644"
    owner "root"
    group "root"
    variables({:zone => new_resource.zone_name, 
               :records => new_resource.records,
               :serial => rand(10 ** 10),
               :refresh_time => refresh_time,
               :expire_time => expire_time,
               :cache_minimum => cache_minimum})
    notifies :restart, "service[#{node[:bind][:service]}]"
  end 
end 

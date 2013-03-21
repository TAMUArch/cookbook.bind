#
# Cookbook Name:: bind
# Recipe:: default
#
# Copyright 2013, Texas A&M
#
# All rights reserved - Do Not Redistribute
#

package node["bind"]["package_name"] do
  action [:install]
end

# Only supporting data bags at this time
# TODO: Support multiple domains
if !node["databag"]["domains"].empty?
  node.set[:bind][:serial] = data_bag_item("domains", node["databag"]["domains"])["seed"]
  zones = Array.new
  zones.push(data_bag_item("domains", node["databag"]["domains"])["id"])
  zones.push(data_bag_item("domains", node["databag"]["domains"])["network"].split(".")[0..-2].reverse.join(".")+".IN-ADDR.ARPA")
  node.set[:bind][:zones]=zones

  node.set[:bind][:nameservers] = data_bag_item("domains", node["databag"]["domains"])["nameservers"]
  template "#{node["bind"]["dir"]}/named.conf.local" do
    source "named.conf.erb"
    mode "0644"
    group "root"
    owner "root"
    notifies :reload, "service[#{node["bind"]["service"]}]"
  end

  # Populates the entries in the db files
  zones.each do |zn|
    entries = Array.new

    hosts = data_bag_item("domains", node["databag"]["domains"])["hosts"] 
    # TODO: Add abilities to handle different records
    # Check if address is PTR or A/CNAME
    if !zn.match('IN-ADDR.ARPA')
      hosts.each do |host|
        entries.push({"host" => host[0], "ttl" => "IN", "dns_class" => "A", "record" => host[1]["ip"]}) 
        if host[1].has_key?("cnames")
          host[1]["cnames"].each do |cname|
            entries.push({"host" => cname, "ttl" => "IN", "dns_class" => "CNAME", "record" => host[0]})
          end
        end
      end
    else
      hosts.each do |host|
        ## TODO: Very dirty, add support for multiple domains
        entries.push({"host" => host[1]["ip"].split(".")[3], "ttl" => "IN", "dns_class" => "PTR", "record" => "#{host[0]}.#{zones[0]}."})
      end  
    end
    
    # TODO: Only reset the serial if the file changes
    template "#{node["bind"]["dir"]}/db.#{zn}" do
      source "zone.db.erb"
      mode "0644"
      owner "root"
      variables({:zone => zn, :records => entries})
      group "root"
      notifies :restart, "service[#{node["bind"]["service"]}]"
    end
  end
## TODO: Support other methods of populating databases
else
  Chef::Log.warn("This recipe only supports using databags.")
end

template "#{node["bind"]["dir"]}/named.conf.options" do
  source "named.conf.options.erb"
  mode "0644"
  owner "root"
  group "root"
  notifies :restart, "service[#{node["bind"]["service"]}]"
end 

service node["bind"]["service"] do
  action [:enable, :start]
end

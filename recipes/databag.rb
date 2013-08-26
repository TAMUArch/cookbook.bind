
zones = data_bag(node[:bind][:data_bag])
if zones.empty?
  Chef::Log.error("Data bag is empty")
end

zones.each do |zone|


end
if !domains.empty?
  domains.each do |domain|
    domain_info = data_bag_item(node[:bind][:data_bag], domain)
    node.set[:bind][:serial] = domain_info["seed"]
    zones = Array.new
    zones.push(domain_info["id"])
    zones.push(domain_info["network"].split(".")[0..-2].reverse.join(".")+".IN-ADDR.ARPA")
    node.set[:bind][:zones]=zones

    node.set[:bind][:nameservers] = domain_info["nameservers"]
    template "#{node[:bind][:dir]}/named.conf.local" do
      source "named.conf.erb"
      mode "0644"
      group "root"
      owner "root"
      notifies :reload, "service[#{node[:bind][:service]}]"
    end

    # Populates the entries in the db files
    zones.each do |zn|
      entries = Hash.new 

      hosts = domain_info["hosts"] 
      # TODO: Add abilities to handle different records
      # Check if address is PTR or A/CNAME
      if !zn.match('IN-ADDR.ARPA')
        hosts.each do |host|
          entries = {host[0] => { "ttl" => "IN", "dns_class" => "A", "record" => host[1]["ip"]}} 
          if host[1].has_key?("cnames")
            host[1]["cnames"].each do |cname|
              entries = {cname => { "ttl" => "IN", "dns_class" => "CNAME", "record" => host[0]}}
            end
          end
        end
      else
        hosts.each do |host|
          ## TODO: Very dirty, add support for multiple domains
          entries = {host[1]["ip"].split(".")[3] =>{ "ttl" => "IN", "dns_class" => "PTR", "record" => "#{host[0]}.#{zones[0]}."}}
        end  
      end

      bind_zone zn do
        records entries
      end
    end
  end
## TODO: Support other methods of populating databases
else
  Chef::Log.warn("This recipe only supports using databags.")
end

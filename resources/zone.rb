actions :create, :delete, :reverse
default_action :create

attribute :zone_name, kind_of: String, name_attribute: true
attribute :nameservers, kind_of: Array
attribute :network, kind_of: String
attribute :records, kind_of: Hash, required: true
attribute :refresh_time, kind_of: String
attribute :retry_time, kind_of: String
attribute :expire_time, kind_of: String
attribute :cache_minimum, kind_of: String
attribute :serial, kind_of: String

require File.expand_path('../helpers.rb', __FILE__)

describe 'bind_test::default' do
  include Helpers::BindTest

  it 'installs the bind package' do
    case node[:platform]
    when 'debian', 'ubuntu'
      package('bind9').must_be_installed
    when 'redhat', 'centos', 'scientific'
      package('bind').must_be_installed
    end
  end

  it 'starts the bind service' do
    service('named').must_be_running
  end
end

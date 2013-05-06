module Helpers
  module BindTest
    require 'minitest/spec'
    include MiniTest::Chef::Assertions
    include MiniTest::Chef::Context
    include MiniTest::Chef::Resources
  end
end

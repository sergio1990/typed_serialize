ActiveRecord::Schema.define(:version => 0) do

  create_table :mice, :force => true do |t|
    t.text :info
    t.text :package
  end

end

class Mouse < ActiveRecord::Base

  typed_serialize :info, Hash, :price, :color
  typed_serialize :package, Hash, :wire, :battery, :prefix=>true

  serialized_accessor :manufacture, :material, :in=>:info

  serialized_reader :used, :port_type, :in=>:info

  serialized_writer :size, :weight, :in=>:info

  serialized_accessor :manual, :in=>:package, :prefix=>true

end

FactoryGirl.define do
  factory :mouse do
    color 'white'
    price 12
  end
end
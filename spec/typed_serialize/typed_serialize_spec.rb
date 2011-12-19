require 'spec_helper'

describe ActiveRecord::Base do

  it 'should generate default value' do
    mouse = Mouse.new
    mouse.info.should == {}
    mouse = Mouse.new
    mouse.info[:foo] = "master"
    mouse.info.should == {:foo=>'master'}
    test_hash = {:price=>23, :color=>'Gray', :material=>'Plastic'}
    mouse = Mouse.new(test_hash)
    mouse.info.should == test_hash
  end

  it 'should recover from factories' do
    attrs = {:color=>%w{blue green violet}, :price=>12, :manufacture=>[{:usa=>"NY", :france=>"Paris", :russia=>"Moscow"}]}
    Factory(:mouse, attrs)
    Mouse.first.info.should == attrs
  end

  it 'should allow serialized accessors' do
    mouse = Mouse.new
    mouse.manufacture = "A4Tech"
    mouse.info.should == {:manufacture=>'A4Tech'}
  end

  it 'should allow serialized reader' do
    mouse = Mouse.new
    mouse.used.should be_nil
    mouse.info[:used] = true
    mouse.used.should be_true
  end

  it 'should allow serialized writer' do
    test_hash = {:size=>'Large', :weight=>'122 gr'}
    mouse = Mouse.new(test_hash)
    mouse.info.should == test_hash
  end

  it 'allow prefix' do
    mouse_hash = {:package_manual=>true, :package_battery=>"12V"}
    Mouse.create(mouse_hash)
    Mouse.last.package.should == mouse_hash
  end

end
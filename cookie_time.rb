require 'pry'

class Oven

  def initialize
    @baking_tray = []
  end

  def put_batch_in_oven(batch)
    # oven takes 2 batches top
    @baking_tray << batch if @baking_tray.count <= 2
  end

  def bake!(time = 10.0)
    @baking_tray.each { |batch| batch.baked_time += time }
  end

  # returns an array of statuses
  def batch_statuses
    @baking_tray.map { |batch| batch.status }
  end

  # removes everything from oven
  def unload
    @baking_tray.pop(@baking_tray.count)
  end

end

class CookieBatch

  attr_accessor :baked_time
  def initialize
    @baking_time = 10.0
    @baked_time = 0.0
  end

  def status
    case percent_done
    when 0...75 then :doughy
    when 75...90 then :almost_ready
    when 90..100 then :done
    else :burned
    end
  end

  private

  def percent_done
    ((@baked_time / @baking_time) * 100).round
  end

end

class OatmealRaisinCookieBatch < CookieBatch

  def initialize
    super
    @baking_time = 40.0
  end

end

#binding.pry

# testing
require 'rspec'

describe Oven do

end

describe CookieBatch do

  before(:each) do
    @batch = CookieBatch.new
  end

  it 'should not be baked when it is made' do
    @batch.baked_time.should == 0
    @batch.status.should == :doughy
  end

  it 'shoud return credible statuses' do
    @batch.stub(:percent_done).and_return(10)
    @batch.status.should == :doughy
    @batch.stub(:percent_done).and_return(80)
    @batch.status.should == :almost_ready
    @batch.stub(:percent_done).and_return(93)
    @batch.status.should == :done
    @batch.stub(:percent_done).and_return(200)
    @batch.status.should == :burned
  end

end

describe 'A day at the bakery' do

  before(:each) do
    @batch = CookieBatch.new
    @oven = Oven.new
  end

  it 'should be a smooth ride' do
    @oven.put_batch_in_oven(@batch)
    @oven.batch_statuses.should == [:doughy]

    @oven.bake!(8)
    @oven.batch_statuses.should == [:almost_ready]

    @oven.bake!(2)
    @oven.batch_statuses.should == [:done]

    @oven.bake!(2)
    @oven.batch_statuses.should == [:burned]
  end

  it 'should get multiple batches done' do
    @oatmeal_raisins = OatmealRaisinCookieBatch.new
    @oven.put_batch_in_oven(@oatmeal_raisins)

    @oven.bake!(30)

    @oven.put_batch_in_oven(@batch)
    @oven.bake!(5)
    @oven.batch_statuses.should == [:almost_ready, :doughy]

    @oven.bake!(5)
    @oven.batch_statuses.should == [:done, :done]
  end

end

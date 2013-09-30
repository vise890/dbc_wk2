class Vehicle

  WHEELS = 4

  def initialize(vehicle_args)
    @color = vehicle_args[:color]
    @wheels = WHEELS
  end

  def drive
    @status = :driving
  end

  def brake
    @status = :stopped
  end

  def needs_gas?
    return [true,true,false].sample
  end

  def honk
    'HOOOOOONK'
  end

  def rave_engine
    "Broooom Broooom" if @status == :stopped
  end

end

class Car < Vehicle

  attr_reader :trunk

  def initialize(car_args)
    super
    @trunk = []
  end

  def put_stuff_in_trunk(stuff)
    @trunk << stuff if @trunk.size < 3
  end

  def unload_trunk
    @trunk.pop(@trunk.size)
  end

end

class Bus < Vehicle

  WHEELS = 6

  attr_reader :passengers

  def initialize(bus_args)
    super(bus_args)
    @wheels = WHEELS
    @num_seats = bus_args[:num_seats]
    @fare = bus_args[:fare]
    @passengers=[]
  end

  def drive
    return self.brake if stop_requested?
    super
  end

  def admit_passenger(passenger,money)
    @passengers << passenger if money > @fare
  end

  def stop_requested?
    return [true,false].sample
  end

  def needs_gas?
    return [true,true,true,false].sample
  end

end

class Motorbike < Vehicle

  WHEELS = 2

  def initialize(motorbike_args)
    super
    @wheels = WHEELS
  end

  def drive
    super
    @speed = :fast
  end

  def needs_gas?
    return [true,false,false,false].sample
  end

  def weave_through_traffic
    @status = :driving_like_a_crazy_person
  end

end

### TESTING ###
require 'rspec'

describe Vehicle do

  before(:each) do
    @vehicle = Vehicle.new({ color: 'electric blue' })
  end

  it 'should be electric blue' do
    @vehicle.instance_variable_get(:@color).should == 'electric blue'
  end

  it 'should respond to the required mehtods' do
    @vehicle.should respond_to(:drive)
    @vehicle.should respond_to(:brake)
    @vehicle.should respond_to(:needs_gas?)
  end

  it 'should have 4 wheels' do
    @vehicle.instance_variable_get(:@wheels).should == 4
  end
  it 'should honk' do
    @vehicle.honk.should == 'HOOOOOONK'
  end

  it 'should be able to rave engine whenever appropriate' do
    @vehicle.drive
    @vehicle.rave_engine.should_not == 'Broooom Broooom'
    @vehicle.brake
    @vehicle.rave_engine.should == 'Broooom Broooom'
  end

  it 'shoud be driving when #drive is called' do
    @vehicle.drive.should == :driving
  end

  it 'should be stopped when #brake is called' do
    @vehicle.brake.should == :stopped
  end

  it 'should randomly need gas' do
    [true, false].should include(@vehicle.needs_gas?)
  end

end

describe Car do

  before(:each) do
    @car = Car.new({ color: 'wasabi green' })
  end

  it 'should be wasabi green' do
    @car.instance_variable_get(:@color).should == 'wasabi green'
  end

  describe 'the trunk of the car' do

    before(:each) do
      @car.put_stuff_in_trunk('bike')
      @car.put_stuff_in_trunk('groceries')
      @car.put_stuff_in_trunk('trekking gear')
    end

    it 'fit stuff into it' do
      @car.trunk.should == ['bike', 'groceries', 'trekking gear']
    end

    it 'should not accept stuff if it is full' do
      @car.put_stuff_in_trunk('jumbo jet')
      @car.trunk.should == ['bike', 'groceries', 'trekking gear']
    end

    it 'should be possible to unload it' do
      @car.unload_trunk.should == ['bike', 'groceries', 'trekking gear']
      @car.trunk.should be_empty
    end

  end

end

describe Bus do

  before(:each) do
    @bus = Bus.new({     color: 'sunshine yellow',
                        wheels: 6,
                     num_seats: 30,
                          fare: 2,
    })
  end

  it 'should be sunshine yellow' do
    @bus.instance_variable_get(:@color).should == 'sunshine yellow'
  end

  it 'should have 6 wheels' do
    @bus.instance_variable_get(:@wheels).should == 6
  end

  it 'should have 30 seats' do
    @bus.instance_variable_get(:@num_seats).should == 30
  end

  it 'should randomly return true or false when #stop_requested? is called' do
    [true, false].should include(@bus.stop_requested?)
  end

  it 'should be driving when #drive is called' do
    @bus.stub(:stop_requested?).and_return(false)
    @bus.drive.should == :driving
  end

  it 'should brake when a stop is requested' do
    @bus.stub(:stop_requested?).and_return(true)
    @bus.drive.should == :stopped
  end

  it 'should admit passengers if they have enough money' do
    @bus.admit_passenger('bob', 3).should == ['bob']
  end

  it 'should not admit passengers if they do not have money' do
    @bus.admit_passenger('rascal', 0).should == nil
  end

  it 'should brake when #brake is called' do
    @bus.brake.should == :stopped
  end

  it 'should randomly need gas' do
    [true, false].should include(@bus.needs_gas?)
  end

end

describe Motorbike do

  before(:each) do
    @motorbike = Motorbike.new({ color: 'fiery red' })
  end

  it 'should be fiery red' do
    @motorbike.instance_variable_get(:@color).should == 'fiery red'
  end

  it 'should have 2 wheels' do
    @motorbike.instance_variable_get(:@wheels).should == 2
  end

  it 'should drive when #drive is called. And it should be fast' do
    @motorbike.drive
    @motorbike.instance_variable_get(:@speed).should == :fast
    @motorbike.instance_variable_get(:@status).should == :driving
  end

  it 'should stop when #brake is called' do
    @motorbike.brake.should == :stopped
  end

  it 'should randomly need gas' do
    [true, false].should include(@motorbike.needs_gas?)
  end

  it 'should crazily drive through traffic' do
    @motorbike.weave_through_traffic.should == :driving_like_a_crazy_person
  end

end

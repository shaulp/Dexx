require 'spec_helper'

describe Template do
  before :each do
  	@template = Template.new name:"Temptest1"
  end

  subject { @template }

	describe "methods check" do
  	it { should respond_to(:name) }
  	it { should respond_to(:add_property) }
  	it { should respond_to(:remove_property) }
	end

	describe "when handling properties" do
		before do
			@template.add_property name:'test-prop1', type:'StringProperty'
		end
		it "should add a new property" do
	  	@template.properties.length.should eq(1)
	  end

	  it "should not add a duplicate property" do
	  	@template.add_property name:'test-prop1', type:'StringProperty'
  		expect(@template.properties.length).to eq(1)
		end

	  it "should not remove a non existant property" do
		  @template.remove_property 'non-existant-prop'
  		expect(@template.properties.length).to eq(1)
  	end

	  it "should remove a property" do
		  @template.remove_property 'test-prop1'
  		expect(@template.properties.length).to eq(0)
		end
	end

end

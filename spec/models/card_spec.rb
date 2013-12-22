require 'spec_helper'

describe Card do

  describe "basic model and validations:" do
	  before :each do
  		@card = Card.new
  		@template = Template.new name:'stam-template'
  		@template.save
  	end
  	it {should respond_to(:title)}
  	it {should respond_to(:template)}
  	it {should respond_to(:properties)}
  	it {should respond_to(:set)}
    it {should respond_to(:get)}

  	it "must have a title,template" do
  		@card.valid?.should be_false
  		@card.title = 'stam title'
  		@card.template = @template
  		@card.valid?.should be_true
  	end

  	describe "card properties behavior:" do
  		before :each do
  			@template.add_property name:'tp1', type:'StringProperty'
        @template.add_property name:'tp2', type:'DecimalProperty'
        @card.template = @template
        @card.title = 'stam title'
  		end
  		it "a card property must match a template property" do
  			@card.set 'stam-property', 'stam-value'
        @card.errors.should_not be_empty
        @card.errors.clear
  			@card.set 'tp1', 'some-value'
        @card.errors.should be_empty
  		end
      it "actual property value must be valid" do
        @card.set 'tp2', 'abcd'
        @card.errors.should_not be_empty
        @card.set 'tp2', 12.3
        @card.errors.should be_empty
      end
      it "can be saved with all properties" do
        @card.set 'tp1', 'some-value'
        @card.set 'tp2', 12.234
        @card.errors.should be_empty
        @card.save.should be_true

        @dbcard = Card.find(@card.id)
        @dbcard.get('tp1').should eq('some-value')
        @dbcard.get('tp2').should eq(12.234)
      end
  	end
  end
end

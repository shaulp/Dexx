require 'spec_helper'

describe Template do
  before { @template = Template.new(name: "Temptest1") }

  subject { @template }

  it { should respond_to(:name) }
  @template.add_property 'test-prop1', 'Properties::String'
  @template.save
end

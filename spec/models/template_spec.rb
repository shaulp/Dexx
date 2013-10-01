require 'spec_helper'

describe Template do
  before { @template = Template.new(name: "Temptest1") }

  subject { @template }

  it { should respond_to(:name) }
end

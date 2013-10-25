require 'spec_helper'

describe "cards/show" do
  before(:each) do
    @card = assign(:card, stub_model(Card,
      :template_id => "",
      :title => "",
      :properties => "MyText"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(//)
    rendered.should match(//)
    rendered.should match(/MyText/)
  end
end

require 'spec_helper'

describe "cards/edit" do
  before(:each) do
    @card = assign(:card, stub_model(Card,
      :template_id => "",
      :title => "",
      :properties => "MyText"
    ))
  end

  it "renders the edit card form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", card_path(@card), "post" do
      assert_select "input#card_template_id[name=?]", "card[template_id]"
      assert_select "input#card_title[name=?]", "card[title]"
      assert_select "textarea#card_properties[name=?]", "card[properties]"
    end
  end
end

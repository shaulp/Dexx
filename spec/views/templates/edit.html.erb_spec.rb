require 'spec_helper'

describe "templates/edit" do
  before(:each) do
    @template = assign(:template, stub_model(Template,
      :name => "MyString",
      :packed_properties => "MyText"
    ))
  end

  it "renders the edit template form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", template_path(@template), "post" do
      assert_select "input#template_name[name=?]", "template[name]"
      assert_select "textarea#template_packed_properties[name=?]", "template[packed_properties]"
    end
  end
end

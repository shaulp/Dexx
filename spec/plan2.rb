require_relative 'API/basic'

$verbose = true

exec { delete_template "Dec" } 
assert { create_template "Dec" }
tid = $resp["template"]["id"]
assert { add_prop_to_template tid, "CustomerID", "StringProperty", "Mandatory;Max-length:4" }
assert { remove_prop_from_template tid, "CustomerID" }
exit

exec { search_cards({"title" => "Joe", "Country" => "Israel"}) }
exit

if $resp["status"]=="ok"
	$resp["card"].each do |c|
		cid = c["id"]
		assert { delete_card cid }
	end
end

exec { delete_template "Customer" } 
assert { create_template "Customer" }

tid = $resp["template"]["id"]
assert { add_prop_to_template tid, "CustomerID", "StringProperty", "Mandatory;Max-length:4" }
assert { add_prop_to_template tid, "Name", "StringProperty", "Mandatory" }
assert { add_prop_to_template tid, "Country", "StringProperty", "List:<Israel><PRC>;Mandatory" }
assert { add_prop_to_template tid, "BeginDate", "DateProperty", ">2014-01-01" }

assert { create_card "Joe", "Customer" }
cid = $resp["card"]["id"]
assert { set_card_property cid, "Name", "Joe Shmoe" }
unsert { set_card_property cid, "Name", "" }
assert { set_card_property cid, "Country", "PRC" }
assert { set_card_property cid, "Country", "Israel" }

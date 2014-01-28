# API tests for Dexx
require_relative 'API/basic'

#tname = "test-template-"+rand_string(5)
#dexx_call { create_template tname }
#tid = $resp["template"]["id"]
#dexx_call (false) { add_prop_to_template tid, "dec", "DecimalProperty", "Max-length:3" }
#dexx_call { add_prop_to_template tid, "dec", "DecimalProperty", "<33" }
#dexx_call { add_prop_to_template tid, "str", "StringProperty", "Max-length:10" }
#dexx_call { add_prop_to_template tid, "dat", "DateProperty", "" }

$verbose=true
tname = "test-template-GKOLFO"
assert { get_template tname}
#unsert { get_template "fasdf" }
tid = $resp["template"]["id"]
#dexx_call { add_prop_to_template tid, "dat", "DateProperty", "" }

cname = "test-card-"+rand_string(5)
assert { create_card cname, tname }
cid = $resp["card"]["id"]
assert { set_card_property 22, "dat", "24-Jan-2014"}
#dexx_call(false) { set_card_property 22, "dat", "ShalomRavShuvech"}
#dexx_call(false) {set_card_property 22, "ll", "Sh"}
#puts $resp
#dexx_call {set_card_property 22, "ll", "bb"}
dexx_end


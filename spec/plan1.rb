# API tests for Dexx
require_relative 'API/basic'

#tname = "test-template-"+rand_string(5)
#dexx_call { create_template tname }
#tid = $resp["template"]["id"]
#dexx_call (false) { add_prop_to_template tid, "dec", "DecimalProperty", "Max-length:3" }
#dexx_call { add_prop_to_template tid, "dec", "DecimalProperty", "<33" }
#dexx_call { add_prop_to_template tid, "str", "StringProperty", "Max-length:10" }
#dexx_call { add_prop_to_template tid, "dat", "DateProperty", "" }

tname = "test-template-GKOLFO"
dexx_call { get_template tname}
tid = $resp["template"]["id"]
#dexx_call { add_prop_to_template tid, "str", "StringProperty", "Max-length:10" }
cname = "test-card-"+rand_string(5)
dexx_call { create_card cname, tname }
cid = $resp["card"]["id"]
dexx_call { set_card_property cid, "str", "abcd"}
dexx_end


require_relative 'API/basic'

$verbose = true
unsert { delete_template "Customer" }
assert { create_template "Customer" }

tid = $resp["template"]["id"]
assert { add_prop_to_template tid, "CustomerID", "StringProperty", "Max-length:4" }
assert { add_prop_to_template tid, "Name", "StringProperty", "" }
assert { add_prop_to_template tid, "Country", "StringProperty", "" }
assert { add_prop_to_template tid, "BeginDate", "DateProperty", ">'2014-01-01'" }

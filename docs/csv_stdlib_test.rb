# encoding: utf-8

require 'csv'
require 'pp'



begin
  CSV.parse( %{1, "2"})
rescue CSV::MalformedCSVError => ex
  pp ex
end
# => #<CSV::MalformedCSVError: Illegal quoting in line 1.>

begin
  CSV.parse( %{"3" , 4})
rescue CSV::MalformedCSVError => ex
  pp ex
end
# => #<CSV::MalformedCSVError: Unclosed quoted field on line 1.>

pp CSV.parse( %{"","",,} )
# => ["", "", nil, nil]

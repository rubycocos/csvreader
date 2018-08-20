

class CsvReader
####################
# helper methods
def self.unwrap( row_or_array )   ## unwrap row - find a better name? why? why not?
  ## return row values as array of strings
  if row_or_array.is_a?( CSV::Row )
    row = row_or_array
    row.fields   ## gets array of string of field values
  else  ## assume "classic" array of strings
    array = row_or_array
  end
end

end # class CsvReader

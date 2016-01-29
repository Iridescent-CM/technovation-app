require "csv"

hist = Hash.new(0)

CSV.foreach("/Users/mlarsson/Downloads/2016-01-28.tsv", { :col_sep => "\t", :quote_char => "\x00" }) do |row|
  msg = row[9]
  timestamp = DateTime.parse(row[1])
  if msg.include? "code=H12"
    hist[timestamp.strftime("%H")] += 1
  end
end

print hist
rules_dir = File.join(File.absolute_path(File.dirname(__FILE__)),'check_out','rules').to_s
Dir.glob("#{rules_dir}/*.rb").each do |rule_file|
  require rule_file
end

class CheckOut
  def initialize(rules)
    @items = rules[:items]
    @scanned = {}
    @specials = create_specials(rules[:specials])
  end
  
  def scan(product_code)
    scanned[product_code] ||= 0
    scanned[product_code] += 1
  end
  
  def total
    running_total = 0
    scanned_items = scanned.clone
    specials.each do |special|
      scanned_items, running_total = special.apply(scanned_items, running_total)
    end
    #go through the rest of the items and calc the cost left over
    scanned_items.each do |item_code, price|
      running_total += items[item_code]*price
    end
    running_total
  end
  
  protected
  attr_reader :items, :specials, :scanned
  
  def create_specials(specials)
    specials.collect do |special_config|
      rules_class = CheckOut::Rules.const_get(special_config[:type])
      rules_class.new(special_config[:args]) if rules_class
    end
  end
end
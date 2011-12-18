class CheckOut
  module Rules
    class XForY
      def initialize(args)
        # This would be the place to put checks for correctness of config related to this rule
        # ActiveModle::Validations provides an excelent way to do this
        @number = args[:number]
        @item_code = args[:item_code]
        @price = args[:price]
      end
      
      def apply(scanned_items, running_total)
        items = scanned_items[item_code]
        special_cost = 0
        if(items)
          special_cost = (items/number) * price
          #remove those items used in this special
          scanned_items[item_code] = (items%number)
        end
        return scanned_items, special_cost+running_total
      end
      
      protected
      attr_reader :number, :item_code, :price
    end
  end
end
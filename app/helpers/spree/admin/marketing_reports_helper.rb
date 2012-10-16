module Spree
  module Admin

    module MarketingReportsHelper
      
      def has_variant_purchase?(landing_page_entry)
        if !landing_page_entry.nil? && !landing_page_entry.hash.nil? && landing_page_entry.hash.size > 0
          return true
        else
          return false
        end
      end
      
      def print_landing_page_variants(landing_page_entry, variant_limit)
        ret_str = ""
        
        if landing_page_entry.nil? || landing_page_entry.hash.nil? || landing_page_entry.hash.size == 0
          icount = 0   
          while icount < variant_limit  do
            ret_str += "<td></td>"
            icount += 1
          end               
        else
        
          ret_str = ""
          variants_array = landing_page_entry.hash.sort_by {|k,v| v[:product_amount]}.reverse
          icount = 0
          variants_array.each do |variant_a|
            break if !variant_limit.nil? && variant_limit > 0 && icount >= variant_limit 
            variant = Spree::Variant.find variant_a[0]
            ret_str += "<td><font color='green'>#{variant.name_with_options_text}</font></td>"
            icount += 1 
          end
          if icount < variant_limit
            
          end
          
          while icount < variant_limit  do
            ret_str += "<td></td>"
            icount += 1
          end
          
          ret_str += "</tr><tr>"
          
          icount = 0
          variants_array.each do |variant_a|
            break if !variant_limit.nil? && variant_limit > 0 && icount >= variant_limit
            ret_str += "<td>#{variant_a[1][:product_amount]}</td>"
            icount += 1 
          end
          while icount < variant_limit  do
            ret_str += "<td></td>"
            icount += 1
          end

        end        
        return ret_str.html_safe
      end
      
    end

  end
end
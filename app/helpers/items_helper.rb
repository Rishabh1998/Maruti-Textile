module ItemsHelper
def categories_for_select
    ItemCategory.all.pluck(:name, :id).to_a
  end

  def subcategories_for_select
    ItemSubcategory.all.pluck( :name, :id).to_a
  end

  def items_for_select
    Item.includes(:item_category, :item_subcategory).all.collect{|item| ["#{item.name} (#{item.item_category.name}-#{item.item_subcategory.name})", item.id]}
  end
end
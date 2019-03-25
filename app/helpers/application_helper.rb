module ApplicationHelper
  def capitalized_name
    name.capitalize
  end

  def enabled_status
    enabled? ? 'Enabled' : 'Disabled'
  end

  def published_status
    published? ? 'Published' : 'Unpublished'
  end

  def default_status
    default? ? 'Default' : '-'
  end

  def caroobi_scores_for_select
    [1, 2, 3, 4, 5]
  end

  def max_distance_for_select
    [["5km", 5], ["10km", 10], ["15km", 15], ["30km", 30], ["50km", 50], ["100km", 100], ["Any", 50000]]
  end

  def states_for_select
    State.all.collect { |state| [state.localized_name, state.id] }
  end

  def regions_for_select(key = 'state-id')
    Region.region.all.collect { |region| [region.localized_name, region.id, { data: { 'state-id' => region.state_id } }] }
  end

  def cities_for_select(key = 'state-id')
    Region.city.collect { |city| [city.localized_name, city.id, { data: { key => city.state_id } }] }
  end

  def to_price(price)
    if price.present?
      sprintf('%.2f', price)
    end
  end

  def payment_mode_with_code_for_select
    PaymentMode.all.collect { |pm| [pm.name, pm.code] }
  end
end
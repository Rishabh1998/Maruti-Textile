Ransack.configure do |config|
  # ransack scope for datetime field compare with date
  config.add_predicate 'timetodate_lteq',
                       arel_predicate: 'lteq',
                       formatter: proc { |v| v.to_date.end_of_day },
                       validator: proc { |v| v.present? },
                       type: :string

  # ransack scope for datetime field compare with date
  config.add_predicate 'timetodate_gteq',
                       arel_predicate: 'gteq',
                       formatter: proc { |v| v.to_date.beginning_of_day },
                       validator: proc { |v| v.present? },
                       type: :string



  # ransack sorting arrows
  config.custom_arrows = {
      up_arrow: '<img src="/feedr/assets/sort.png" class="sort-icon">',
      down_arrow: '<img src="/feedr/assets/sort.png" class="sort-icon">',
      default_arrow: '<img src="/feedr/assets/sort.png" class="sort-icon">'
  }


end

# All cached data here!
# Author: Raj
class CachedData
  class << self

    # Gets and loads lead management params in memory
    #
    # Author:: Raj
    # Date:: 22/08/2017
    # Reviewed By::
    #
    def lead_management_params
      Memcache.fetch("lead_management_params", 15.minute.to_i) do
        params_by_id = {}
        records = LeadManagementParameter.select(:product_id, :key, :value)
        records.each do |record|
          params_by_id[record.product_id] = {} if params_by_id[record.product_id].nil?
          params_by_id[record.product_id][record.key] = record.value
        end

        params_by_id
      end
    end

    # Gets and loads lead minimum factor in memory
    #
    # Author:: Raj
    # Date:: 13/09/2017
    # Reviewed By::
    #
    def minimum_pp_index_factor
      Memcache.fetch("minimum_pp_index_factor", 1.hour.to_i) do
        AreaPurchasingPower.where.not(factor: :desc).order(factor: :asc).limit(1).pluck(:factor).first.to_f
      end
    end

    # Gets and loads record types in memory
    #
    # Author:: Raj
    # Date:: 18/09/2017
    # Reviewed By::
    #
    def record_types_by_name
      Memcache.fetch("record_types", 1.hour.to_i) do
        RecordType.all.group_by(&:name)
      end
    end

    # Gets and loads products by code in memory
    #
    # Author:: Raj
    # Date:: 18/09/2017
    # Reviewed By::
    #
    def products_by_code
      Memcache.fetch("record_types", 1.hour.to_i) do
        Product.all.group_by(&:code)
      end
    end

    # Gets and loads products in memory
    #
    # Author:: Raj
    # Date:: 24/04/2018
    # Reviewed By::
    #
    def active_products
      Memcache.fetch("active_products", GlobalConstant::PRODUCT_INVALIDATION_TIME.to_i.minute.to_i) do
        Product.includes(:product_category,:product_subcategory).active
            .select(:id, :localized_name, :permalink, :product_category_id, :product_subcategory_id, :code,
                    :pricing_enabled, :show_price_before_lead)
            .where.not(:localized_name => nil).order('-popular_service_rank desc, localized_name')
            .group_by{ |item| item[:localized_name].mb_chars.upcase.to_s}
      end
    end

    # Gets and loads maintenance_model_brand_faimly_price
    #
    # Author:: Raj Kumar Saini
    # Date:: 14/11/2017
    # Reviewed By::
    #
    def maintenance_model_brand_faimly_price
      Memcache.fetch("maintenance_model_brand_faimly_price", 1.hour.to_i) do
        data = {}
        MaintenanceModelBrandFamilyPricing.all.each do |pwt|
          data["#{pwt.pricing_type}_#{pwt.value}"] = pwt.price_base
        end
        data
      end
    end

    # Gets and loads detail_level_oil_type_mapping
    #
    # Author:: Raj Kumar Saini
    # Date:: 14/11/2017
    # Reviewed By::
    #
    def detail_level_oil_type_mappings
      Memcache.fetch("detail_level_oil_type_mappings", 1.hour.to_i) do
        data = {}
        PricingReplaceMotorOilAndFilter.all.each do |pwt|
          data["#{pwt.detail_level.downcase}_#{pwt.detail_value.downcase}"] = {oil_type: pwt.oil_type, liters: pwt.liters}
        end
        data
      end
    end


    #######################
    ## Landing Page Data ##
    #######################

    # Gets and loads templates in memory
    #
    # Author:: Raj
    # Date:: 02/01/2018
    # Reviewed By::
    #
    def template_by_path
      Memcache.fetch("template_by_path", GlobalConstant::LANDING_PAGE_INVALIDATION_TIME.minute.to_i) do
        Template.active.group_by(&:path)
      end
    end

    # Gets and loads urls in memory
    #
    # Author:: Raj
    # Date:: 02/01/2018
    # Reviewed By::
    #
    def url_by_path_and_uid
      Memcache.fetch("url_by_path_and_uid", GlobalConstant::LANDING_PAGE_INVALIDATION_TIME.minute.to_i) do
        Url.active.group_by { |u| "#{u.path}-#{u.uid}" }
      end
    end

    # Gets and loads hiw in memory
    #
    # Author:: Raj
    # Date:: 02/01/2018
    # Reviewed By::
    #
    def hiw_by_tag(tags = 0)
      Memcache.fetch("hiw_by_tag_#{tags}", GlobalConstant::LANDING_PAGE_INVALIDATION_TIME.minute.to_i) do
        HowItWorks.select(:id,:heading,:description).from(
            HowItWorks.where(:tag => tags).order(:priority, tag: :desc), :contents).group(:priority).limit(4)
      end
    end

    # Gets and loads hiw images in memory
    #
    # Author:: Raj
    # Date:: 02/01/2018
    # Reviewed By::
    #
    def hiw_image_by_hiw_id
      Memcache.fetch("hiw_image_by_hiw_id", GlobalConstant::LANDING_PAGE_INVALIDATION_TIME.minute.to_i) do
        HowItWorksImage.all.group_by(&:imagable_id)
      end
    end

    # Gets and loads loc mobile images in memory
    #
    # Author:: Raj
    # Date:: 02/01/2018
    # Reviewed By::
    #
    def loc_mobile_image_by_loc_id
      Memcache.fetch("loc_mobile_image_by_loc_id", GlobalConstant::LANDING_PAGE_INVALIDATION_TIME.minute.to_i) do
        LocationMobileImage.all.group_by(&:imagable_id)
      end
    end

    # Gets and loads loc desktop images in memory
    #
    # Author:: Raj
    # Date:: 02/01/2018
    # Reviewed By::
    #
    def loc_desktop_image_by_loc_id
      Memcache.fetch("loc_desktop_image_by_loc_id", GlobalConstant::LANDING_PAGE_INVALIDATION_TIME.minute.to_i) do
        LocationDesktopImage.all.group_by(&:imagable_id)
      end
    end

    # Gets and loads usp in memory
    #
    # Author:: Raj
    # Date:: 02/01/2018
    # Reviewed By::
    #
    def usp_by_tag(tags = 0)
      Memcache.fetch("usp_by_tag_#{tags}", GlobalConstant::LANDING_PAGE_INVALIDATION_TIME.minute.to_i) do
        Usp.select(:id,:heading,:description).from(
            Usp.active.where(:tag => tags).order(:priority, tag: :desc), :contents
        ).group(:priority).limit(GlobalConstant::USP_LIMIT)
      end
    end

    # Gets and loads assets in memory
    #
    # Author:: Raj
    # Date:: 02/01/2018
    # Reviewed By::
    #
    def assets_by_tag_and_widgets(tags, widget_ids)
      Memcache.fetch("assets_by_tag_#{tags}", GlobalConstant::LANDING_PAGE_INVALIDATION_TIME.minute.to_i) do
        Asset.active.joins("JOIN (SELECT widget_id, name, MAX(tag) AS tag FROM assets WHERE status = 1 AND widget_id IN "\
        "(#{widget_ids}) AND tag IN (#{tags}) GROUP BY widget_id, name)maxtag "\
        "ON assets.widget_id = maxtag.widget_id AND assets.name = maxtag.name AND assets.tag = maxtag.tag")
      end
    end

    # Gets and loads user reviews in memory
    #
    # Author:: Raj
    # Date:: 02/01/2018
    # Reviewed By::
    #
    def user_reviews
      Memcache.fetch("user_reviews", GlobalConstant::LANDING_PAGE_INVALIDATION_TIME.minute.to_i) do
        UserReview.active.order("-rank desc").limit(10)
      end
    end

  end
end
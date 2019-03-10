module ApplicationControllerHelper
  private
  def set_flash_notification(type, kind, options = {})
    message = options[:message] || t("flash.#{ type }.#{ kind }", options)
    flash[type] = message if message.present?
  end

  def set_instant_flash_notification(type, kind, options = {})
    message = options[:message] || t("flash.#{ type }.#{ kind }", options)
    flash.now[type] = message if message.present?
  end

  def set_flash_errors(resource, type = :error)
    flash[type] = resource.errors.full_messages.join("<br>")
  end
end

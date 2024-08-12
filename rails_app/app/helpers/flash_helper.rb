# frozen_string_literal: true

module FlashHelper
  def flash_messages
    messages = []
    flash.each do |key, message|
      next if message.blank?

      css_class = case key.to_s
                  when 'notice' then 'bg-green-50 text-green-500'
                  when 'warning' then 'bg-yellow-50 text-yellow-500'
                  when 'alert' then 'bg-red-50 text-red-500'
                  else 'bg-gray-50 text-gray-500'
                  end

      messages << content_tag(:div, message,
                              class: "py-2 px-3 mb-5 font-medium rounded-lg flex flex-row w-full #{css_class}")
    end
    return if messages.blank?

    messages.join.html_safe
  end
end

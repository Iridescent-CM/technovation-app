module FilestackHelper
  # Partials that render upload UI must call enable_filestack! at the top.
  # See spec/views/filestack_upload_partials_spec.rb when adding a new one.
  def enable_filestack!
    controller.needs_filestack!
  end

  # Turbo-safe replacement for filestack-rails' filestack_js_init_tag.
  # Security options are not configured in this app; v3 init matches the gem's {cname: ...} output.
  def filestack_js_deferred_init_tag
    config = Rails.application.config.filestack_rails
    client_name = config.client_name
    init_call = "filestack.init(#{config.api_key.to_json}, #{{cname: config.cname}.to_json})"
    javascript_tag(<<~JS)
      (function () {
        function initFilestack() { window.#{client_name} = #{init_call}; }
        if (typeof filestack !== "undefined") {
          initFilestack();
        } else {
          var s = document.querySelector('script[src*="filestack"]');
          (s || window).addEventListener("load", initFilestack);
        }
      })();
    JS
  end
end

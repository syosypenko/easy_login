module RedmineOmniauth2Google
  class Hooks < Redmine::Hook::ViewListener
    def view_account_login_bottom(context = {})
      context[:controller].send(:render_to_string, {
        :partial => "hooks/view_account_login_bottom",
        :locals => context})
    end

    def view_layouts_base_body_bottom(context = {})
      context[:controller].send(:render_to_string, {
        :partial => "hooks/view_users",
        :locals => context})
    end
  end
end

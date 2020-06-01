require 'redmine'
require_dependency 'easy_login/hooks'

Redmine::Plugin.register :easy_login do
  name 'Easy Login plugin'
  author 'Serhiy Yosypenko'
  description 'Easy login into Redmine for testing'
  version '0.0.1'
  url 'https://github.com/syosypenko/easy_login'
  author_url 'https://github.com/syosypenko/'
end

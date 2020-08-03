FROM ruby
RUN apt-get -y update && apt-get -y install libicu-dev git cmake
# 使用中国镜像
RUN gem sources --add https://gems.ruby-china.com/ --remove https://rubygems.org/
# 安装gollum
RUN gem install gollum
RUN gem install github-markdown org-ruby
RUN gem install gollum-rugged_adapter
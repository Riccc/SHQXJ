FROM ruby:3.1.4

# 检查 /etc/apt 目录下的文件
RUN ls /etc/apt/

# 创建 /etc/apt/sources.list 文件
RUN echo "deb http://deb.debian.org/debian bookworm main" > /etc/apt/sources.list

# 更换为清华镜像源并清理缓存
RUN sed -i 's|http://deb.debian.org/debian|https://mirrors.tuna.tsinghua.edu.cn/debian|g' /etc/apt/sources.list && \
    rm -rf /var/lib/apt/lists/* && \
    apt-get clean

# 安装系统依赖与证书
RUN apt-get update -qq && \
    apt-get install -y --no-install-recommends \
    build-essential \
    libmariadb-dev-compat \
    libmariadb-dev \
    nodejs \
    curl \
    ca-certificates && \
    update-ca-certificates && \
    rm -rf /var/lib/apt/lists/*

# 安装缺少的 GPG 密钥
#RUN curl -sSL https://rvm.io/mpapis.asc | gpg --import - && \
#    curl -sSL https://rvm.io/pkuczynski.asc | gpg --import -

# 安装 RVM（Ruby Version Manager）
#RUN curl -sSL https://get.rvm.io | bash -s stable

# 使用 RVM 安装 Ruby
#RUN bash -l -c "rvm install ruby-3.1.4"

# 设置 Ruby 版本
#RUN bash -l -c "rvm use ruby-3.1.4 --default"

# 设置 RubyGems 使用 Ruby-China 镜像
RUN gem install bundler

# 设置工作目录
WORKDIR /app

# 复制 Gemfile 并安装 gems
COPY Gemfile Gemfile.lock ./
RUN bundle install

# 复制项目文件
COPY . .

# 启动脚本
CMD ["bash", "-c", "rm -f tmp/pids/server.pid && bundle exec rails s -b 0.0.0.0"]

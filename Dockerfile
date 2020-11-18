FROM ruby:2.7.2

RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
RUN apt-get update -qq \
	&& apt-get install -y --no-install-recommends \
	apt-utils \
	build-essential \
	nano \
	nodejs \
	yarn

ENV APP_HOME /usr/src/app
RUN mkdir $APP_HOME
WORKDIR $APP_HOME

RUN gem install bundler:2.1.4
ADD Gemfile* $APP_HOME/
RUN bundle install

ADD . $APP_HOME
RUN yarn install --check-files

RUN export EDITOR=vi
RUN export SECRET_KEY_BASE=$(rails credentials:edit --environment production)
RUN export RAILS_ENV=production bundle exec rake assets:precompile

EXPOSE 3000 3035

CMD ["rails", "server", "-b", "0.0.0.0"]
FROM ruby:2.6

RUN bundle config --global frozen 1

WORKDIR /usr/src/app

COPY Gemfile Gemfile.lock ./
RUN bundle install --without test

COPY ./lib .
ENV APP_ENV=production

CMD ["ruby", "./deployment_status_slack_notifier.rb", "-o", "0.0.0.0"]

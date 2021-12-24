FROM ruby:3.0.3
USER root
RUN mkdir -p /app/src
WORKDIR /app/src
COPY . .
RUN bundle install

CMD ["ruby", "street_ranker.rb"]
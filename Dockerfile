FROM ruby:latest
WORKDIR /usr/src/app/
ADD . /usr/src/app/
RUN bundle install
EXPOSE 4567
CMD ["ruby","app.rb","-o", "0.0.0.0"]

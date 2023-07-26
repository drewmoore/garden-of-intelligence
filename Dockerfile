# *******************
# Stage base
FROM ruby:3.1.2-alpine as base_stage
ENV RAILS_LOG_TO_STDOUT=1
ENV LANG C.UTF-8
# Install only production dependencies by default. Provide empty value as build arg to allow non-prod dependencies
# Leave this in the base stage so that Rails also reads this value to do its magic with dependencies
ARG BUNDLE_WITHOUT=development:test
ENV BUNDLE_WITHOUT $BUNDLE_WITHOUT

RUN set -eux; \
    apk add --update --no-cache \
    tzdata \
    gcompat \
    bash \
    curl \
    # Needed for postgres gem
    libpq-dev
ARG USERNAME=rails
ENV USERNAME $USERNAME	
RUN adduser -D -H ${USERNAME} ${USERNAME}
ENV HOMEDIR /home/${USERNAME}
ENV WORKDIR ${HOMEDIR}/app
WORKDIR ${WORKDIR}
RUN chown $USERNAME:$USERNAME ${HOMEDIR}
COPY --chown=${USERNAME}:${USERNAME} Gemfile Gemfile.lock ./

# Stage bundle
# Install packages and avoid leaving auth tokens for private packages in history (i.e. docker history <IMAGE_NAME>)
FROM base_stage as bundle
RUN set -eux; \
    apk add --update --no-cache \
    build-base

RUN gem install bundler -v 2.3.12 && \
    gem cleanup bundler
RUN bundle install 
# --jobs "$(getconf _NPROCESSORS_ONLN)"

# Stage: Final
FROM base_stage
COPY --chown=${USERNAME}:${USERNAME} --from=bundle ${GEM_HOME} ${GEM_HOME}
COPY --chown=${USERNAME}:${USERNAME} . ${WORKDIR}
USER ${USERNAME}:${USERNAME}
EXPOSE 3000
CMD bundle exec rails server -b "0.0.0.0" -p 3000
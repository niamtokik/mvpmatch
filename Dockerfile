FROM elixir:1.15 as builder
ENV APP=mvpmatch
ENV MIX_ENV=prod
WORKDIR /app
RUN mix do local.hex --force, local.rebar --force
COPY mix.exs mix.lock ./
RUN mkdir config
COPY config/config.exs config/prod.exs config/runtime.exs config/
COPY priv priv
COPY lib lib
COPY rel rel
COPY README.md ./
RUN mix do deps.get, compile, release

FROM elixir:1.15-slim
ENV APP=mvpmatch
ENV MIX_ENV="prod"
WORKDIR /app
RUN chown -R nobody /app
COPY --from=builder --chown=nobody:root /app/_build/${MIX_ENV}/rel/${APP} ./
USER nobody
CMD ["/app/bin/server"]

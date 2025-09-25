# https://hub.docker.com/r/chatwoot/chatwoot/tags
FROM chatwoot/chatwoot:v4.6.0

RUN apk add --no-cache multirun postgresql-client nodejs npm

# Instalar pnpm
RUN npm install -g pnpm
ENV NODE_OPTIONS=--max-old-space-size=8192


# Instalar dependencias extra que Railway añadía
RUN apk add --no-cache multirun postgresql-client

# Establecer directorio de trabajo
WORKDIR /app

# Copiar tu archivo modificado sobre el existente en la imagen
COPY ./app/javascript/dashboard/components/buttons/ResolveAction.vue ./app/javascript/dashboard/components/buttons/ResolveAction.vue

# Variables de entorno necesarias para Rails
ENV RAILS_ENV=production \
    NODE_ENV=production \
    SECRET_KEY_BASE=dummykeyfordockerbuild

# Recompilar assets para que se apliquen los cambios en el frontend
RUN bundle exec rails assets:precompile

# Copiar script de arranque (asegúrate de tenerlo en tu repo/proyecto)
COPY --chmod=755 start.sh /start.sh

ENTRYPOINT ["/bin/sh"]
CMD ["/start.sh"]
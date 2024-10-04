FROM node:10 AS ui-build
WORKDIR /usr/src/app
COPY my-app/ ./my-app/
RUN cd my-app && npm install && npm run build

FROM node:10 AS server-build
WORKDIR /root/
COPY --from=ui-build /usr/src/app/my-app/build ./my-app/build
COPY api/package*.json ./api/
RUN cd api && npm install
COPY api/server.js ./api/

FROM node:10-alpine AS final
RUN mkdir -p /var/run && chown -R node:node /var/run
USER node
WORKDIR /var/run
COPY --from=ui-build /usr/src/app/my-app/build ./my-app/build
COPY --from=server-build /root/api/ ./api/



EXPOSE 3080

CMD ["node", "./api/server.js"]
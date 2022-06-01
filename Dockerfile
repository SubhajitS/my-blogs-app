FROM node:14.18.1-alpine as builder
WORKDIR /usr/src

COPY ./ /usr/src/
RUN npm ci
RUN npm run build

FROM node:14.18.1-alpine as runner
EXPOSE 3000
WORKDIR /nextjs
ENV NODE_ENV production

COPY --from=builder /usr/src/public/ /nextjs/public
COPY --from=builder /usr/src/.next/  /nextjs/.next
COPY --from=builder /usr/src/node_modules /nextjs/node_modules
COPY --from=builder /usr/src/package.json /nextjs/package.json

CMD echo "20.187.121.32 sccm.dev.local" >> /etc/hosts
ENTRYPOINT ["npm", "run", "next:start"]

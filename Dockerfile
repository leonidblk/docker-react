# First block
FROM node:16-alpine as builder
WORKDIR '/app'
COPY package.json .

# Resolve npm certification error
RUN npm config set strict-ssl=false
RUN npm config set registry http://registry.npmjs.org
RUN set NODE_TLS_REJECT_UNAUTHORIZED=0

RUN npm install
COPY . . 
RUN npm run build

# /app/build <--- all the stuff
# Second block

FROM nginx
# Copy something from other phase we were working on
COPY --from=builder /app/build /usr/share/nginx/html
# The "to" path we get from docker nginx docs
# Default command for nginx image is "Start nginx"
# So no need to specify override command
# our image is goinf to be small!

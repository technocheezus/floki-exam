# Base on offical Node.js Alpine image
FROM node:alpine as build

# Set working directory
WORKDIR /usr/app

# Copy package.json and yarn-lock.json before other files
# Utilise Docker cache to save re-installing dependencies if unchanged
COPY ./package.json ./
COPY ./yarn.lock ./

# Install dependencies
RUN yarn install --frozen-lockfile --production --ignore-scripts

# end of deps stage

FROM node:alpine

# Set working directory
WORKDIR /usr/app

# Copy all files (node_modules is ignored by .dockerignore)
COPY ./ ./

# Set working directory
WORKDIR /usr/app

COPY --from=build /usr/app/node_modules ./node_modules

EXPOSE 4000
USER node
CMD [ "yarn", "start" ]
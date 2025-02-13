ARG VERSION=1.27.4

FROM nginx:${VERSION}

# create ec2-user:ec2-user to match the UID and GID 
# with Amazon Liunx and EFS AccessPoint permission config
RUN groupadd --gid 1000 ec2-user
RUN useradd --uid 1000 --gid 1000 ec2-user

#/etc/nginx/conf.d/mysite.conf
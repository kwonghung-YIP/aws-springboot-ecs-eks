ARG VERSION=1.27.4

FROM nginx:${VERSION}

# create ec2-user:ec2-user to match the UID and GID 
# with Amazon Liunx and EFS AccessPoint permission config
RUN groupadd --gid 1000 ec2-user;\
    useradd --uid 1000 --gid 1000 ec2-user;\
    mkdir -p /etc/nginx/templates;\
    mkdir -p /usr/share/my-site/html

#COPY my-site.conf /etc/nginx/conf.d/my-site.conf
COPY nginx.conf /etc/nginx/nginx.conf
COPY *.template /etc/nginx/templates
COPY my-site-html/ /usr/share/my-site/html
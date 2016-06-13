# centos-nginx-php
Docker image for a basic nginx and php-fpm on centos container. This image allows for easy website and config updates from a git repository.
### getting started
To get an instance up and running, you would need to do the following:
* fork the https://github.com/CamW/centos-nginx-php-demo repo and change the conf/nginx.conf file to point to your domain, as indicated in the repo's README.md
* Create an instance of the container by running:
  * `docker run -d --name=your_website -p 80:80 -p 443:443 camw/centos-nginx-php`
* Pull the code for your new website (created in step 1) into the container by running:
  * `docker exec -ti your_website get https://www.github.com/user/your_repo.git`
* Restart the container so that nginx config changes take effect
  * `docker restart your_website`

Then, when you've made changes to your site in git, just run `docker exec -ti your_website update` to update your container with the new changes.

### extension points
This image may not serve all your needs as is. There may, for example, be other packages you need installed in which case you could create a dockerfile which starts with this this image and adds what you need. As an example:
```
FROM camw/centos-nginx-php:latest
MAINTAINER Your Name <you@domain.com>
RUN yum -y install php-mysql
```

You may also need a more complicated build process which requires more than just copying files into the folder such as grunt minification and versioning. That could be included in the scripts/publish_src.sh script which is in your website repo, forked from `https://github.com/CamW/centos-nginx-php-demo` 
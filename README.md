# mavengit

# BUILD IMAGE
docker build -t [IMAGE_NAME/Tag] .

# RUN
docker run -it --entrypoint=/bin/bash [IMAGE_NAME/Tag]

# CLONE GIT REPOSITORY
git clone [REPOSITORY_URL]

# MAVEN PACKAGE
mvn package -f /jpetstore/pom.xml

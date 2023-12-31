FROM maven:3.8.6-openjdk-11 AS build
RUN git clone https://github.com/kpkiranp/CI.git
WORKDIR /CI
RUN mvn clean package
CMD [ "/bin/bash" ]

FROM tomcat:9.0-jdk11-corretto-al2 AS deployment
COPY --from=build /CI/target/*.war /usr/local/tomcat/webapps/
CMD [ "catalina.sh", "run" ]
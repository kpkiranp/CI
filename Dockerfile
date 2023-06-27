FROM maven:3.8.6-openjdk-11 AS build
RUN git clone https://github.com/kpkiranp/CI.git
WORKDIR /HPA_task
RUN mvn clean package
CMD [ "/bin/bash" ]

FROM tomcat AS deployment
COPY --from=build /HPA_task/target/*.war /usr/local/tomcat/webapps/
CMD [ "catalina.sh", "run" ]
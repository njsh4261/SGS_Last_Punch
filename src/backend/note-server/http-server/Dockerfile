FROM openjdk:11
ARG JAR_FILE=build/libs/http-server-0.0.1-SNAPSHOT.jar
COPY ${JAR_FILE} http-server.jar
ENTRYPOINT ["java","-jar","/http-server.jar"]
EXPOSE 9000

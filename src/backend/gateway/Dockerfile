FROM openjdk:11
ARG JAR_FILE=build/libs/gateway-0.0.1-SNAPSHOT.jar
COPY ${JAR_FILE} gateway.jar
ENTRYPOINT ["java","-jar","/gateway.jar"]
EXPOSE 8080

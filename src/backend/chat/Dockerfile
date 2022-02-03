FROM openjdk:11
ARG JAR_FILE=build/libs/chat-server.jar
COPY ${JAR_FILE} chatServer.jar
ENTRYPOINT ["java","-jar","/chatServer.jar"]
EXPOSE 8083

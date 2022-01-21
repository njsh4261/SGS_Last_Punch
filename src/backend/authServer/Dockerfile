FROM openjdk:11
ARG JAR_FILE=build/libs/authServer-0.0.1-SNAPSHOT.jar
COPY ${JAR_FILE} authServer.jar
ENTRYPOINT ["java","-jar","/authServer.jar"]
EXPOSE 8081

#FROM openjdk:11
#
#VOLUME /tmp
#
#RUN mkdir -p /spring
#WORKDIR /spring
#ADD . /spring/
#
#EXPOSE 8081
#
#RUN ./gradlew build
#
#ENTRYPOINT ["java","-jar","build/libs/authServer-0.0.1-SNAPSHOT.jar"]
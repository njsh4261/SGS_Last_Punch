FROM openjdk:11

VOLUME /tmp

RUN mkdir -p /spring
WORKDIR /spring
ADD . /spring/

EXPOSE 9000

RUN ./gradlew build
ENTRYPOINT ["java","-jar","build/libs/note-http-server-0.0.1-SNAPSHOT.jar"]

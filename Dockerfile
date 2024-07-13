FROM eclipse-temurin:21

WORKDIR /opt/

COPY . /opt/

CMD ["./opt/mvnw", "clean", "verify"]
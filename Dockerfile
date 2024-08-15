# Usar una imagen
FROM eclipse-temurin:21

# Establecer las variables de entorno necesarias
ENV DEBIAN_FRONTEND=noninteractive

# Instalar dependencias necesarias para instalar Google Chrome
RUN apt-get update && \
    apt-get install -y wget gnupg2 software-properties-common

# Descargar e instalar Google Chrome
RUN wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - && \
    sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list' && \
    apt-get update && \
    apt-get install -y google-chrome-stable && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Configurar el comando por defecto para ejecutar Google Chrome en modo headless
CMD ["google-chrome", "--headless", "--no-sandbox", "--disable-gpu", "--remote-debugging-port=9222", "http://example.org"]

# Configurar y arrancar el servidor VNC y Firefox
CMD ["sh", "-c", "xvfb-run --server-args='-screen 0 1024x768x24' firefox http://example.org"]

# Establecer el directorio de trabajo
WORKDIR /opt/

# Copiar el archivo pom.xml y descargar dependencias de Maven (si es necesario)
COPY pom.xml .

# Copiar el resto del código del proyecto
COPY src/ ./src/

COPY . /opt/

CMD ["./mvnw", "clean", "verify"]


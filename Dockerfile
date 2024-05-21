# Use a imagem base do Debian
FROM debian:buster

# Instale o OpenSSH Server e outros pacotes necessários
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y openssh-server && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Crie o diretório necessário para o SSH
RUN mkdir /var/run/sshd

# Configure a senha para o usuário root
RUN echo 'root:root' | chpasswd

# Permitir login com senha
RUN sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config

# Permitir root login
RUN sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config

# Desativar o uso do PAM (opcional)
RUN sed -i 's/usePAM yes/usePAM no/' /etc/ssh/sshd_config
RUN apt-get update -y  && apt-get upgrade && apt-get install -y curl
# Expor a porta 22
EXPOSE 22

# Comando para iniciar o SSH
CMD ["/usr/sbin/sshd", "-D"]
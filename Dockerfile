FROM ghcr.io/opentofu/opentofu:1.10-minimal AS tofu

FROM alpine:3.22

COPY --from=tofu /usr/local/bin/tofu /usr/local/bin/opentofu

RUN apk add --no-cache curl git openssh-client rsync python3 py3-pip pipx sudo
# Set environment variables for pipx to install packages globally
ENV PIPX_HOME=/usr/local/pipx
ENV PIPX_BIN_DIR=/usr/local/bin

RUN pipx install ansible-core==2.19 && pipx install ansible-runner

# Create a non-root user and add to sudoers
RUN adduser -D -s /bin/sh appuser \
    && adduser appuser wheel \
    && echo '%wheel ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers.d/00-wheel

USER appuser

# Install Ansible collections
RUN ansible-galaxy collection install community.general \
    && ansible-galaxy collection install ansible.posix 

# Verify installations
RUN opentofu --version && ansible --version && ansible-runner --version

WORKDIR /workspace
# une shell interactive par défaut
ENTRYPOINT ["/bin/sh", "-lc"]
CMD ["sh"]
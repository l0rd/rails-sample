FROM quay.io/devfile/universal-developer-image:latest

# The following commands require root
USER 0

# Install a recent version of ruby
ENV RUBY_VERSION 3.1.2
RUN dnf -y update && \
    dnf -y install rbenv ruby-build sqlite && \
    dnf -y clean all --enablerepo='*' && \
    rbenv install $RUBY_VERSION && \
    rbenv global $RUBY_VERSION && \
    echo 'eval "$(rbenv init - bash)"' >> $HOME/.bashrc && \
    echo 'eval "$(rbenv init - sh)"' > /etc/profile.d/rbenv.sh

ENV PATH="${HOME}/.rbenv/shims:${PATH}" ENV="/etc/profile"

# Install rails
RUN gem install rails

# Set bundle config
RUN bundle config --global path $HOME/.bundle/vendor && \
    chgrp -R 0 $HOME/.bundle && chmod -R g=u $HOME/.bundle && \
    chgrp -R 0 $HOME/.local && chmod -R g=u $HOME/.local && \
    chgrp -R 0 $HOME/.rbenv && chmod -R g=u $HOME/.rbenv

USER 10001


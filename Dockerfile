FROM debian:latest

# ユーザーの作成
ARG USERNAME=vscode
ARG USER_UID=1000
ARG USER_GID=$USER_UID

# 必要なパッケージのインストール
RUN apt-get update -qq \
    && apt-get install -y \
       adduser \
       curl \
       git \
       gnupg \
       libvips-dev \
       locales \
       make \
       openssh-client \
       sudo \
       tzdata \
       vim \
       zsh \
       zsh-autosuggestions \
       zsh-syntax-highlighting \
    && sed -i -e 's/# \(ja_JP.UTF-8\)/\1/' /etc/locale.gen \
    && locale-gen \
    && update-locale LANG=ja_JP.UTF-8 \
    && ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && groupadd --gid $USER_GID $USERNAME \
    && useradd --uid $USER_UID --gid $USER_GID -m $USERNAME -s /bin/zsh \
    && echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME \
    && chmod 0440 /etc/sudoers.d/$USERNAME \
    && mkdir -p /home/$USERNAME/.zsh \
    && chown -R $USERNAME:$USERNAME /home/$USERNAME/.zsh*

USER vscode

ENV HOME=/home/vscode

# 作業ディレクトリの設定
WORKDIR $HOME

COPY --chown=vscode:vscode setup.sh $HOME/setup.sh

RUN bash -vx $HOME/setup.sh

FROM centos:7
MAINTAINER "w0lker" <w0lker.tg@gmail.com>
ARG USER
ARG USER_ID
ARG GROUP_ID
ENV USER ${USER:-tangjun}
ENV USER_ID ${USER_ID:-1000}
ENV GROUP_ID ${GROUP_ID:-1000}
ENV TERM xterm-256color

# set locale
RUN yum -y update && yum clean all
RUN yum reinstall -y glibc-common && yum clean all
ENV LANG zh_CN.UTF-8
ENV LANGUAGE zh_CN:zh
ENV LC_ALL zh_CN.UTF-8
RUN ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime

# install essential package
RUN yum update -y && yum clean all
RUN yum install -y \
bash-completion \
man \
git \
vim \
sudo \
net-tools \
bind-utils \
&& yum clean all

RUN groupadd --gid $GROUP_ID $USER
RUN useradd --gid $GROUP_ID --uid $USER_ID $USER
RUN chmod u+s /bin/ping
RUN sh -c "sed -i \"/^#\s*%wheel.*NOPASSWD: ALL$/a\$USER  ALL=(ALL)  NOPASSWD: ALL\" /etc/sudoers"

WORKDIR /home/$USER
USER $USER

# git
RUN echo $'function parse_git_branch_and_add_brackets {\n\
    git branch --no-color 2> /dev/null | sed -e \'/^[^*]/d\' -e \'s/* \(.*\)/\(\\1\) /\'\n\
}\n\
PS1=\'\[\\e[0;36;40m\]\W $(parse_git_branch_and_add_brackets "(%s)")\$ \[\\e[0m\]\''\
>> .bashrc
RUN curl https://raw.githubusercontent.com/w0lker/git_config/master/gitconfig -o .gitconfig
RUN curl https://raw.githubusercontent.com/w0lker/git_config/master/gitignore_global -o .gitignore_global

# colors
RUN curl https://raw.githubusercontent.com/seebi/dircolors-solarized/master/dircolors.256dark -o .dircolors

# vim
RUN curl https://raw.githubusercontent.com/w0lker/vim/master/vimrc -o .vimrc
RUN echo 'alias vi=vim' >> .bashrc

# clear
USER root
RUN rm -rf /home/$USER/* /root/* /*.log /tmp/*
USER $USER
CMD ["/usr/sbin/init"]

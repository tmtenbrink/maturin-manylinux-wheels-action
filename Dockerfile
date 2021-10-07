FROM quay.io/pypa/manylinux2014_x86_64

ENV COMP manylinux2014

RUN yum install libffi-devel -y

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]

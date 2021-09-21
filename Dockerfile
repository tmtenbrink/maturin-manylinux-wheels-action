FROM quay.io/pypa/manylinux2014_x86_64

ENV COMP manylinux2014

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
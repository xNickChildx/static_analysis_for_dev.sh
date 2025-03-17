FROM fedora:38 
# ^this release has ocaml < 5.2 , coccicheck is broken on >2.0
# related https://github.com/coccinelle/coccinelle/issues/366

RUN dnf install -y coccinelle which git

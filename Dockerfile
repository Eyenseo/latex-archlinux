FROM base/archlinux

# Add mirrors 
COPY mirrorlist /etc/pacman.d/mirrorlist

# Source perlbin to setup PATH in a non-interactive session
COPY bashrc /root/.bashrc

# Set the entrypoint to a interactive shell 
# This is needed as the /etc/provile file has to be executed since PATH has to
# be modified for perl.
ENTRYPOINT ["/usr/bin/bash", "-i"]


RUN \ # Update package database
    pacman --noconfirm -Syu archlinux-keyring reflector rsync && \
    \ # Rank mirrors
    reflector --verbose -l 200 -f 50 --sort rate | tee /etc/pacman.d/mirrorlist && \
    \ # Dependencies
    pacman --noconfirm -S sed grep which diffutils gawk gettext gzip tar file git && \
    \ # LaTex
    pacman --noconfirm -S texlive-most biber minted && \
    \ # Redo "Updating TeXLive databases"
    pacman --noconfirm -S texlive-bin &&\
    \ # Remove the cached packages
    paccache -rk0


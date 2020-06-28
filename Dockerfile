FROM jupyter/scipy-notebook:latest

USER root

# Add XFCE packages+Firefox
RUN apt-get -y update && apt-get install -y dbus-x11 xfce4 xfce4-panel xfce4-session xfce4-settings xorg xubuntu-icon-theme
RUN apt-get -y update && apt-get install -y dbus-x11 firefox

# Disable the Applications|Log Out menu item in XFCE
# ref: https://github.com/yuvipanda/jupyter-desktop-server/issues/16
RUN rm -f /usr/share/applications/xfce4-session-logout.desktop

# Disable creation of Music, Documents, etc.. directories
# ref: https://unix.stackexchange.com/questions/268720/who-is-creating-documents-video-pictures-etc-in-home-directory
RUN apt-get remove -y xdg-user-dirs



USER $NB_USER

# Install the extensions adding the VNC server/novnc client
# ref: https://github.com/yuvipanda/jupyter-desktop-server/issues/11#issuecomment-586264550
# ref: https://github.com/yuvipanda/jupyter-desktop-server/issues/18
RUN conda install -c manics websockify
RUN pip install jupyter-server-proxy
RUN jupyter labextension install @jupyterlab/server-proxy

#RUN pip install git+https://github.com/mjuric/jupyter-desktop-server@7b332a2
#RUN pip install jupyter-desktop-server
COPY . jupyter-desktop-server
RUN cd jupyter-desktop-server && pip install .

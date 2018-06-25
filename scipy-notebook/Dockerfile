# Copyright (c) Jupyter Development Team.
# Distributed under the terms of the Modified BSD License.
FROM jupyter/minimal-notebook

LABEL maintainer="Jupyter Project <jupyter@googlegroups.com>"

USER root

# # install postgresql
# RUN apt-get update && apt-get install -y python-pip  python-dev && \
#     apt-get -y remove python-pip python-dev && \
#     apt-get -y autoremove

# libav-tools for matplotlib anim
# libaio1 and unzip for oracle
RUN apt-get update && \
    apt-get install -y --no-install-recommends libpq-dev libav-tools openssh-client libaio1 libaio-dev unzip && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# To install oracle along with sqlplus
# https://oracle.github.io/odpi/doc/installation.html#oracle-instant-client-zip
# https://docs.oracle.com/cd/B19306_01/server.102/b14357/ape.htm

COPY instantclient_12_2.zip /home/
RUN unzip /home/instantclient_12_2.zip -d /home/

ENV LD_LIBRARY_PATH=/home/instantclient_12_2
ENV PATH=/home/instantclient_12_2:${PATH}
ENV SQLPATH=/home/instantclient_12_2:${SQLPATH}

USER $NB_UID

# Install Python 3 packages
# Remove pyqt and qt pulled in for matplotlib since we're only ever going to
# use notebook-friendly backends in these images
RUN conda install --quiet --yes \
    'blas=*=openblas' \
    'ipywidgets=7.2*' \
    'pandas=0.22*' \
    'numexpr=2.6*' \
    'matplotlib=2.1*' \
    'scipy=1.0*' \
    'seaborn=0.8*' \
    'scikit-learn=0.19*' \
    'scikit-image=0.13*' \
    'sympy=1.1*' \
    'cython=0.28*' \
    'patsy=0.5*' \
    'statsmodels=0.8*' \
    'cloudpickle=0.5*' \
    'dill=0.2*' \
    'numba=0.38*' \
    'bokeh=0.12*' \
    'sqlalchemy=1.2*' \
    'hdf5=1.10*' \
    'h5py=2.7*' \
    'vincent=0.4.*' \
    'beautifulsoup4=4.6.*' \
    'protobuf=3.*' \
    'xlrd'  && \
    conda remove --quiet --yes --force qt pyqt && \
    conda clean -tipsy && \
    # Activate ipywidgets extension in the environment that runs the notebook server
    jupyter nbextension enable --py widgetsnbextension --sys-prefix && \
    # Also activate ipywidgets extension for JupyterLab
    jupyter labextension install @jupyter-widgets/jupyterlab-manager@^0.35 && \
    jupyter labextension install jupyterlab_bokeh@^0.5.0 && \
    jupyter labextension install @jupyterlab/hub-extension@0.9.0 && \
    jupyter labextension install @jupyterlab/geojson-extension && \
    jupyter labextension install jupyter-leaflet && \
    jupyter labextension install @jupyter-widgets/jupyterlab-manager && \
    npm cache clean --force && \
    rm -rf $CONDA_DIR/share/jupyter/lab/staging && \
    rm -rf /home/$NB_USER/.cache/yarn && \
    rm -rf /home/$NB_USER/.node-gyp && \
    fix-permissions $CONDA_DIR && \
    fix-permissions /home/$NB_USER
    
RUN pip install lifetimes && \
    pip install geotiler && \
    pip install cx_Oracle && \
    pip install sshtunnel && \
    pip install ipython-sql && \
    pip install babel && \
    pip install gmaps && \
    pip install psycopg2 && \
    pip install jupyter_contrib_nbextensions && \
    pip install jupyter_nbextensions_configurator && \
    jupyter contrib nbextension install --user && \
    jupyter nbextensions_configurator enable --user && \
    jupyter nbextension enable varInspector/main && \
    jupyter lab build

# Install setup ssh:

# Install facets which does not have a pip or conda package at the moment
RUN cd /tmp && \
    git clone https://github.com/PAIR-code/facets.git && \
    cd facets && \
    jupyter nbextension install facets-dist/ --sys-prefix && \
    cd && \
    rm -rf /tmp/facets && \
    fix-permissions $CONDA_DIR && \
    fix-permissions /home/$NB_USER

# Import matplotlib the first time to build the font cache.
ENV XDG_CACHE_HOME /home/$NB_USER/.cache/
RUN MPLBACKEND=Agg python -c "import matplotlib.pyplot" && \
    fix-permissions /home/$NB_USER

#Add cloudsql-proxy
RUN wget https://dl.google.com/cloudsql/cloud_sql_proxy.linux.amd64 -O /cloud_sql_proxy
RUN chmod +x /cloud_sql_proxy

USER $NB_UID

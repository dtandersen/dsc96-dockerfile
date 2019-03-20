ARG BASE_CONTAINER=jupyter/datascience-notebook:a95cb64dfe10
FROM $BASE_CONTAINER

MAINTAINER UC San Diego ITS/ETS-EdTech-Ecosystems <acms-compinf@ucsd.edu>
USER root

RUN pip install datascience

RUN apt-get update && apt-get -qq install -y \
        curl \
        rsync \
        unzip \
        less \
        nano \
        vim \
        openssh-client \
        wget


RUN conda install -y numpy==1.12.1
RUN conda install -y pandas==0.19.2
RUN conda install -y pypandoc
RUN conda install -y scipy==0.19.0
RUN conda install -y statsmodels==0.8.0
RUN conda install --quiet --yes \
            bokeh \
            cloudpickle \
            cython \
            dill \
            h5py \
            hdf5 \
            nose \
            numba \
            numexpr \
            patsy \
            scikit-image \
            scikit-learn \
            seaborn \
            sqlalchemy \
            sympy \
			Pillow \
			nltk \
			folium

# Pregenerate matplotlib cache
RUN python -c 'import matplotlib.pyplot'

RUN conda remove --quiet --yes --force qt pyqt
RUN conda clean -tipsy
RUN conda install nbgrader

RUN jupyter nbextension install --symlink --sys-prefix --py nbgrader
RUN jupyter nbextension enable --sys-prefix --py nbgrader
RUN jupyter serverextension enable --sys-prefix --py nbgrader

# Disable formgrader for default case, re-enable if instructor
RUN jupyter nbextension disable --sys-prefix formgrader/main --section=tree
RUN jupyter serverextension disable --sys-prefix nbgrader.server_extensions.formgrader
RUN jupyter nbextension disable --sys-prefix create_assignment/main

RUN pip install ipywidgets
RUN jupyter nbextension enable --sys-prefix --py widgetsnbextension

RUN pip install git+https://github.com/data-8/gitautosync

RUN jupyter serverextension enable --py nbgitpuller --sys-prefix

RUN pip install git+https://github.com/data-8/nbresuse.git
RUN jupyter serverextension enable --sys-prefix --py nbresuse
RUN jupyter nbextension install --sys-prefix --py nbresuse
RUN jupyter nbextension enable --sys-prefix --py nbresuse

# Set working directory
WORKDIR /home/jovyan

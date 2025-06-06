# Caminho base do Conda
CONDA_BASE := $(shell conda info --base)
CONDA_INIT := source $(CONDA_BASE)/etc/profile.d/conda.sh

# Diretório de ambientes exportados
ENV_DIR := envs

# Ambientes
DATA_ENV := data-eng
ML_ENV := ml-eng
API_ENV := ml-api

# Lista de dependências
DATA_DEPS := pandas pyarrow fastparquet pyspark sqlalchemy dbt-core dbt-postgres great_expectations
ML_DEPS := pandas scikit-learn tensorflow jupyter seaborn matplotlib
API_DEPS := fastapi uvicorn joblib mlflow

# Regras

## Cria ambiente de Data Engineering
data-eng:
	bash -c "$(CONDA_INIT) && conda create -y -n $(DATA_ENV) python=3.11 && conda activate $(DATA_ENV) && pip install $(DATA_DEPS)"

## Cria ambiente de ML Engineering
ml-eng:
	bash -c "$(CONDA_INIT) && conda create -y -n $(ML_ENV) python=3.11 && conda activate $(ML_ENV) && pip install $(ML_DEPS)"

## Cria ambiente para API de modelos
ml-api:
	bash -c "$(CONDA_INIT) && conda create -y -n $(API_ENV) python=3.11 && conda activate $(API_ENV) && pip install $(API_DEPS)"

## Exporta os ambientes
requirements:
	@mkdir -p $(ENV_DIR)
	conda activate $(DATA_ENV) && conda env export > $(ENV_DIR)/$(DATA_ENV).yml
	conda activate $(ML_ENV) && conda env export > $(ENV_DIR)/$(ML_ENV).yml
	conda activate $(API_ENV) && conda env export > $(ENV_DIR)/$(API_ENV).yml

## Remove todos os ambientes (com segurança)
clean:
	conda remove -n $(DATA_ENV) --all -y || true
	conda remove -n $(ML_ENV) --all -y || true
	conda remove -n $(API_ENV) --all -y || true


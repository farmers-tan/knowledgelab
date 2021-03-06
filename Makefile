run:  ## clean and make target, run target
	python3 -m knowledgelab 

testjs: ## Clean and Make js tests
	npm run test

testpy: ## Clean and Make unit tests
	python3 -m pytest -v tests --cov=knowledgelab

test: lint ## run the tests for travis CI
	@ python3 -m pytest -v tests --cov=knowledgelab
	npm install && npm run test

lint: ## run linter
	pylint knowledgelab || echo
	flake8 knowledgelab 

annotate: ## MyPy type annotation check
	mypy -s knowledgelab  

annotate_l: ## MyPy type annotation check - count only
	mypy -s knowledgelab | wc -l 

clean: ## clean the repository
	find . -name "__pycache__" | xargs  rm -rf 
	find . -name "*.pyc" | xargs rm -rf 
	find . -name ".ipynb_checkpoints" | xargs  rm -rf 
	rm -rf .coverage cover htmlcov logs build dist *.egg-info
	make -C ./docs clean

install:  ## install to site-packages
	python3 setup.py install

serverextension: install ## enable serverextension
	jupyter serverextension enable --py knowledgelab

labextension: install ## enable labextension
	jupyter labextension install jlab

docs:  ## make documentation
	make -C ./docs html

# Thanks to Francoise at marmelab.com for this
.DEFAULT_GOAL := help
help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

print-%:
	@echo '$*=$($*)'

.PHONY: clean run test tests help annotate annotate_l docs

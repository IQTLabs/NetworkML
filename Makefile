SHELL:=/bin/bash


run: build_onelayer eval_onelayer
help:
	@echo "make OPTION      (see below for description; requires setting PCAP environment variable)"
	@echo 
	@echo "eval_[onelayer|randomforest]     Runs pcap file against specified model"
	@echo "test_[onelayer|randomforest]     Tests directory of pcaps against specified model"
	@echo "train_[onelayer|randomforest]    Trains directory of pcaps against specified model"
	@echo "run      Equivalent to eval_onelayer"
eval_onelayer: build_onelayer
	@echo "Running OneLayer Eval on PCAP file $(PCAP)"
	docker run -it -v "$(PCAP):/pcaps/eval.pcap" -e SKIP_RABBIT=true poseidonml:onelayer
test_onelayer: build_onelayer
	@echo "Running OneLayer Test on PCAP files $(PCAP)"
	@docker run -it -v "/tmp/models:/OneLayer/models" -v "$(PCAP):/pcaps/" -e SKIP_RABBIT=true poseidonml:onelayer test_OneLayer.py
train_onelayer: build_onelayer
	@echo "Running OneLayer Train on PCAP files $(PCAP)"
	@docker run -it -v "/tmp/models:/OneLayer/models" -v "$(PCAP):/pcaps/" -e SKIP_RABBIT=true poseidonml:onelayer train_OneLayer.py
eval_randomforest: build_randomforest
	@echo "Running RandomForest Eval on PCAP file $(PCAP)"
	@docker run -it -v "$(PCAP):/pcaps/eval.pcap" -e SKIP_RABBIT=true poseidonml:randomforest
test_randomforest: build_randomforest
	@echo "Running RandomForest Test on PCAP files $(PCAP)"
	@docker run -it -v "/tmp/models:/RandomForest/models" -v "$(PCAP):/pcaps/" -e SKIP_RABBIT=true poseidonml:randomforest test_RandomForest.py
train_randomforest: build_randomforest
	@echo "Running RandomForest Train on PCAP files $(PCAP)"
	@docker run -it -v "/tmp/models:/RandomForest/models" -v "$(PCAP):/pcaps/" -e SKIP_RABBIT=true poseidonml:randomforest train_RandomForest.py
build_onelayer: build_base
	@pushd DeviceClassifier/OneLayer && docker build -t poseidonml:onelayer . && popd
build_randomforest: build_base
	@pushd DeviceClassifier/RandomForest && docker build -t poseidonml:randomforest . && popd
build_base:
	@docker build -t cyberreboot/poseidonml:base -f Dockerfile.base .
install:
	python3 setup.py install

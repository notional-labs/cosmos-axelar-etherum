CUDOS_BINARY:= _build/binary/cudos-noded
AXELAR_BINARY:= _build/binary/axelard

.PHONY: update-gitsubmodule run-cudos-node build-cudos-node

update-gitsubmodule:
	git submodule update --init --recursive

build-cudos-node: update-gitsubmodule
	rm -rf deps/cudos-node/build
	mkdir -p _build
	./cudos/build-cudos-node.sh

run-cudos-node:
	./cudos/run-cudos-node.sh $(CUDOS_BINARY)

setup-axelar: update-gitsubmodule
	./axelar/init-axelar.sh
	./scripts/cudos/run-cudos-node.sh $(CUDOS_BINARY) 


init-chains:
	./axelar/init-axelar.sh  # run axelar init script, start at port 26657
	./scripts/cudos/run-cudos-node.sh $(CUDOS_BINARY) # run cudos node at port 16657
	screen -ls 


clean-testing-data:
	@echo "Killing migallod and removing previous data"
	-@pkill $(CUDOS_BINARY) 2>/dev/null
	-@pkill $(AXELAR_BINARY) 2>/dev/null
	-@pkill rly 2>/dev/null
	-@rm -rf ./testnet

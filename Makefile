CUDOS_BINARY:= _build/binary/cudos-noded
AXELAR_BINARY:= _build/binary/axelard

.PHONY: update-gitsubmodule run-cudos-node build-cudos-node

update-gitsubmodule:
	git submodule update --init --recursive

build-cudos-node: update-gitsubmodule
	rm -rf deps/cudos-node/build
	mkdir -p _build
	./cudos/build-cudos-node.sh

run-cudos-node: update-gitsubmodule 
	./cudos/run-cudos-node.sh $(CUDOS_BINARY)

run-axelar-node: update-gitsubmodule
	./axelar/init-axelar.sh


init-chains: clean-testing-data
	./etherum/init-evm.sh # run etherum testnet, rpc port 7545
	sleep 5
	./axelar/init-axelar.sh  # run axelar init script, start at port 26657
	sleep 5
	./cudos/run-cudos-node.sh $(CUDOS_BINARY) # run cudos node at port 16657
	screen -ls


setup-relayer:
	./relayer/setup/rly-init.sh
	./scripts/cudos/run-cudos-node.sh $(CUDOS_BINARY) # run cudos node at port 16657
	screen -ls

clean-testing-data:
	@echo "Killing migallod and removing previous data"
	-@pkill $(CUDOS_BINARY) 2>/dev/null
	-@pkill $(AXELAR_BINARY) 2>/dev/null
	-@pkill rly 2>/dev/null
	-@rm -rf ./testnet

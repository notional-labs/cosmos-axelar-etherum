CUDOS_BINARY:= _build/binary/cudos-noded
AXELAR_BINARY:= _build/binary/axelard

.PHONY: update-gitsubmodule run-cudos-node build-cudos-node

update-gitsubmodule:
	git submodule update --init --recursive

build-cudos-node: update-gitsubmodule
	rm -rf deps/cudos-node/build
	mkdir -p _build
	./cudos/build-cudos-node.sh

run: update-gitsubmodule build-cudos-node init-chains setup-relayer
	sleep 5
	$(MAKE) run-ibc-send
	screen -ls

run-cudos-node: update-gitsubmodule
	./cudos/run-cudos-node.sh $(CUDOS_BINARY)

run-axelar-node: update-gitsubmodule
	./axelar/init-axelar.sh # run axelar init script, start at port 26657
	sleep 5
	./axelar/setup.sh # setup chain related

init-chains: clean-testing-data
	$(MAKE) run-cudos-node # run cudos node at port 16657
	sleep 5
	./etherum/init-evm.sh # run etherum testnet, rpc port 7545
	sleep 5
	$(MAKE) run-axelar-node

setup-relayer:
	./relayer/setup/rly-init.sh

run-ibc-send:
	./axelar/route-ibc-pending.sh

clean-testing-data:
	@echo "Killing migallod and removing previous data"
	-@pkill $(CUDOS_BINARY) 2>/dev/null
	-@pkill $(AXELAR_BINARY) 2>/dev/null
	-@pkill rly 2>/dev/null
	-@rm -rf ./testnet

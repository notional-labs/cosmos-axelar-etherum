CUDOS_BINARY:= _build/binary/cudos-noded

.PHONY: update-gitsubmodule run-cudos-node build-cudos-node

update-gitsubmodule:
	git submodule update --init --recursive

build-cudos-node: update-gitsubmodule
	rm -rf deps/cudos-node/build
	mkdir -p _build
	./cudos/build-cudos-node.sh

run-cudos-node:
	./cudos/run-cudos-node.sh $(CUDOS_BINARY)

setup-axelar:
	update-gitsubmodule
	./axelar/init-axelar.sh

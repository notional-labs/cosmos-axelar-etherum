CUDOS_BINARY:= _build/cudos-noded

.PHONY: update-gitsubmodule run-cudos-node build-cudos-node

update-gitsubmodule:
	git submodule update --init --recursive

build-cudos-node: update-gitsubmodule
	rm -rf cudos-node/build
	mkdir -p _build
	./scripts/build-cudos-node.sh

run-cudos-node:
	./scripts/run-cudos-node.sh $(CUDOS_BINARY)

go_setup_file = "./install_go.sh"
geth_setup_file = "./setup_geth.sh"
geth_start_file = "./private-network-setup/start_geth.sh"
lighthouse_setup_file = "./setup_lighthouse.sh"
beaconnode_start_file = "./private-network-setup/start_lighthouse_beaconnode.sh"
bootnode_start_file = "./private-network-setup/start_lighthouse_bootnode.sh"
validatorclient_start_file = "./private-network-setup/start_lighthouse_validatorclient.sh"
go_root_path = "$(HOME)/.go"

.PHONY: setup-geth
setup-geth:
	@make install-go
	@chmod +x ${geth_setup_file}
	@${geth_setup_file}

.PHONY: setup-lighthouse
setup-lighthouse:
	@chmod +x ${lighthouse_setup_file}
	@${lighthouse_setup_file}

.PHONY: setup
setup:
	@make setup-geth
	@make setup-lighthouse

.PHONY: fetch
fetch: 
	@echo "Retrieving Submodules"
	@git submodule foreach --recursive 'git fetch --tags'
	@git submodule update --init --recursive

.PHONY: install-go
install-go: 
	@chmod +x ${go_setup_file}
	@${go_setup_file} || ([ $$? -eq 33 ] && exit 0) || exit 1


.PHONY: start-geth
start-geth: 
	@chmod +x ${geth_start_file}
	@${geth_start_file} || ([ $$? -eq 33 ] && exit 0) || exit 1

.PHONY: start-bootnode
start-bootnode: 
	@chmod +x ${go_setup_file}
	@${go_setup_file} || ([ $$? -eq 33 ] && exit 0) || exit 1

.PHONY: start-lighthouse-beaconnode
start-lighthouse-beaconnode: 
	@chmod +x ${go_setup_file}
	@${go_setup_file} || ([ $$? -eq 33 ] && exit 0) || exit 1

.PHONY: start-lighthouse-validatorclient
start-lighthouse-validatorclient: 
	@chmod +x ${go_setup_file}
	@${go_setup_file} || ([ $$? -eq 33 ] && exit 0) || exit 1
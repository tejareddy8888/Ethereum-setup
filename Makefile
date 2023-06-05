fetch_file = "./private-network-setup/scripts/fetch.sh"
go_setup_file = "./private-network-setup/scripts/install_go.sh"
geth_setup_file = "./private-network-setup/scripts/setup_geth.sh"
lighthouse_setup_file = "./private-network-setup/scripts/setup_lighthouse.sh"
create-new-genesis_file = "./private-network-setup/scripts/create-genesis-and-initialize.sh"
geth_start_file = "./private-network-setup/scripts/start_geth.sh"
el_bootnode_start_file = "./private-network-setup/scripts/start_execution_layer_bootnode.sh"
beaconnode_start_file = "./private-network-setup/scripts/start_lighthouse_beaconnode.sh"
cl_bootnode_start_file = "./private-network-setup/scripts/start_lighthouse_bootnode.sh"
validatorclient_start_file = "./private-network-setup/scripts/start_lighthouse_validatorclient.sh"
el_genesis_file = "./private-network-setup/uzh-pos-genesis.json"
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
	@chmod +x ${fetch_file}
	@${fetch_file} || ([ $$? -eq 33 ] && exit 0) || exit 1

.PHONY: install-go
install-go: 
	@chmod +x ${go_setup_file}
	@${go_setup_file} || ([ $$? -eq 33 ] && exit 0) || exit 1

.PHONY: create-new-genesis
create-new-genesis:
	@chmod +x ${create-new-genesis_file}
	@${create-new-genesis_file} ${el_genesis_file} || ([ $$? -eq 33 ] && exit 0) || exit 1

.PHONY: start-geth
start-geth: 
	@chmod +x ${geth_start_file}
	@${geth_start_file} || ([ $$? -eq 33 ] && exit 0) || exit 1

.PHONY: start-el-bootnode
start-el-bootnode: 
	@chmod +x ${el_bootnode_start_file}
	@${el_bootnode_start_file} || ([ $$? -eq 33 ] && exit 0) || exit 1

.PHONY: start-cl-bootnode
start-cl-bootnode: 
	@chmod +x ${cl_bootnode_start_file}
	@${cl_bootnode_start_file} || ([ $$? -eq 33 ] && exit 0) || exit 1

.PHONY: start-lighthouse
start-lighthouse: 
	@chmod +x ${beaconnode_start_file}
	@${beaconnode_start_file} || ([ $$? -eq 33 ] && exit 0) || exit 1

.PHONY: start-lighthouse-validatorclient
start-lighthouse-validatorclient: 
	@chmod +x ${validatorclient_start_file}
	@${validatorclient_start_file} || ([ $$? -eq 33 ] && exit 0) || exit 1
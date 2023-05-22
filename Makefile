go_setup_file = "./install_go.sh"
geth_setup_file = "./setup_geth.sh"
geth_start_file = "./private-network-setup/start_geth.sh"
lighthouse_setup_file = "./setup_lighthouse.sh"
lighthouse_start_file = "./private-network-setup/start_lighthouse.sh"
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
	@git submodule update --recursive --remote

.PHONY: install-go
install-go: 
	@chmod +x ${go_setup_file}
	@${go_setup_file} || ([ $$? -eq 33 ] && exit 0) || exit 1


.PHONY: start-geth
start-geth: 
	@chmod +x ${go_setup_file}
	@${go_setup_file} || ([ $$? -eq 33 ] && exit 0) || exit 1

.PHONY: start-lighthouse
start-geth: 
	@chmod +x ${go_setup_file}
	@${go_setup_file} || ([ $$? -eq 33 ] && exit 0) || exit 1

.PHONY: start-lighthouse
start-geth: 
	@chmod +x ${go_setup_file}
	@${go_setup_file} || ([ $$? -eq 33 ] && exit 0) || exit 1

.PHONY: start-lighthouse
start-geth: 
	@chmod +x ${go_setup_file}
	@${go_setup_file} || ([ $$? -eq 33 ] && exit 0) || exit 1
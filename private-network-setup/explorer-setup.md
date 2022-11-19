# Explorer Setup Documentation

First of all, Thanks for the BlockScout Team for an outstanding work for open-source contributions for Explorer compatible for any EVM chain.

## Steps

1. Make sure Execution client used in the archival mode. If not, resync the same node or use a different node.

2. Check the firewall for 7432 & 4000.

3. For simplicity, we have used the `docker-compose` based setup for the explorer.

4. Goto `docker-compose` folder and check the vars in the `./envs/common-blockscout.env`,  You can adjust BlockScout environment variables. For more descriptions of the ENVs are available in the [docs](https://docs.blockscout.com/for-developers/information-and-settings/env-variables).

5. I have used `docker-compose-no-build-geth.yml`, with a minor adjust of adding max connections for the postgres DB.

6. ``` docker-compose -f docker-compose-no-build-geth.yml up -d```.
7. The explorer used in this setup is now running on port 4000.


For inconsistencies or questions, Please try to raise an issue in this repository. 
For self-help or quick fixers, please refer either `https://docs.blockscout.com` or `https://github.com/blockscout/blockscout`

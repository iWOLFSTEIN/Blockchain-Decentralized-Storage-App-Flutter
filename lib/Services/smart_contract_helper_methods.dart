import 'package:blockchain_decentralized_storage_system/structures/node.dart';
import 'package:blockchain_decentralized_storage_system/utils/constants.dart';
import 'package:flutter/services.dart';
import 'package:web3dart/contracts.dart';
import 'package:web3dart/credentials.dart';

Future<DeployedContract> loadContract({path, name, address}) async {
  String abi = await rootBundle.loadString(path);
  final contract = DeployedContract(
      ContractAbi.fromJson(abi, name), EthereumAddress.fromHex(address));
  return contract;
}

Future<List<dynamic>> querySmartContract(
    {String? functionName,
    List<dynamic>? args,
    ethClient,
    contractName,
    contractAddress,
    contractAbiPath}) async {
  final contract = await loadContract(
      name: contractName, path: contractAbiPath, address: contractAddress);
  final ethFunction = contract.function(functionName!);
  final result = await ethClient.call(
      contract: contract, function: ethFunction, params: args);
  return result;
}

Future<List<Node>> getServersAddresses({required ethClient}) async {
  try {
    List<Node> serverAddresses = [];
    var getAllStorageNodesAddresses = await querySmartContract(
        functionName: getStorageContracts,
        args: [],
        ethClient: ethClient,
        contractName: storageNodeFactory,
        contractAddress: FACTORY_CONTRACT_ADDRESS,
        contractAbiPath: "assets/factory-abi.json");

    for (var address in getAllStorageNodesAddresses[0]) {
      var url = await querySmartContract(
          functionName: host,
          args: [],
          ethClient: ethClient,
          contractName: storageNode,
          contractAddress: address.toString(),
          contractAbiPath: "assets/storage-contract-abi.json");
      var node = Node(address.toString(), url[0]);
      serverAddresses.add(node);
    }

    return serverAddresses;
  } catch (e) {
    print(e.toString());
    return [];
  }
}
